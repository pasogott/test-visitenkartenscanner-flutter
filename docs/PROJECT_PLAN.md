# Business Card Scanner - Project Plan

## Project Overview

A cross-platform Flutter application for scanning, managing, and syncing business cards with AI-powered data extraction and CRM integration capabilities.

**Repository:** [test-visitenkartenscanner-flutter](https://github.com/pasogott/test-visitenkartenscanner-flutter)

**Current Status:** MVP Development

---

## Roadmap

```
Phase 1 (MVP)          Phase 2               Phase 3              Phase 4
─────────────────────────────────────────────────────────────────────────────
Settings & OpenAI  →   Integration System  →  Enhanced UX      →  Enterprise CRM
                       + CI/CD Pipeline
```

---

## Phase 1: MVP - AI Extraction & Settings

**Goal:** Enable automatic business card data extraction using OpenAI Vision API

**Duration:** Sprint 1-2

### Issues

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#1](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/1) | Settings Screen UI | `ui`, `settings`, `mvp` | 3 | 🔲 Todo |
| [#2](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/2) | Secure Storage Service | `security`, `service`, `mvp` | 2 | 🔲 Todo |
| [#3](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/3) | Settings Provider | `state-management`, `mvp` | 3 | 🔲 Todo |
| [#4](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/4) | OpenAI API Key Configuration UI | `ui`, `settings`, `openai`, `mvp` | 3 | 🔲 Todo |
| [#5](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/5) | System Prompt Configuration | `ui`, `settings`, `openai` | 2 | 🔲 Todo |
| [#6](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/6) | OpenAI Service | `service`, `openai`, `mvp` | 5 | 🔲 Todo |
| [#7](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/7) | Extended BusinessCard Model | `model`, `database`, `mvp` | 3 | 🔲 Todo |
| [#8](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/8) | Extraction Flow in Preview Screen | `ui`, `openai`, `mvp` | 5 | 🔲 Todo |

**Total Story Points:** 26

### Deliverables

- [ ] Settings screen accessible from home
- [ ] Secure API key storage
- [ ] OpenAI Vision API integration
- [ ] Automatic data extraction on card scan
- [ ] Extended data model with contact fields

### Dependencies

```yaml
flutter_secure_storage: ^9.0.0
http: ^1.2.0
```

---

## Phase 2: Integration Foundation & CI/CD

**Goal:** Enable external system integrations and automated deployment pipeline

**Duration:** Sprint 3-4

### Integration System

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#10](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/10) | Integration Service Interface | `architecture`, `integration` | 3 | 🔲 Todo |
| [#11](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/11) | Webhook Integration | `integration`, `webhook` | 3 | 🔲 Todo |
| [#12](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/12) | Integration Registry & Factory | `architecture`, `integration` | 2 | 🔲 Todo |
| [#13](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/13) | Sync Provider | `state-management`, `integration` | 5 | 🔲 Todo |
| [#14](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/14) | Integration Settings UI | `ui`, `settings`, `integration` | 5 | 🔲 Todo |

**Total Story Points:** 18

### CI/CD Pipeline

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#19](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/19) | Flutter CI Pipeline | `ci-cd`, `devops`, `mvp` | 3 | 🔲 Todo |
| [#20](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/20) | Build Artifacts | `ci-cd`, `deployment` | 5 | 🔲 Todo |
| [#23](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/23) | Web Deployment (GitHub Pages) | `ci-cd`, `deployment` | 2 | 🔲 Todo |
| [#24](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/24) | Automated Release Notes | `ci-cd`, `devops` | 3 | 🔲 Todo |
| [#25](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/25) | Code Coverage Report | `ci-cd`, `testing` | 2 | 🔲 Todo |
| [#26](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/26) | Branch Protection Rules | `ci-cd`, `devops` | 1 | 🔲 Todo |

**Total Story Points:** 16

### Deliverables

- [ ] Modular integration architecture
- [ ] Generic webhook integration (Zapier/Make compatible)
- [ ] Sync status tracking per card
- [ ] Automated CI checks on PRs
- [ ] Automated web deployment
- [ ] Code coverage reporting

---

## Phase 3: Enhanced UX & Store Deployment

**Goal:** Polish user experience and enable app store distribution

**Duration:** Sprint 5-6

### UX Improvements

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#9](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/9) | Card Detail Screen with Extracted Data | `ui` | 5 | 🔲 Todo |
| [#15](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/15) | Sync Status in Card Detail | `ui`, `integration` | 3 | 🔲 Todo |

**Total Story Points:** 8

### App Store Deployment

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#21](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/21) | iOS TestFlight Deployment | `ci-cd`, `deployment` | 8 | 🔲 Todo |
| [#22](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/22) | Android Play Store Deployment | `ci-cd`, `deployment` | 5 | 🔲 Todo |

**Total Story Points:** 13

### Deliverables

- [ ] Contact quick actions (call, email, maps)
- [ ] Tap-to-copy functionality
- [ ] Sync status visibility
- [ ] TestFlight distribution
- [ ] Play Store Internal Testing

### Prerequisites

- Apple Developer Account
- Google Play Developer Account
- Code signing certificates

---

## Phase 4: Enterprise CRM Integrations

**Goal:** Direct integration with popular CRM systems

**Duration:** Sprint 7+

| # | Title | Labels | Points | Status |
|---|-------|--------|--------|--------|
| [#16](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/16) | Salesforce Integration | `integration`, `future` | 8 | 🔲 Todo |
| [#17](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/17) | HubSpot Integration | `integration`, `future` | 8 | 🔲 Todo |
| [#18](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues/18) | Pipedrive Integration | `integration`, `future` | 8 | 🔲 Todo |

**Total Story Points:** 24

### Deliverables

- [ ] OAuth2 authentication flows
- [ ] Bi-directional sync
- [ ] Field mapping configuration
- [ ] Duplicate handling

---

## Summary

### Total Story Points by Phase

| Phase | Description | Story Points |
|-------|-------------|--------------|
| Phase 1 | MVP - AI Extraction | 26 |
| Phase 2 | Integration + CI/CD | 34 |
| Phase 3 | UX + App Stores | 21 |
| Phase 4 | Enterprise CRM | 24 |
| **Total** | | **105** |

### Issue Distribution by Label

```
mvp (8)          ████████░░░░░░░░ 31%
integration (9)  █████████░░░░░░░ 35%
ci-cd (8)        ████████░░░░░░░░ 31%
ui (7)           ███████░░░░░░░░░ 27%
openai (4)       ████░░░░░░░░░░░░ 15%
settings (4)     ████░░░░░░░░░░░░ 15%
```

---

## Architecture Overview

### New Components

```
lib/
├── models/
│   ├── card_extraction.dart      # OpenAI response
│   ├── integration_config.dart   # Integration settings
│   └── sync_status.dart          # Sync tracking
├── providers/
│   ├── settings_provider.dart    # App settings
│   └── sync_provider.dart        # Sync state
├── services/
│   ├── secure_storage_service.dart
│   ├── openai_service.dart
│   └── integrations/
│       ├── integration_service.dart
│       ├── integration_registry.dart
│       └── webhook_integration.dart
└── screens/
    ├── settings_screen.dart
    └── integration_config_screen.dart
```

### Data Flow

```
┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
│ Scan Screen │───▶│ OpenAI API   │───▶│ Business Card   │
│             │    │ (Extraction) │    │ (with metadata) │
└─────────────┘    └──────────────┘    └────────┬────────┘
                                                │
                   ┌──────────────┐             │
                   │ Integration  │◀────────────┘
                   │ Service      │
                   └──────┬───────┘
                          │
         ┌────────────────┼────────────────┐
         ▼                ▼                ▼
   ┌──────────┐    ┌──────────┐    ┌──────────┐
   │ Webhook  │    │Salesforce│    │ HubSpot  │
   └──────────┘    └──────────┘    └──────────┘
```

---

## CI/CD Pipeline

### Workflow Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        Pull Request                          │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│  CI Pipeline (ci.yml)                                        │
│  ├── flutter analyze                                         │
│  ├── flutter test --coverage                                 │
│  └── dart format --set-exit-if-changed                       │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                      Merge to main                           │
└──────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  Build Web      │ │  Build Android  │ │  Build iOS      │
│  (build.yml)    │ │  (build.yml)    │ │  (build.yml)    │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  GitHub Pages   │ │  Play Store     │ │  TestFlight     │
│  (deploy-web)   │ │  (deploy-android│ │  (deploy-ios)   │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

---

## Getting Started

### For Developers

1. Clone the repository
2. Run `flutter pub get`
3. For web: `dart run sqflite_common_ffi_web:setup`
4. Start developing!

### Creating Issues

Use the issue templates:
- **Feature Request:** For new functionality
- **Bug Report:** For bug reports

### Commit Convention

```
feat: Add new feature
fix: Fix bug
docs: Update documentation
chore: Maintenance tasks
refactor: Code refactoring
test: Add tests
ci: CI/CD changes
```

---

## Links

- [GitHub Issues](https://github.com/pasogott/test-visitenkartenscanner-flutter/issues)
- [Project Board](https://github.com/pasogott/test-visitenkartenscanner-flutter/projects) *(to be created)*
- [README](../README.md)
- [CLAUDE.md](../CLAUDE.md)

---

*Last Updated: 2025-12-30*
