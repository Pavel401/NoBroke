## Quick orientation for AI coding agents

This Flutter app (MoneyApp / NoBroke) is a mobile personal-finance manager with an external AI chat backend.
Focus on: GetX for state, a repository/domain/usecase structure, Drift for local DB (codegen), and SMS-based transaction parsing.

Key entrypoints and patterns
- `lib/main.dart` — app bootstrap: calls `DependencyInjection.init()` and uses `GetMaterialApp` + `Sizer`.
- `lib/core/dependencies/dependency_injection.dart` — single place to add service bindings. Update this for new services.
- `lib/presentation/controllers/` — GetX controllers drive UI state. Create controller -> bind in DI -> use in Views.
- `lib/data/datasources/` and `lib/data/repositories/` — data-layer implementations. `lib/domain/` contains interfaces and usecases.
- `lib/presentation/views/main_navigation.dart` — main app navigation shell.

Build / codegen / test commands (project-specific)
- Install deps: `flutter pub get`
- Run app: `flutter run`
- Drift (database) codegen: `flutter pub run build_runner build --delete-conflicting-outputs` (used with `drift_dev`)
- Run unit/widget tests: `flutter test`
- Create release APK: `flutter build apk --release`

Important project conventions
- State: GetX (`get` package). Controllers live under `presentation/controllers` and are referenced from Views.
- DI: All service and controller bindings are placed in `DependencyInjection.init()` (see `lib/core/dependencies`).
- Persistence: Drift (local SQL) with generated files; do not hand-edit generated code. Look for `*.drift`/generated files under `lib/` or `build/`.
- SMS parsing: Uses `flutter_sms_inbox` + `transaction_sms_parser` — SMS permission & parsing logic lives in services under `core/services` or `data/datasources`.
- Chat backend: The app expects a configurable backend URL (README documents the default). Chat client code is implemented under `core/services` / presentation chat views.

Integration points & external dependencies
- AI/chat backend: default production URL in `README.md`. Local dev: `http://localhost:8000`.
- Native integrations: SMS reading (`permission_handler` + `flutter_sms_inbox`), image picking (`image_picker`), share/export (`share_plus`).
- Native signing: Android keystore `upload-keystore.jks` and `key.properties` exist in `android/` — be careful when modifying.

Small examples (how an agent should make edits)
- To add a new service:
  1. Implement interface in `lib/data/repositories` or `lib/core/services`.
  2. Register implementation in `DependencyInjection.init()`.
  3. Inject into a GetX controller and wire the controller into a view under `presentation/views`.

- To add a new Drift table/usecase:
  1. Add model/table under `lib/data/models` or `lib/data/datasources`.
  2. Update Drift annotated classes and run build_runner to generate code.

What NOT to change
- Avoid editing generated artifacts under `build/` or generated Drift files. Use codegen and source files instead.

Where to look first when debugging
- DI & bootstrap: `lib/main.dart`, `lib/core/dependencies/dependency_injection.dart`
- UI + routing: `lib/presentation/views/main_navigation.dart` and `presentation/views/*`
- Business logic: `lib/domain/usecases/*` and `lib/data/repositories/*`
- SMS parsing/debugging: search `flutter_sms_inbox`, `transaction_sms_parser`, and services under `core/services`.

Questions for the maintainer (ask these if you need to proceed)
- Which backend dev URL should be used for integration tests? (README has a default)
- Are there any non-obvious runtime feature flags or environment variables used by CI/Release?

If you want changes merged into the repo, show a short PR describing the change, include the DI and build_runner steps run locally, and reference tests added or updated.

---
If you'd like, I can refine this with concrete file examples (small code snippets) or produce a short checklist for common tasks (add controller, add service, add drift table).
