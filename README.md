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

### 📱 3. Navigation & Profile
- **3-Tab Bottom Navigation**: Switch smoothly between Notes List, Add Note form, and Profile view.
- **Profile Tab**: View display name, email, authentication provider type, and copyable user UID. Contains a log out button.

### 🎨 4. UX & Aesthetic Elements
- **Layout Toggles**: Switch between **List View** and **Grid View** layout styles.
- **Real-time Live Search**: Instant client-side search query filtering by title or description content.
- **Micro-Animations**: Smooth visual feedback transitions (using `AnimatedSwitcher`, hover states, custom circular background blobs).
- **Responsive Theme**: Forest Green Modern Color palette utilizing Google Fonts (`Outfit`).

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