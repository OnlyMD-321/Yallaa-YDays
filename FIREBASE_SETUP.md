# Firebase Setup Instructions for Yallaa Mobile App

## 🔧 Setup Required

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "yallaa-project"
3. Enable Authentication and Firestore Database

### 2. Configure Firebase for Flutter
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login to Firebase: `firebase login`
3. Navigate to your Flutter project directory
4. Run: `flutterfire configure`
5. Select your Firebase project
6. This will generate the correct `firebase_options.dart` file

### 3. Update Firebase Configuration
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration values.

### 4. Enable Authentication Methods
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable "Email/Password" authentication
3. Configure any additional settings as needed

### 5. Set up Firestore Database
1. Go to Firebase Console → Firestore Database
2. Create database in production mode
3. Set up security rules for the `users` collection

### 6. Install Dependencies
Run: `flutter pub get`

## 🔐 Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add other collection rules as needed
  }
}
```

## 📱 Features Implemented

✅ **Client-Only Authentication**: Only users with 'client' or 'customer' role can access the app  
✅ **Email/Password Sign-in**: Direct Firebase Auth integration  
✅ **Email Verification**: Automatic email verification on sign-up  
✅ **Password Reset**: Reset password via email  
✅ **Profile Management**: Update user profile information  
✅ **Role Validation**: Prevents non-client users from accessing the app  
✅ **Auto Sign-out**: Automatically signs out non-client users  

## 🚀 How It Works

1. **Sign Up**: Creates Firebase Auth user + Firestore document with 'client' role
2. **Sign In**: Validates Firebase Auth + checks role in Firestore
3. **Client-Only**: Redirects non-client users to login and signs them out
4. **Profile**: Syncs between Firebase Auth and Firestore user document
5. **Security**: Client-only validation happens on both sign-in and sign-up

The mobile app now uses Firebase Auth directly instead of backend API calls, providing better security and offline capabilities.
