import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/listings/listings_screen.dart';
import '../screens/listings/listing_detail_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/booking_detail_screen.dart';
import '../screens/booking/bookings_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const BookingsListScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Listing Routes
      GoRoute(
        path: '/listings',
        builder: (context, state) => const ListingsScreen(),
      ),
      GoRoute(
        path: '/listing/:id',
        builder: (context, state) =>
            ListingDetailScreen(listingId: state.pathParameters['id']!),
      ),

      // Booking Routes
      GoRoute(
        path: '/booking/:listingId',
        builder: (context, state) =>
            BookingScreen(listingId: state.pathParameters['listingId']!),
      ),
      GoRoute(
        path: '/booking-detail/:id',
        builder: (context, state) =>
            BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),

      // Profile Routes
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isClient = authProvider.isClient;
      final isOnAuthRoute =
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password');
      final isOnSplash = state.matchedLocation == '/splash';

      // If not authenticated and not on auth route or splash, redirect to login
      if (!isAuthenticated && !isOnAuthRoute && !isOnSplash) {
        return '/login';
      }

      // If authenticated but not a client (e.g., admin/partner), show error and logout
      if (isAuthenticated && !isClient && !isOnAuthRoute && !isOnSplash) {
        // This mobile app is only for clients
        authProvider.signOut();
        return '/login';
      }

      // If authenticated and on auth route, redirect to home
      if (isAuthenticated && isClient && isOnAuthRoute) {
        return '/home';
      }

      // No redirect needed
      return null;
    },
  );
}
