# Sandwich Shop

Simple Flutter sample app demonstrating a sandwich order counter with controlled increment/decrement logic.

## Features
- Select sandwich type (six-inch / footlong)
- Choose bread type from dropdown
- Add order notes
- Increment / decrement sandwich quantity with repository-driven limits
- Buttons enable/disable based on repository `canIncrement` / `canDecrement`

## Project structure
- lib/main.dart — UI and app entry
- lib/repositories/order_repository.dart — quantity state and increment/decrement logic
- lib/views/app_styles.dart — text styles and UI constants

## Requirements
- Flutter SDK (stable)
- Dart (bundled with Flutter)
- Windows, macOS, or Linux development environment

## Run (Windows)
1. Open VS Code in the project folder.
2. Restore packages:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Notes about recent changes
- The local `_quantity` field was removed from the stateful widget. Quantity is now owned by `OrderRepository`.
- Increment/decrement callbacks now call repository methods and use `canIncrement` / `canDecrement` to determine whether buttons are enabled. This centralizes the business logic so UI only reflects repository state.

## Suggested commit messages
- `refactor(order): remove local _quantity; delegate quantity to OrderRepository`
- `feat(ui): enable/disable Add/Remove buttons via OrderRepository.canIncrement/canDecrement`

## Contributing
Make commits with clear, single-purpose messages. Run the app and verify UI behavior after changes.
