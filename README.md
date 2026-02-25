# advocatoo

A new Flutter project.

## Web: keeping data across runs

On web, the app stores data in the browser (IndexedDB). **Storage is per-origin**: scheme + host + **port**. Flutter picks a new port each time you run, so you get a new (empty) database every run.

**To keep data between runs**, use a fixed port:

```bash
# Chrome (profile)
flutter run -d chrome --profile --web-port=8080

# Edge
flutter run -d edge --web-port=8080
```

Use the same port every time (e.g. `8080`); then IndexedDB for `http://localhost:8080` will persist.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Database Generation and Migrations

This app uses [Drift](https://drift.simonbinder.eu/) for its local SQLite database.

**To generate the database code after modifying `app_database.dart` or tables:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**To create a migration schema snapshot (required for SchemaVerifier tests):**
```bash
# 1. Update schemaVersion in app_database.dart
# 2. Run schema dump to create the JSON snapshot
dart run drift_dev schema dump lib/database/app_database.dart drift_schemas/drift_schema_vX.json

# 3. Generate schema test helpers
dart run drift_dev schema generate drift_schemas/ test/drift/generated_migrations/
```

Test your migrations by running `flutter test test/drift/migration_test.dart`.
