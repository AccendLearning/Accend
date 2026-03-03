# Accend

Accend is an AI-powered language learning experience designed to help users improve pronunciation, confidence, and real-world speaking ability through personalized feedback and engaging practice.

Our goal is simple: make speaking practice feel natural, motivating, and effective.

---

## 🌍 What Accend Does

Accend helps learners:

* Practice speaking in realistic scenarios
* Receive intelligent pronunciation feedback
* Personalize their learning goals and pace
* Choose the tone of AI feedback that motivates them
* Track their progress over time

The experience adapts to each learner’s level, goals, and preferences from the moment they onboard.

---

## 📱 App Experience

Users can:

* Create an account or log in
* Complete a guided onboarding experience
* Select:

  * Current speaking level
  * Learning goals
  * Daily practice pace
  * Preferred AI feedback tone
  * Target accent
* Begin personalized speaking practice

The app focuses on confidence-building, clarity, and consistent daily improvement.

---

## 🏗 Project Structure

This repository is organized into two main parts:

### `/apps`

Contains the Flutter mobile application.

* User interface
* Onboarding experience
* Practice sessions
* Progress tracking
* Client-side app logic

### `/services`

Contains backend microservices.

* Authentication
* User profiles
* Speech processing
* Feedback generation
* Data storage and management

This structure allows the mobile app and backend services to evolve independently while working together seamlessly.

---

## 🎯 Vision

Accend aims to combine:

* AI-powered feedback
* Human-like encouragement
* Structured skill progression
* Flexible daily commitment

The long-term goal is to create a speaking-first language platform that feels less like a lesson and more like real conversation practice.

---

## 🚀 Status

Accend is currently under active development.
Features and architecture may evolve as the product grows.

## Repo Structure

```
ACCEND/
├── apps/
│   └── mobile_interface/
│
├── backend/
│   ├── services/
│   │   ├── api-gateway/
│   │   ├── courses-service/
│   │   │   ├── app/
│   │   │   │   ├── main.py
│   │   │   │   ├── config.py
│   │   │   │   ├── dependencies.py
│   │   │   │
│   │   │   │   ├── routers/
│   │   │   │   │   └── courses.py
│   │   │   │
│   │   │   │   ├── schemas/
│   │   │   │   │   ├── course_schema.py
│   │   │   │   │   └── lesson_schema.py
│   │   │   │
│   │   │   │   ├── services/
│   │   │   │   │   └── course_service.py
│   │   │   │
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── course_repo.py              # interface/contract
│   │   │   │   │   └── supabase_course_repo.py     # router → service → repository → supabase
│   │   │   │
│   │   │   │   ├── clients/
│   │   │   │   │   └── supabase.py
│   │   │   │
│   │   │   │   └── utils/
│   │   │   │       └── errors.py
│   │   │   ├── tests/
│   │   │   ├── Dockerfile
│   │   │   └── requirements.txt
│   │   ├── ai-service/
│   │   └── sessions-service/
│   │
│   ├── shared/
│   │   ├── auth/
│   │   │   └── jwt.py
│   │   ├── http/
│   │   │   └── client.py             # shared http helpers
│   │   └── logging.py
│   │
│   └── docker-compose.yml
│
├── contracts/
│   └── openapi/
│
├── infra/
│   ├── supabase/
│   └── scripts/
│
└── README.md



## lib/src structure

This folder holds the real app code (screens, widgets, and app setup).

### How to place files

- **`app/`**: global setup (root `MaterialApp`, routes, theme, constants)
- **`features/`**: one folder per big app area (login, onboarding, courses, etc.)
  - **`pages/`**: full screens
  - **`widgets/`**: smaller UI pieces used by those screens
  - **`controllers/`**: simple state/logic for that feature
- **`common/`**: shared widgets/helpers/services used by multiple features

We intentionally keep this simple for beginners.

### Front end Structure
```
lib/
  main.dart

  src/
    app/
      app.dart           // MyApp: MaterialApp, theme, initial route
      routes.dart        // route names & route table
      theme.dart         // colors, typography, spacing
      constants.dart     // strings, asset paths, etc.

    features/
      login/
        pages/
          login_page.dart
          forgot_password_page.dart
        widgets/
          login_form.dart
          social_login_buttons.dart
        controllers/
          login_controller.dart

      onboarding/
        pages/
          onboarding_intro_page.dart
          onboarding_goals_page.dart
          onboarding_language_level_page.dart
        widgets/
          onboarding_step_indicator.dart
        controllers/
          onboarding_controller.dart

      courses/
        pages/
          courses_list_page.dart
          course_detail_page.dart
          lesson_page.dart
        widgets/
          course_card.dart
          lesson_progress_bar.dart
        controllers/
          courses_controller.dart

      solo_practice/
        pages/
          solo_practice_home_page.dart
          exercise_detail_page.dart
          pronunciation_practice_page.dart
        widgets/
          exercise_card.dart
          timer_widget.dart
        controllers/
          solo_practice_controller.dart

      social/
        pages/
          feed_page.dart
          post_detail_page.dart
          notifications_page.dart
        widgets/
          post_card.dart
          comment_input.dart
        controllers/
          social_controller.dart

      public_profile/
        pages/
          public_profile_page.dart
          edit_profile_page.dart
        widgets/
          avatar_with_badges.dart
          stat_row.dart
        controllers/
          public_profile_controller.dart

      group_session/
        pages/
          group_session_list_page.dart
          group_session_detail_page.dart
          group_session_live_page.dart
        widgets/
          participant_avatar.dart
          live_waveform.dart
        controllers/
          group_session_controller.dart

    common/
      widgets/
        primary_button.dart
        primary_text_field.dart
        app_scaffold.dart        // common Scaffold wrapper
        app_bottom_nav_bar.dart  // if you have tab bar
      utils/
        validators.dart
        formatters.dart
      services/
        api_client.dart
        auth_service.dart
        user_service.dart
