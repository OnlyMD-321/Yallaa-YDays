import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../widgets/reservation_card.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reservationService = ReservationService();

  List<Reservation> _allReservations = [];
  List<Reservation> _upcomingReservations = [];
  List<Reservation> _pastReservations = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: 'All (${_allReservations.length})'),
            Tab(text: 'Upcoming (${_upcomingReservations.length})'),
            Tab(text: 'Past (${_pastReservations.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReservationsList(_allReservations),
                _buildReservationsList(_upcomingReservations),
                _buildReservationsList(_pastReservations),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to search screen to make new reservation
          Navigator.pushNamed(context, '/search');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReservationsList(List<Reservation> reservations) {
    if (reservations.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ReservationCard(
              reservation: reservation,
              onTap: () => _showReservationDetails(reservation),
              onCancel: reservation.canCancel
                  ? () => _showCancelDialog(reservation)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No reservations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by searching for services',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: const Icon(Icons.search),
            label: const Text('Find Services'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reservations = await _reservationService.getUserReservations();

      setState(() {
        _allReservations = reservations;
        _upcomingReservations = reservations
            .where(
              (r) =>
                  r.reservationDate.isAfter(DateTime.now()) &&
                  (r.status == ReservationStatus.pending ||
                      r.status == ReservationStatus.confirmed),
            )
            .toList();
        _pastReservations = reservations
            .where(
              (r) =>
                  r.reservationDate.isBefore(DateTime.now()) ||
                  r.status == ReservationStatus.completed ||
                  r.status == ReservationStatus.cancelled,
            )
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reservations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showReservationDetails(Reservation reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  'Reservation Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Reservation details
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Événement', reservation.eventName),
                        if (reservation.eventDescription != null)
                          _buildDetailRow(
                            'Description',
                            reservation.eventDescription!,
                          ),
                        _buildDetailRow(
                          'Date',
                          _formatDate(reservation.reservationDate),
                        ),
                        _buildDetailRow('Time', reservation.timeSlot),
                        _buildDetailRow('Status', reservation.statusText),
                        if (reservation.location != null)
                          _buildDetailRow('Location', reservation.location!),
                        if (reservation.price != null)
                          _buildDetailRow(
                            'Price',
                            '\$${reservation.price!.toStringAsFixed(2)}',
                          ),
                        if (reservation.notes != null)
                          _buildDetailRow('Notes', reservation.notes!),
                        _buildDetailRow(
                          'Booked On',
                          _formatDate(reservation.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                if (reservation.canCancel) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showCancelDialog(reservation);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Cancel Reservation'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _showCancelDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Reservation'),
        content: Text(
          'Êtes-vous sûr de vouloir annuler votre réservation pour ${reservation.eventName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Reservation'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelReservation(reservation);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Reservation'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    try {
      await _reservationService.cancelReservation(reservation.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Reload reservations
      await _loadReservations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel reservation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
