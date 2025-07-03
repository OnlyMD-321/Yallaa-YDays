import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_theme.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/listing_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        elevation: 0,
        title: Text(
          'Search',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.blackColor),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.whiteColor,
              child: CustomSearchField(
                controller: _searchController,
                hint: 'Search for restaurants, hotels, activities...',
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    context.read<CatalogProvider>().loadListings(
                      refresh: true,
                      search: query,
                    );
                  }
                },
              ),
            ),

            // Results
            Expanded(
              child: Consumer<CatalogProvider>(
                builder: (context, catalogProvider, child) {
                  if (catalogProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (catalogProvider.listings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: AppTheme.lightGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for amazing experiences',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: catalogProvider.listings.length,
                    itemBuilder: (context, index) {
                      final listing = catalogProvider.listings[index];
                      return ListingCard(
                        listing: listing,
                        onTap: () => context.push('/listing/${listing.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