```

## lib/src structure

This folder holds the real app code (screens, widgets, and app setup).

### How to place files

- **`app/`**: global setup (root `MaterialApp`, routes, theme, constants)
- **`features/`**: one folder per big app area (login, onboarding, courses, etc.)
  - **`pages/`**: full screens
  - **`widgets/`**: smaller UI pieces used by those screens
  - **`controllers/`**: simple state/logic for that feature
- **`common/`**: shared widgets/helpers/services used by multiple features

We intentionally keep this simple for beginners.

### Front end Structure
```
lib/
  main.dart

  src/
    app/
      app.dart           // MyApp: MaterialApp, theme, initial route
      routes.dart        // route names & route table
      theme.dart         // colors, typography, spacing
      constants.dart     // strings, asset paths, etc.

    features/
      login/
        pages/
          login_page.dart
          forgot_password_page.dart
        widgets/
          login_form.dart
          social_login_buttons.dart
        controllers/
          login_controller.dart

      onboarding/
        pages/
          onboarding_intro_page.dart
          onboarding_goals_page.dart
          onboarding_language_level_page.dart
        widgets/
          onboarding_step_indicator.dart
        controllers/
          onboarding_controller.dart

      courses/
        pages/
          courses_list_page.dart
          course_detail_page.dart
          lesson_page.dart
        widgets/
          course_card.dart
          lesson_progress_bar.dart
        controllers/
          courses_controller.dart

      solo_practice/
        pages/
          solo_practice_home_page.dart
          exercise_detail_page.dart
          pronunciation_practice_page.dart
        widgets/
          exercise_card.dart
          timer_widget.dart
        controllers/
          solo_practice_controller.dart

      social/
        pages/
          feed_page.dart
          post_detail_page.dart
          notifications_page.dart
        widgets/
          post_card.dart
          comment_input.dart
        controllers/
          social_controller.dart

      public_profile/
        pages/
          public_profile_page.dart
          edit_profile_page.dart
        widgets/
          avatar_with_badges.dart
          stat_row.dart
        controllers/
          public_profile_controller.dart

      group_session/
        pages/
          group_session_list_page.dart
          group_session_detail_page.dart
          group_session_live_page.dart
        widgets/
          participant_avatar.dart
          live_waveform.dart
        controllers/
          group_session_controller.dart

    common/
      widgets/
        primary_button.dart
        primary_text_field.dart
        app_scaffold.dart        // common Scaffold wrapper
        app_bottom_nav_bar.dart  // if you have tab bar
      utils/
        validators.dart
        formatters.dart
      services/
        api_client.dart
        auth_service.dart
        user_service.dart
```