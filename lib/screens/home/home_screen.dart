import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/catalog_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/listing.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final catalogProvider = context.read<CatalogProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    await Future.wait([
      catalogProvider.loadPersonalizedFeed(refresh: true),
      catalogProvider.loadListings(refresh: true),
      notificationProvider.loadNotifications(limit: 5),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(child: _buildHeader()),

              // Search Bar
              SliverToBoxAdapter(child: _buildSearchBar()),

              // Promotional Carousel
              SliverToBoxAdapter(child: _buildPromotionalCarousel()),

              // Quick Actions
              SliverToBoxAdapter(child: _buildQuickActions()),

              // Categories
              SliverToBoxAdapter(child: _buildCategoriesSection()),

              // Personalized Feed
              SliverToBoxAdapter(child: _buildPersonalizedFeed()),

              // Popular Listings
              SliverToBoxAdapter(child: _buildPopularListings()),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer2<AuthProvider, NotificationProvider>(
      builder: (context, authProvider, notificationProvider, child) {
        final user = authProvider.user;
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: user?.profilePicture != null
                      ? CachedNetworkImageProvider(user!.profilePicture!)
                      : null,
                  child: user?.profilePicture == null
                      ? Text(
                          user?.initials ?? 'U',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 12),

              // Welcome Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    Text(
                      user?.firstName ?? 'Guest',
                      style: AppTheme.headingSmall.copyWith(
                        color: AppTheme.blackColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification Bell
              Stack(
                children: [
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.blackColor,
                      size: 26,
                    ),
                  ),
                  if (notificationProvider.hasUnreadNotifications)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${notificationProvider.unreadCount}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.whiteColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: CustomSearchField(
        controller: _searchController,
        hint: 'Search restaurants, hotels, activities...',
        onTap: () => context.push('/search'),
        readOnly: true,
      ),
    );
  }

  Widget _buildPromotionalCarousel() {
    final promoItems = [
      {
        'image':
            'https://via.placeholder.com/400x200/6C5CE7/FFFFFF?text=Special+Offer',
        'title': 'Summer Special',
        'subtitle': 'Up to 30% off on selected hotels',
        'color': AppTheme.primaryColor,
      },
      {
        'image':
            'https://via.placeholder.com/400x200/74B9FF/FFFFFF?text=New+Restaurants',
        'title': 'New Restaurants',
        'subtitle': 'Discover amazing food experiences',
        'color': AppTheme.secondaryColor,
      },
      {
        'image':
            'https://via.placeholder.com/400x200/FD79A8/FFFFFF?text=Activities',
        'title': 'Adventure Awaits',
        'subtitle': 'Book exciting activities near you',
        'color': AppTheme.accentColor,
      },
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          CarouselSlider(
            items: promoItems.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      item['color'] as Color,
                      (item['color'] as Color).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: AppTheme.headingMedium.copyWith(
                              color: AppTheme.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'] as String,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.whiteColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              viewportFraction: 0.85,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: promoItems.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == entry.key
                      ? AppTheme.primaryColor
                      : AppTheme.lightGrey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final quickActions = [
      {
        'icon': Icons.restaurant,
        'label': 'Restaurants',
        'color': AppTheme.foodPrimary,
        'route': '/listings?category=restaurants',
      },
      {
        'icon': Icons.hotel,
        'label': 'Hotels',
        'color': AppTheme.secondaryColor,
        'route': '/listings?category=hotels',
      },
      {
        'icon': Icons.local_activity,
        'label': 'Activities',
        'color': AppTheme.accentColor,
        'route': '/listings?category=activities',
      },
      {
        'icon': Icons.favorite,
        'label': 'Favorites',
        'color': AppTheme.errorColor,
        'route': '/favorites',
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: quickActions.map((action) {
          return GestureDetector(
            onTap: () => context.push(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Consumer<CatalogProvider>(
      builder: (context, catalogProvider, child) {
        final categories = catalogProvider.categories;

        if (categories.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/search'),
                    child: Text(
                      'See All',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () =>
                        context.push('/listings?category=${category.id}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildPersonalizedFeed() {
    return Consumer<CatalogProvider>(
      builder: (context, catalogProvider, child) {
        final personalizedListings = catalogProvider.personalizedFeed;

        if (personalizedListings.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended for You',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/listings'),
                    child: Text(
                      'See All',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: personalizedListings.length,
                itemBuilder: (context, index) {
                  final listing = personalizedListings[index];
                  return SizedBox(
                    width: 240,
                    child: ListingCard(
                      listing: listing,
                      onTap: () => context.push('/listing/${listing.id}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildPopularListings() {
    return Consumer<CatalogProvider>(
      builder: (context, catalogProvider, child) {
        final listings = catalogProvider.listings.take(6).toList();

        if (listings.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Near You',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/listings'),
                    child: Text(
                      'See All',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return ListingCard(
                  listing: listing,
                  onTap: () => context.push('/listing/${listing.id}'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
