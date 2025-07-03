import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../models/listing.dart';
import '../providers/catalog_provider.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.blackColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: listing.hasImages
                        ? CachedNetworkImage(
                            imageUrl: listing.firstImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.lightGrey,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.lightGrey,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppTheme.darkGrey,
                                size: 48,
                              ),
                            ),
                          )
                        : Container(
                            color: AppTheme.lightGrey,
                            child: Icon(
                              Icons.image,
                              color: AppTheme.darkGrey,
                              size: 48,
                            ),
                          ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Consumer<CatalogProvider>(
                    builder: (context, catalogProvider, child) {
                      final isFavorite = catalogProvider.isFavorite(listing.id);
                      return GestureDetector(
                        onTap: () => catalogProvider.toggleFavorite(listing.id),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.whiteColor.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? AppTheme.errorColor
                                : AppTheme.darkGrey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Category Badge
                if (listing.category != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        listing.category!.name,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: AppTheme.headingSmall.copyWith(
                            color: AppTheme.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppTheme.warningColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${listing.averageRating.toStringAsFixed(1)}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.darkGrey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    listing.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.darkGrey,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Price and Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.darkGrey,
                            ),
                          ),
                          Text(
                            listing.priceFormatted,
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Book Now',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompactListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;

  const CompactListingCard({super.key, required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.blackColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 80,
                height: 80,
                child: listing.hasImages
                    ? CachedNetworkImage(
                        imageUrl: listing.firstImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: AppTheme.lightGrey),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.lightGrey,
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppTheme.darkGrey,
                            size: 24,
                          ),
                        ),
                      )
                    : Container(
                        color: AppTheme.lightGrey,
                        child: Icon(
                          Icons.image,
                          color: AppTheme.darkGrey,
                          size: 24,
                        ),
                      ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppTheme.darkGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.location,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          listing.priceFormatted,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.warningColor,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${listing.averageRating.toStringAsFixed(1)}',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
