# Business Card Scanner

A cross-platform Flutter application for scanning and managing business cards. Capture the front and back of business cards using your device's camera, optionally take a selfie with the card holder, and store everything locally.

## Features

- **Camera Capture**: Scan front and back of business cards
- **Selfie Mode**: Optionally capture a photo with the card holder
- **Local Storage**: SQLite database for offline-first data persistence
- **Cross-Platform**: Runs on iOS, Android, macOS, Windows, Linux, and Web
- **Material Design 3**: Modern UI with dynamic color theming

## Screenshots

*Coming soon*

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.4 or later)
- For iOS/macOS: Xcode with CocoaPods
- For Android: Android Studio with Android SDK
- For Web: Chrome browser

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/pasogott/test-visitenkartenscanner-flutter.git
   cd test-visitenkartenscanner-flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. For Web, set up SQLite WASM:
   ```bash
   dart run sqflite_common_ffi_web:setup
   ```

### Running the App

```bash
# Run on connected device (auto-detect)
flutter run

# Run on specific platform
flutter run -d chrome    # Web
flutter run -d macos     # macOS
flutter run -d ios       # iOS Simulator
flutter run -d android   # Android Emulator
```

### Building for Production

```bash
flutter build web       # Web
flutter build macos     # macOS
flutter build ios       # iOS
flutter build apk       # Android APK
flutter build appbundle # Android App Bundle
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # MaterialApp configuration
├── models/
│   └── business_card.dart # Business card data model
├── services/
│   ├── database_service.dart  # SQLite database operations
│   └── camera_service.dart    # Camera handling
├── providers/
│   ├── cards_provider.dart    # Business card list state
│   └── scan_provider.dart     # Scan workflow state
├── screens/
│   ├── home_screen.dart       # Card list view
│   ├── scan_screen.dart       # Camera capture screen
│   ├── preview_screen.dart    # Image preview before saving
│   └── card_detail_screen.dart # Single card detail view
└── widgets/               # Reusable UI components
```

## Architecture

- **State Management**: Provider pattern for reactive UI updates
- **Database**: SQLite via `sqflite` (native) and `sqflite_common_ffi_web` (web)
- **Camera**: Flutter `camera` plugin with platform-specific implementations
- **Storage**: Local file system via `path_provider`

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `sqflite` | SQLite database (native platforms) |
| `sqflite_common_ffi_web` | SQLite database (web) |
| `camera` | Camera access |
| `path_provider` | File system paths |
| `permission_handler` | Runtime permissions |

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| iOS | Supported | Requires Xcode |
| Android | Supported | Requires Android SDK |
| macOS | Supported | Requires Xcode |
| Web | Supported | Uses IndexedDB via SQLite WASM |
| Windows | Supported | - |
| Linux | Supported | - |

## Development

### Code Quality

```bash
# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test
```

### Adding New Features

1. Create feature branch from `development`
2. Implement changes with atomic commits
3. Run tests and linting
4. Create pull request

## License

This project is private and not licensed for public use.
