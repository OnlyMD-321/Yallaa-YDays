import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/reservation_service.dart';
import '../widgets/custom_button.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final ReservationService _reservationService = ReservationService();

  String? _selectedTimeSlot;
  bool _isLoading = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            flexibleSpace: FlexibleSpaceBar(
              background: widget.event.image != null
                  ? Image.network(
                      widget.event.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.event,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.event,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.event.category,
                          style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Organizer
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Organisé par ${widget.event.organizerName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Price and Rating
                  Row(
                    children: [
                      Text(
                        widget.event.formattedPrice,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A085),
                        ),
                      ),
                      const Spacer(),
                      if (widget.event.rating != null) ...[
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.event.ratingText,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Date and Location
                  _buildInfoCard(
                    title: 'Informations',
                    children: [
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Date',
                        widget.event.dateRange,
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(
                        Icons.location_on,
                        'Lieu',
                        '${widget.event.location}, ${widget.event.district}',
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(
                        Icons.people,
                        'Participants',
                        widget.event.participantsText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  _buildInfoCard(
                    title: 'Description',
                    children: [
                      Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  if (widget.event.tags.isNotEmpty) ...[
                    _buildInfoCard(
                      title: 'Tags',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.event.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Time Slots Selection
                  if (widget.event.availableTimeSlots.isNotEmpty) ...[
                    _buildInfoCard(
                      title: 'Choisir un créneau',
                      children: [
                        Column(
                          children: widget.event.availableTimeSlots
                              .map(
                                (slot) => RadioListTile<String>(
                                  title: Text(slot),
                                  value: slot,
                                  groupValue: _selectedTimeSlot,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTimeSlot = value;
                                    });
                                  },
                                  activeColor: const Color(0xFFFF6B35),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Notes
                  _buildInfoCard(
                    title: 'Notes (optionnel)',
                    children: [
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText:
                              'Ajoutez des notes pour votre réservation...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Reservation Button
                  if (widget.event.isAvailable) ...[
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: _isLoading
                            ? 'Réservation...'
                            : 'Réserver maintenant',
                        onPressed: _selectedTimeSlot != null && !_isLoading
                            ? _makeReservation
                            : null,
                        backgroundColor: const Color(0xFFFF6B35),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.event.statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFF6B35), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Future<void> _makeReservation() async {
    if (_selectedTimeSlot == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _reservationService.createReservation(
        eventId: widget.event.id,
        reservationDate: widget.event.startDate,
        timeSlot: _selectedTimeSlot!,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation créée avec succès !'),
            backgroundColor: Color(0xFF00A085),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
