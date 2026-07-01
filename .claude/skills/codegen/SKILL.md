---
name: codegen
description: Regenerate Freezed and auto_route code (.freezed.dart, .gr.dart) by running build_runner. Use after editing any @freezed BLoC event/state, Freezed model, or route definition, or when generated files are stale or missing.
---

Run code generation for this Flutter project:

```
dart run build_runner build --delete-conflicting-outputs
```

When to run:
- After adding/editing a `@freezed` class (BLoC events/states, domain models).
- After changing routes that need `app_router.gr.dart` regenerated.
- When `flutter analyze` reports missing generated members.

Notes:
- Never hand-edit `*.freezed.dart` or `*.gr.dart` — they are overwritten by this command.
- If the build fails on conflicting outputs, `--delete-conflicting-outputs` already handles the common case; surface any remaining errors to the user.
- After it completes, run `flutter analyze` to confirm the tree is clean.
