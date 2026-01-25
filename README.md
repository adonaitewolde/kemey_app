# Kemey - Learn Tigrinya

A modern, gamified mobile application for learning Tigrinya (ትግርኛ), built with Flutter and Supabase.

## About

Kemey is a language learning app that helps users learn Tigrinya through interactive lessons, flashcards, and exercises. The app uses gamification to keep learners motivated with XP points, daily streaks, and progress tracking.

## Features

- **Interactive Lessons**: Learn through structured units covering vocabulary, grammar, and conversation
- **Flashcard System**: Master the Ge'ez script (Fidel) used for Tigrinya
- **Multiple Exercise Types**: Practice with various question formats including multiple choice, translation, listening, and more
- **Progress Tracking**: Track your learning journey with detailed statistics
- **Gamification**: Earn XP, maintain streaks, and unlock new content as you progress
- **Social Authentication**: Sign in with Google or Apple

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Supabase** - Backend, database, and authentication
- **Riverpod** - State management

## Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- A Supabase account

### Installation

1. Clone the repository
```bash
git clone <your-repository-url>
cd kemey_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Create a `.env` file in the root directory
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Generate code
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. Run the app
```bash
flutter run
```

## Development

### Code Generation

When modifying providers or models, regenerate code:
```bash
dart run build_runner watch
```

### Building

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # Riverpod providers
├── screens/        # UI screens
├── services/       # Business logic & API
├── widgets/        # Reusable components
└── main.dart       # App entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

---

**Happy Learning! ደስ ይበለካ! (Des ybeleka!)** 🎓📱
