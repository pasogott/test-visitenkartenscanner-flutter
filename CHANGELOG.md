# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Added
- Secure storage service for API keys using platform-specific encryption (Keychain on iOS/macOS, EncryptedSharedPreferences on Android)  #28
- Settings screen UI with dialogs for OpenAI API key, system prompt, and webhook configuration  #27
- Simulator mode with mock image generation for development without physical camera
- Camera and photo library permissions for iOS
- GitHub issue templates for bug reports and feature requests

### Core Features (Initial Release)
- `BusinessCard` data model with JSON serialization
- Database service with SQLite support (native platforms) and IndexedDB (web)
- Camera service for capturing business card images
- State management with Provider pattern (`CardsProvider`, `ScanProvider`)
- UI screens: Home, Scan, Card Detail, Settings
- Cross-platform support: iOS, Android, macOS, Windows, Linux, Web
