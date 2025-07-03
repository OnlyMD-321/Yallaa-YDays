# 🎯 Yallaa Mobile App - Firebase Authentication Implementation

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-orange.svg)](https://firebase.google.com/)
[![Client-Only](https://img.shields.io/badge/Access-Client%20Only-green.svg)](#)

## 📋 Project Overview

This is the **Yallaa Mobile App** - a client-only Flutter application for customers to book amazing experiences. The app has been completely rewritten with **Firebase Authentication** and is designed exclusively for customer use.

## 🔥 Latest Implementation (Current Branch: `Mouad`)

### ✅ **Complete Firebase Authentication System**
- **Client-Only Access**: Only users with 'client' or 'customer' role can access the app
- **Firebase Auth Integration**: Direct Firebase Authentication (no backend API dependencies)
- **Real-time Auth State**: Automatic auth state management and updates
- **Email Verification**: Built-in email verification on sign-up
- **Password Reset**: Secure password reset via email
- **Role Validation**: Multiple layers of client role validation

### 🔐 **Security Features**
- **Role-Based Access Control**: Prevents partners/admins from accessing mobile app
- **Auto Sign-Out**: Non-client users are automatically signed out
- **Client-Only Registration**: Forces 'client' role on all new registrations
- **Clear UI Messaging**: App clearly states it's for customers only

### 📱 **App Architecture**
- **Modern Flutter**: Latest Flutter 3.8.1 with null safety
- **Provider State Management**: Clean state management with Provider pattern
- **Custom UI Components**: Beautiful, modern UI with custom themes
- **Navigation**: Go Router for clean navigation management
- **Offline-First**: Firebase Auth works offline

## 🛠️ **Setup Instructions**

### 1. **Prerequisites**
```bash
flutter --version  # Ensure Flutter 3.8.1+
dart --version     # Ensure Dart SDK 3.0+
```

### 2. **Clone Repository**
```bash
git clone https://github.com/OnlyMD-321/Yallaa-YDays.git
cd Yallaa-YDays
git checkout Mouad  # Switch to the latest implementation branch
```

### 3. **Install Dependencies**
```bash
flutter pub get
```

### 4. **Firebase Setup** (Required)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure Firebase for Flutter (this replaces firebase_options.dart)
flutterfire configure
```

### 5. **Firebase Console Configuration**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project created by `flutterfire configure`
3. **Enable Authentication**:
   - Go to Authentication → Sign-in method
   - Enable "Email/Password"
4. **Create Firestore Database**:
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules (see below)

### 6. **Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 7. **Run the App**
```bash
flutter run
```

## 📁 **Project Structure**

```
lib/
├── config/             # App configuration
│   ├── app_config.dart     # App constants and config
│   ├── app_router.dart     # Navigation routes
│   └── app_theme.dart      # UI theme and styling
├── firebase_options.dart  # Firebase configuration (auto-generated)
├── models/             # Data models
├── providers/          # State management providers
├── screens/            # UI screens
│   ├── auth/              # Authentication screens
│   ├── booking/           # Booking management
│   ├── home/              # Home and navigation
│   ├── listings/          # Browse listings
│   ├── profile/           # User profile
│   └── ...
├── services/           # Business logic services
│   ├── firebase_auth_service.dart  # Firebase Auth wrapper
│   ├── api_service.dart           # API communication
│   └── ...
└── widgets/            # Reusable UI components
```

## 🎯 **Key Features**

### For Customers:
- ✅ **Sign Up/Sign In** with email and password
- ✅ **Browse Listings** - Activities, events, restaurants
- ✅ **Book Experiences** - Easy booking process
- ✅ **Manage Bookings** - View and manage reservations
- ✅ **Favorites** - Save favorite listings
- ✅ **Profile Management** - Update personal information
- ✅ **Search & Filter** - Find exactly what you're looking for

### Security & Access Control:
- ✅ **Client-Only Access** - Partners and admins cannot access mobile app
- ✅ **Role Validation** - Multiple validation layers
- ✅ **Auto Sign-Out** - Non-clients are immediately signed out
- ✅ **Clear Messaging** - UI clearly states app is for customers only

## 📚 **Documentation**

- [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md) - Detailed Firebase setup instructions
- [`FIREBASE_IMPLEMENTATION_SUMMARY.md`](FIREBASE_IMPLEMENTATION_SUMMARY.md) - Complete implementation details
- [`IMPLEMENTATION_STATUS.md`](IMPLEMENTATION_STATUS.md) - Current implementation status

## 🔧 **Development**

### Branch Information:
- **`Mouad`** - Latest Firebase implementation (recommended)
- **`main`** - May contain older implementation

### Commands:
```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Build for production
flutter build apk  # Android
flutter build ios  # iOS
```

## 🚀 **Deployment**

The app is ready for deployment once Firebase is properly configured. The authentication system is production-ready and secure.

## 📞 **Support**

If you need help with setup or have questions about the implementation, refer to the documentation files or check the commit history for detailed implementation notes.

---

**Note**: This mobile app is designed exclusively for customers. Partners and administrators should use the web dashboard for their respective functionalities.
