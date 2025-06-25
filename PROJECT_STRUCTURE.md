# YDays Mobile Flutter App

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── exports.dart             # Centralized exports
├── config/                  # Configuration files
│   ├── routes.dart         # App routing configuration
│   └── api_config.dart     # API endpoints and configuration
├── models/                  # Data models
│   ├── user.dart           # User model
│   ├── auth.dart           # Authentication models
│   ├── service.dart        # Service model
│   ├── reservation.dart    # Reservation model
│   └── search_filters.dart # Search filters model
├── screens/                 # UI screens
│   ├── login_screen.dart   # Login/authentication screen
│   ├── home_screen.dart    # Main dashboard screen
│   ├── search_screen.dart  # Service search and filters
│   └── reservations_screen.dart # User reservations management
├── services/               # API and business logic
│   ├── api_client.dart     # HTTP client with Dio
│   ├── auth_service.dart   # Authentication API calls
│   ├── service_service.dart # Service-related API calls
│   └── reservation_service.dart # Reservation API calls
└── widgets/                # Reusable UI components
    ├── custom_button.dart  # Custom button widget
    ├── custom_text_field.dart # Custom text input widget
    ├── service_card.dart   # Service display card
    └── reservation_card.dart # Reservation display card
```

## Features

### Authentication
- Login screen with email/password validation
- JWT token management
- Auto-login on app restart
- Secure logout functionality

### Service Search & Discovery
- Search services by name/keyword
- Advanced filtering by:
  - Category
  - Location  
  - Price range
  - Rating
- Sort results by various criteria
- Service cards with images, ratings, and details

### Reservations Management
- View all reservations (upcoming, past, all)
- Detailed reservation information
- Cancel reservations (when allowed)
- Create new reservations
- Real-time status updates

### UI/UX Features
- Modern Material Design 3 interface
- Responsive design for different screen sizes
- Loading states and error handling
- Success/error notifications
- Pull-to-refresh functionality
- Bottom navigation for easy access

## Dependencies

- **dio**: HTTP client for API communication
- **provider**: State management
- **shared_preferences**: Local data storage
- **email_validator**: Email validation
- **flutter_spinkit**: Loading indicators

## API Integration

The app uses Dio for HTTP requests with:
- Automatic token injection
- Request/response interceptors
- Error handling
- Timeout configuration
- Base URL configuration

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure API endpoints in `lib/config/api_config.dart`

3. Run the app:
   ```bash
   flutter run
   ```

## Architecture

The app follows a clean architecture pattern:
- **Models**: Data structures and business entities
- **Services**: API communication and business logic
- **Screens**: UI pages and user interactions
- **Widgets**: Reusable UI components
- **Config**: App configuration and routing

## State Management

Using Provider for:
- Authentication state
- User session management
- App-wide configuration

## Navigation

Centralized routing system with:
- Named routes
- Route guards (authentication required)
- Deep linking support
- Smooth transitions

## Error Handling

Comprehensive error handling for:
- Network errors
- API errors
- Validation errors
- User-friendly error messages
- Retry mechanisms
