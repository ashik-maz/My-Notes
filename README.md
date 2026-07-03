# Quick Notes - Flutter Notes Management App 📝

A sleek, modern, and beautiful Notes Management Application built with Flutter and Cloud Firestore. Created for the **Ostad Module 6 Assignment**.

This project demonstrates full **CRUD (Create, Read, Update, Delete)** operations synced in real-time with Firebase Cloud Firestore.

---

## ✨ Features

- **Beautiful Responsive UI**: Tailored with a custom violet/teal color palette, glassmorphism elements, custom cards, and smooth micro-animations.
- **Real-Time Synchronization**: Stream notes directly from Cloud Firestore with instant state updates.
- **Dynamic Views**: Instantly switch between **List View** and **Grid View** layout styles.
- **Search Filtering**: Live client-side search to filter notes by title or description instantly.
- **CRUD Operations**:
  - **Create**: Add notes with validated title and description inputs.
  - **Read**: Elegant stream list sorted by newest creation timestamp.
  - **Update**: Edit title/description inside the input form.
  - **Delete**: Safely delete notes with an alert dialog confirmation.
- **Offline/Demo Fallback**: If Firebase is not configured, the app automatically switches to an in-memory "Demo Mode" list, allowing you to test the entire application interface instantly without setup errors!

---

## 🛠️ Tech Stack & Packages

- **Framework**: [Flutter](https://flutter.dev) (v3.41.6 stable)
- **Database**: [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- **Typography**: [Google Fonts (Outfit)](https://pub.dev/packages/google_fonts)
- **Loading Indicators**: [Flutter SpinKit](https://pub.dev/packages/flutter_spinkit)
- **Date Formatting**: [Intl](https://pub.dev/packages/intl)

---

## 🚀 How to Run & Connect to Firebase

By default, the app compiles out-of-the-box and runs in **Demo Mode**. To link it to your own **Cloud Firestore Database**, follow these steps:

### 1. Install FlutterFire CLI
Make sure you have Node.js / npm installed and the Firebase CLI tool.
Then, activate the FlutterFire CLI globally in your terminal:
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase
In your terminal, navigate to the root directory of this project (`NoteApp`) and run:
```bash
flutterfire configure
```
- Select your Firebase project (or create a new one).
- Select the platforms you want to support (Android, iOS, Web).
- This command will automatically generate `lib/firebase_options.dart` with your unique configuration, replacing the initial mock placeholder.

### 3. Setup Firestore Rules
Go to the [Firebase Console](https://console.firebase.google.com/), click on your project, navigate to **Firestore Database**, and create a database.
Under the **Rules** tab, enable read/write access for development:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // For testing purposes
    }
  }
}
```

### 4. Run the Project
Compile and run the project locally on your emulator, browser, or device:
```bash
flutter run
```

---

## 🤝 Submission & Git Setup

To submit this project as required by the Ostad assignment:

1. Create a new **public** repository on your GitHub account named `NoteApp` or similar.
2. Open your terminal in this directory and execute:
```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "feat: complete notes management app with Cloud Firestore integration"

# Rename default branch to main
git branch -M main

# Link to your remote GitHub repo
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME.git

# Push code to GitHub
git push -u origin main
```
3. Share your public GitHub repository URL link on the Ostad submission page!
