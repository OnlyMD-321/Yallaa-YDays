import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_theme.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/listing_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Load listings that are marked as favorites
    await context.read<CatalogProvider>().loadListings(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        elevation: 0,
        title: Text(
          'Favorites',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.blackColor),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CatalogProvider>(
        builder: (context, catalogProvider, child) {
          if (catalogProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteListings = catalogProvider.listings
              .where((listing) => catalogProvider.isFavorite(listing.id))
              .toList();

          if (favoriteListings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppTheme.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start exploring and add your favorite places',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteListings.length,
            itemBuilder: (context, index) {
              final listing = favoriteListings[index];
              return ListingCard(
                listing: listing,
                onTap: () => context.push('/listing/${listing.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
