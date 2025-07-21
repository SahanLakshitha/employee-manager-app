# Work Flow - Employee Attendance & Daily Tasks App

A Flutter application for tracking employee attendance and managing daily tasks.

# Project Structure
The app uses a clean and simple MVC-like structure

lib/
├── main.dart
├── models/
│   ├── attendance_model.dart
│   └── task_model.dart
├── screens/
│   ├── attendance_screen.dart
│   ├── tasks_screen.dart
│   └── about_screen.dart
├── services/
│   ├── storage_service.dart
├── widgets/
│   ├── task_tile.dart
│   └── attendance_card.dart

## Packages Used

- `shared_preferences`: For local data persistence (attendance records and tasks)
- `intl`: For date/time formatting and parsing
- `flutter/material.dart` : UI design framework

# Assumptions

- App is single-user; no login or authentication
- The app only tracks attendance for the current day in the main view, but keeps history of all records.
- Employee name is entered once and persists across sessions.
- Time calculations are based on device local time.
- Tasks can be added with all four required fields (Name, Due Date, Priority, Status).

# Bonus Features

- Persistent storage using shared_preferences
- Task auto-save functionality
- Responsive UI works on both Android and Web
- About screen developer details and date
- Error simulation via long-press on the app bar
- Loading indicators for all data operations

# Time Taken

Approximately 8 hours for complete implementation including testing and debugging.

# How to Run

-> Web

1. Ensure Flutter web is enabled:
   ```bash
    flutter config --enable-web
2. Run the app
    ```bash
    flutter run -d web-server

-> Android
 
  - `Connect an Android device or start an emulator`

- Run the App
    ```bash
    flutter run

- To build an APK file:
    ```bash
    flutter build apk --release

#Screen recording

"https://drive.google.com/file/d/10WkLaGuidW0xvzKr-xatU_qyV66nyYFg/view?usp=drive_link"
