# efood

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
Here's a solid folder structure for your **Online Food Order** Flutter app using **Firebase (Auth & Firestore), Provider, and GetX**:

---

## 📂 Folder Structure:
```
lib/
│── main.dart
│
├── 📂 core/
│   ├── app_constants.dart
│   ├── theme.dart
│   ├── routes.dart
│
├── 📂 data/
│   ├── 📂 models/
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   ├── order_model.dart
│   │
│   ├── 📂 services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── storage_service.dart
│
├── 📂 controllers/ (For GetX State Management)
│   ├── auth_controller.dart
│   ├── home_controller.dart
│   ├── cart_controller.dart
│   ├── order_controller.dart
│
├── 📂 providers/ (For Provider State Management)
│   ├── cart_provider.dart
│   ├── order_provider.dart
│
├── 📂 views/
│   ├── 📂 auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │
│   ├── 📂 home/
│   │   ├── home_screen.dart
│   │   ├── product_detail_screen.dart
│   │
│   ├── 📂 cart/
│   │   ├── cart_screen.dart
│   │
│   ├── 📂 orders/
│   │   ├── order_screen.dart
│   │
│   ├── 📂 profile/
│   │   ├── profile_screen.dart
│
├── 📂 widgets/
│   ├── custom_button.dart
│   ├── product_card.dart
│   ├── order_card.dart
│
├── 📂 utils/
│   ├── helpers.dart
│   ├── validators.dart
│
├── 📂 bindings/
│   ├── auth_binding.dart
│   ├── home_binding.dart
│   ├── cart_binding.dart
│   ├── order_binding.dart
│
└── pubspec.yaml
```

---

## ✅ Features:
- **Firebase Authentication** (Sign Up, Login, Logout)
- **Firestore Database** (Storing Users, Products, and Orders)
- **Firebase Storage** (Upload food images)
- **Provider for State Management** (Cart, Orders)
- **GetX for Navigation & Controllers** (Smooth UI experience)
- **Cart System**
- **Order History**
- **Beautiful UI with Animations**
- **Dark Mode Support**
- **Responsive Design for Mobile & Desktop**

---

Do you want a starter template with Firebase setup? 🚀
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
