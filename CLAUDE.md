# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Business Card Scanner - A cross-platform Flutter app for capturing and managing business cards with camera integration and local SQLite storage.

## Commands

```bash
# Run the app
flutter run                    # Run on default device
flutter run -d macos           # Run on macOS
flutter run -d chrome          # Run in Chrome (web)
flutter run -d ios             # Run on iOS device/simulator

# Build
flutter build apk              # Android APK
flutter build ios              # iOS app
flutter build macos            # macOS app
flutter build web              # Web app

# Testing
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run single test file

# Dependencies
flutter pub get                # Get dependencies
flutter pub upgrade            # Upgrade dependencies

# Code quality
flutter analyze                # Run static analysis
dart format .                  # Format code

# Web-specific setup (required once)
dart run sqflite_common_ffi_web:setup  # Generate SQLite WASM files
```

## Architecture

### State Management
- Uses Provider pattern (`provider` package)
- `CardsProvider`: Manages business card list, CRUD operations
- `ScanProvider`: Manages scan workflow state (front/back/selfie capture)

### Database
- Native platforms: `sqflite` package
- Web platform: `sqflite_common_ffi_web` with IndexedDB backend
- Platform detection in `DatabaseService.initializeForWeb()`

### Key Files
- `lib/main.dart` - Entry point, database initialization
- `lib/app.dart` - MaterialApp config, provider setup
- `lib/services/database_service.dart` - SQLite operations with web support
- `lib/services/camera_service.dart` - Camera initialization and capture
- `lib/models/business_card.dart` - Data model with serialization

## Git & Commits

- **No AI attribution**: Never mention Claude, AI, or AI-assisted generation in commits, PR descriptions, or code comments.

- **Atomic commits**: Each commit addresses exactly one logical change:
  - Separate refactoring from feature changes
  - Commit bug fixes individually
  - Keep formatting/linting changes separate from functional changes

- **Branch strategy**: Work on `development` branch, merge to `main` for releases

## Platform-Specific Notes

### iOS
- Requires Xcode with CocoaPods
- Camera permissions in `ios/Runner/Info.plist`
- Run `pod install` in `ios/` after adding native dependencies

### Web
- SQLite runs via WASM worker (`web/sqflite_sw.js`, `web/sqlite3.wasm`)
- Camera uses browser MediaDevices API
- Must run `dart run sqflite_common_ffi_web:setup` before first build

### Android
- Camera permissions in `android/app/src/main/AndroidManifest.xml`
- Min SDK configured in `android/app/build.gradle.kts`
