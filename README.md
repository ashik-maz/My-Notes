# Quick Notes - Flutter Notes Management App 📝

A sleek, responsive, and beautiful Notes Management Application built with **Flutter**, **Firebase Cloud Firestore**, and **Firebase Authentication**. Created for the **Ostad Module 6 Assignment**.

Refactored utilizing **Clean Architecture** to maintain clean boundaries between domain logic, data models/datasources, and presentation states.

---

## ✨ Features

### 🔑 1. Authentication (Auth)
- **Email & Password Login**: Full client-side input validation and responsive error feedback.
- **User Registration**: Register with Name, Email, and Password with confirm password matches.
- **Forgot Password**: Password recovery stream that sends a reset link to the email.
- **Continue with Google**: Seamless OAuth integration utilizing native Google Sign-In.
- **Demo Mode fallback**: If offline or Firebase is not configured, the app launches instantly in Demo Mode using an in-memory session.

### 📝 2. Notes Management (CRUD - Account Personalized)
- **Account Isolation**: Every note is bound to the logged-in user's account (`userId`). Users only query and modify their own notes.
- **Create**: Add a note with validated title and description forms.
- **Read**: Live real-time streams displaying note cards sorted by the newest timestamp.
- **Update**: Edit the note title and description inside a prefilled form.
- **Delete**: Action button and confirmation dialogs to prevent accidental note removals.

### 🎨 3. UX & Aesthetic Elements
- **Layout Toggles**: Switch between **List View** and **Grid View** layout styles.
- **Real-time Live Search**: Instant client-side search query filtering by title or description content.
- **Micro-Animations**: Smooth visual feedback transitions (using `AnimatedSwitcher`, hover states, custom circular background blobs).
- **Responsive Theme**: Indigo & Teal Modern Color palette utilizing Google Fonts (`Outfit`).

---

## 🏗️ Architecture Design (Clean Architecture)

The codebase strictly adheres to **Clean Architecture** principles, splitting concerns into three distinct layers structured by features:

```
lib/
├── core/
│   └── usecase/              # Base standard Usecase interfaces
├── features/
│   ├── auth/                 # Authentication Feature
│   │   ├── domain/           # Entities, Repository Interfaces, Use Cases
│   │   ├── data/             # Models (DTOs), Remote Data Sources, Repositories Impl
│   │   └── presentation/     # Controllers (Notifiers), UI Screens
│   └── notes/                # Notes Feature (CRUD)
│       ├── domain/           # Entities, Repository Interfaces, Use Cases
│       ├── data/             # Models (DTOs), Remote Data Sources, Repositories Impl
│       └── presentation/     # Controllers (Notifiers), UI Screens
├── auth_wrapper.dart         # Authentication state router
├── service_locator.dart      # Custom Dependency Injection service container
└── main.dart                 # Application entry point
```

### Dependency Injection (DI)
Managed via a custom service locator container in [service_locator.dart](file:///c:/Users/Ashikuzzaman/Desktop/NoteApp/lib/service_locator.dart). It instantiates singletons for Data Sources, Repositories, Use Cases, and Controllers (`ChangeNotifier` State Notifiers) to completely decouple creation logic from widgets.

---

## 🚀 Setup & Firebase Configuration

### 🔑 Google Sign-In Credentials (SHA Keys)
To enable Google Authentication, copy these SHA fingerprints and add them under your **Firebase Console → Project Settings → Android App**:
- **SHA-1 Fingerprint**: `EF:28:D9:0D:F6:DE:30:42:0C:9D:7B:7D:5E:3B:75:E3:CF:0F:4B:5D`
- **SHA-256 Fingerprint**: `1E:99:10:2F:96:36:85:01:09:D2:8A:D6:6C:96:80:F7:99:CC:DD:B8:11:6C:3F:53:54:F3:09:15:6F:0B:E3:7E`

### 🛠️ Step-by-Step Connection Guide
1. Create a Firebase Project in the [Firebase Console](https://console.firebase.google.com).
2. Enable **Email/Password** and **Google** sign-in providers in the **Firebase Auth** panel.
3. Enable **Cloud Firestore** and configure database access rules to allow reads and writes.
4. Activate the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
5. Configure your app by running in the project root:
   ```bash
   flutterfire configure --project=notemanagement-task
   ```
6. Add the local SHA fingerprints to the Android configuration inside the console.

---

## 🛠️ Build and Running Instructions

### Run the App
Launch the Flutter development server (supports Android, iOS, and Web):
```bash
flutter run
```

### Run Tests
Ensure all unit/widget tests pass cleanly:
```bash
flutter test
```

### Code Quality Analysis
Verify type safety and project health:
```bash
flutter analyze
```

---

## 📦 Core Dependencies
- `firebase_core`: Base Firebase framework initialization.
- `firebase_auth`: User account credentials, email management, and sessions.
- `google_sign_in`: OAuth launcher for Google accounts.
- `cloud_firestore`: Realtime Cloud database streams.
- `google_fonts`: Outfit responsive typography.
- `flutter_spinkit`: Loading indicators.
- `intl`: Localized date-time formatting.
