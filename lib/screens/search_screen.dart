import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/search_filters.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _eventService = EventService();

  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  SearchFilters _filters = SearchFilters();
  List<String> _categories = [];
  List<String> _locations = [];

  bool _isLoading = false;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher des événements'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_filters.hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher des événements...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Filters Panel
          if (_showFilters) _buildFiltersPanel(),

          // Events List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEvents.isEmpty
                ? _buildEmptyState()
                : _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Category Filter
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filters.category,
                hint: const Text('Select category'),
                isExpanded: true,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category == 'All' ? null : category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(category: value);
                  });
                  _applyFilters();
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Location Filter
          const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filters.location,
                hint: const Text('Select location'),
                isExpanded: true,
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location == 'All' ? null : location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(location: value);
                  });
                  _applyFilters();
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Min price',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    setState(() {
                      _filters = _filters.copyWith(minPrice: price);
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Max price',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    setState(() {
                      _filters = _filters.copyWith(maxPrice: price);
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(event: event),
                ),
              );
            },
            onFavorite: () {
              // TODO: Handle favorite toggle
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${event.title} to favorites')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No services found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final [events, categories, locations] = await Future.wait([
        _eventService.getAllEvents(),
        _eventService.getCategories(),
        _eventService.getDistricts(),
      ]);

      setState(() {
        _events = events as List<Event>;
        _filteredEvents = _events;
        _categories = categories as List<String>;
        _locations = locations as List<String>;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
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

  void _onSearchChanged(String query) {
    // Implement debounced search here if needed
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty && !_filters.hasActiveFilters) {
      setState(() {
        _filteredEvents = _events;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _eventService.searchEvents(
        query: query.isEmpty ? null : query,
        filters: _filters,
      );

      setState(() {
        _filteredEvents = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: $e'),
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

  void _applyFilters() {
    _performSearch();
  }

  void _clearFilters() {
    setState(() {
      _filters = SearchFilters();
      _searchController.clear();
    });
    _performSearch();
  }
}
