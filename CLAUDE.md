# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Finance Tracker — a Flutter personal-finance app (wallets, transactions, analytics). Dart SDK >=3.10.0 <4.0.0, Flutter 3.32.8 (locked in CI).

## Architecture

Clean Architecture with three layers under `lib/`:
- `domain/` — models, abstract `Repository` interface, use cases (grouped by feature). Errors flow as `Either<Failure, T>` (dartz).
- `data/` — `data_source/local/` DAOs over sqflite (`DatabaseHelper`), `mapper/` model transforms, `repository/RepositoryImpl`.
- `presentation/` — feature-first folders, each with a BLoC (`flutter_bloc`) + UI.

Cross-cutting: routing via `auto_route` (`lib/app/app_router.dart`), DI via `get_it` registered manually in `lib/app/di.dart`. Add new BLoCs / use cases / repos to `di.dart` or they won't resolve at runtime.

## Code generation

Freezed (BLoC events/states, models) and auto_route both rely on build_runner. After editing any `@freezed` class or routes, regenerate before running:

```
dart run build_runner build --delete-conflicting-outputs
```

The `/codegen` skill runs this. `.freezed.dart` and `.gr.dart` files are generated — don't hand-edit them.

## Commands

- Deps: `flutter pub get`
- Analyze (lint): `flutter analyze`
- Release APK (matches CI): `flutter build apk --release --no-tree-shake-icons`

Lint config is stock `package:flutter_lints` (no custom rules). Code is auto-formatted with `dart format` on edit.

## Workflow

- Branch off `dev`, PR into `dev`. `master` is the release branch — pushing to it triggers GitHub Actions (`.github/workflows/android-build.yml`) which builds the APK and ships to Firebase App Distribution.
