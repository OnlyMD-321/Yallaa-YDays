import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/listing.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(),
                  color: _getCategoryColor(),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.blackColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    if (category.color != null) {
      return Color(int.parse(category.color!.replaceFirst('#', '0xff')));
    }

    // Default colors based on category name
    switch (category.name.toLowerCase()) {
      case 'restaurants':
      case 'food':
        return AppTheme.foodPrimary;
      case 'hotels':
      case 'accommodation':
        return AppTheme.secondaryColor;
      case 'activities':
      case 'entertainment':
        return AppTheme.accentColor;
      case 'transport':
      case 'travel':
        return AppTheme.infoColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCategoryIcon() {
    if (category.icon != null) {
      // Map icon names to IconData
      switch (category.icon!.toLowerCase()) {
        case 'restaurant':
          return Icons.restaurant;
        case 'hotel':
          return Icons.hotel;
        case 'activities':
          return Icons.local_activity;
        case 'transport':
          return Icons.directions_car;
        case 'shopping':
          return Icons.shopping_bag;
        case 'health':
          return Icons.local_hospital;
        case 'beauty':
          return Icons.face;
        case 'sports':
          return Icons.sports_tennis;
        default:
          return Icons.category;
      }
    }

    // Default icons based on category name
    switch (category.name.toLowerCase()) {
      case 'restaurants':
      case 'food':
        return Icons.restaurant;
      case 'hotels':
      case 'accommodation':
        return Icons.hotel;
      case 'activities':
      case 'entertainment':
        return Icons.local_activity;
      case 'transport':
      case 'travel':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.local_hospital;
      case 'beauty':
        return Icons.face;
      case 'sports':
        return Icons.sports_tennis;
      default:
        return Icons.category;
    }
  }
}
