import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/constants.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await AuthService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YnovNetwork',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent, // Used for FAB, active elements
          surface: AppColors.surface, // Card backgrounds, dialogs
          error: AppColors.error,
          onPrimary: AppColors.textLight, // Text/icons on primary color
          onSecondary: AppColors.textLight, // Text/icons on secondary color
          onSurface: AppColors.textDark, // Text/icons on surface color
          onError: AppColors.textLight, // Text/icons on error color
          brightness: Brightness.light, // Assuming a light theme
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight, // For title and icons in AppBar
          elevation: 1.0, // Subtle shadow
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600, // Semi-bold
            color: AppColors.textLight,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ), // For card titles, screen titles
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: AppColors.textDark,
          ), // Default body text
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: AppColors.textMedium,
          ), // Secondary text
          labelLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ), // For button text
          bodySmall: TextStyle(
            fontSize: 12.0,
            color: AppColors.textHint,
          ), // Hint text, captions
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          hintStyle: const TextStyle(color: AppColors.textHint),
          labelStyle: const TextStyle(color: AppColors.textMedium),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          // Changed from CardTheme to CardThemeData
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: AppColors.border, width: 0.5),
          ),
          color: AppColors.surface,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textLight,
        ), // useMaterial3: true, // Consider enabling Material 3 for a more modern look if your Flutter version supports it well
      ),
      initialRoute: isLoggedIn ? '/main' : '/login',
      routes: appRoutes,
    );
  }
}
