import 'package:flutter/material.dart';
import '../screens/yallaa_login_screen.dart';
import '../screens/search_screen.dart';
import '../screens/reservations_screen.dart';
import '../screens/yallaa_home_screen.dart';
import '../screens/map_view_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String reservations = '/reservations';
  static const String mapView = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case reservations:
        return MaterialPageRoute(builder: (_) => const ReservationsScreen());
      case mapView:
        return MaterialPageRoute(builder: (_) => const MapViewScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
