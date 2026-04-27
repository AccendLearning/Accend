# Accend — Mobile Interface

Flutter client for Accend (iOS, Android, and web targets). For a full product overview, see the root `README.md`.

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter / Dart `^3.10.7` |
| Auth & session | `supabase_flutter` |
| State management | `provider` |
| HTTP | `http` |
| Audio recording | `record` |
| Audio playback | `audioplayers` |
| Real-time voice sessions | `livekit_client` |

## Quick Start

```bash
cd apps/mobile_interface
flutter pub get
flutter run
```

For first-time setup, run backend first from `backend/`, then run this app so gateway calls succeed immediately.

## Environment Configuration

The app loads env files from `assets/`:

- `assets/.env.mobile` — for mobile targets
- `assets/.env.web` — for web

Required variables:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
GATEWAY_BASE_URL=   # e.g. http://localhost:8080
```

`lib/main.dart` selects the correct env file by platform and initializes Supabase before `runApp`.

## App Entry and Navigation

- Entry point: `lib/main.dart`
- App shell and setup: `lib/src/app/`
- Named route table: `lib/src/app/routes.dart`

Key route groups:

| Group | Prefix |
|-------|--------|
| Onboarding | `/onboarding/...` |
| Main shell tabs | `/home`, `/courses`, `/social`, `/profile` |
| Solo practice | `/solo-practice` |
| Group session | `/group_session/...` |

## Source Layout

```text
lib/
├── main.dart
└── src/
    ├── app/              # Theme, routes, app shell
    ├── common/           # Shared models, services, widgets, pages
    └── features/
        ├── courses/
        ├── group_session/
        ├── home/
        ├── login/
        ├── onboarding/
        ├── progress/
        ├── public_profile/
        ├── social/
        └── solo_practice/
```

## Feature Organization Convention

Each feature folder is structured by role:

```text
features/<name>/
├── pages/        # Full screens registered in the route table
├── widgets/      # UI pieces scoped to this feature
├── controllers/  # State and business logic (Provider-based)
├── models/       # Data types
└── services/     # Feature-specific API or device interactions
```

Keep features self-contained. Shared code lives in `common/`, not leaked into other feature folders.

## Working With the Backend

The app communicates only with the API Gateway — never with internal microservices directly. The gateway handles auth verification and service orchestration.

Local gateway default: `http://localhost:8080`

Common gateway interactions:

- Profile bootstrap and onboarding patches
- Home and profile preload endpoints
- Course listing and lesson completion
- AI course generation (custom prompt, onboarding seed, weak-phoneme)
- Pronunciation assessment and AI feedback
- Group lobby, turn-state, scoring, and vote endpoints
- Follow, block, and reputation endpoints

For backend setup and service descriptions, see `backend/README.md`.
