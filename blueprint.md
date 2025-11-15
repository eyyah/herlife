# Her-Life App Blueprint

## Overview

Her-Life is a Flutter-based mobile application designed to provide a secure and personalized user experience. The application features user authentication (signup and login), and allows users to manage their profile information. The data is stored locally using an SQLite database. The application is built with a focus on a clean, modern design and a user-friendly interface.

## Implemented Features, Style, and Design

### Core Functionality
*   **User Authentication:**
    *   **Signup:** New users can create an account by providing their first name, last name, gender, phone number, email, and a password.
    *   **Login:** Existing users can log in with their email and password.
*   **Database:**
    *   A local SQLite database is used to store user information.
    *   The `sqflite` package is used for database operations.
*   **Routing:**
    *   The `go_router` package is used for navigation, providing a declarative routing solution.
*   **State Management:**
    *   The application uses a combination of `StatefulWidget` and `FutureBuilder` for managing local and asynchronous state.

### UI and Design
*   **Splash Screen:** A simple splash screen is displayed when the app starts.
*   **Welcome Screen:** A welcome screen with buttons to navigate to the login and signup pages.
*   **Login Page:** A clean login page with text fields for email and password, and a login button.
*   **Signup Page:** A well-structured signup page with fields for all required user information. The labels for the text fields have been removed to create a cleaner look.
*   **Home Page:** A home page that welcomes the user. It includes a button to view the database content in the debug console and a profile button.
*   **Profile Page:** A profile page where users can view and update their personal information, including their name, email, and password.
*   **Styling:**
    *   The application uses a consistent theme with a purple color scheme.
    *   Custom text fields and buttons are used for a modern look.

## Current Change: Profile Page Logic and Bug Fixes

The most recent changes focused on fixing a critical logic error in the `ProfilePage` and addressing several other issues identified by the `flutter analyze` tool.

### Plan and Steps for the Current Change (Completed)

1.  **Diagnose the `ProfilePage` issue:** The initial problem was that the `TextEditingController`s were being re-initialized inside the `build` method, causing user input to be lost on every widget rebuild.
2.  **Fix the `ProfilePage` issue:**
    *   Moved the `TextEditingController` initialization to the `initState` method.
    *   Populated the controllers with user data when the data is fetched from the database.
    *   Implemented the `dispose` method to clean up the controllers.
3.  **Address Analyzer Issues:**
    *   **`database_helper.dart`:**
        *   Added the missing `getUserById` and `updateUser` methods to the `DatabaseHelper` class.
    *   **`profile_page.dart`:**
        *   Updated the `ProfilePage` to handle the complete `User` model, including fields for all user properties.
        *   Fixed the `use_build_context_synchronously` warning by adding a `mounted` check before showing a `ScaffoldMessenger`.
    *   **`home_page.dart`:**
        *   Fixed the `use_build_context_synchronously` warning by converting the `HomePage` to a `StatefulWidget` and adding a `mounted` check.
    *   **`models/user_model.dart`:**
        *   Removed unused imports (`dart:convert` and `package:crypto/crypto.dart`).
    *   **`components/my_textfield.dart`:**
        *   Fixed the `prefer_typing_uninitialized_variables` warning by explicitly typing the `controller` as a `TextEditingController`.
4.  **Verification:**
    *   Ran `dart format .` to ensure consistent code formatting.
    *   Ran `flutter analyze` to confirm that all issues were resolved.

## Previous Change: Signup Page UI

*   **Removed Labels:** The labels for the text fields on the signup page were removed to create a cleaner and more modern look. The `hintText` property of the `MyTextField` widget is now used to display the labels as hints.