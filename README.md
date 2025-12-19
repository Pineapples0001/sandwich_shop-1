# Sandwich Shop 🥪

A fully-featured Flutter sandwich ordering application with order history, cart management, and cross-platform support. Built with Flutter and Dart, this app demonstrates modern mobile/web development practices including state management, local storage, and cloud integration.

## ✨ Features

### Core Functionality

- **🛒 Shopping Cart** - Add, remove, and modify sandwich orders with quantity management
- **🥖 Sandwich Customization** - Choose sandwich type, bread type (White/Wheat/Wholemeal), and size (Footlong/Six-inch)
- **💳 Checkout System** - Complete payment flow with order confirmation
- **📜 Order History** - Persistent order storage with date/time tracking
- **⚙️ Settings** - Customizable font size (12-24px) saved across sessions
- **👤 Profile Management** - User profile screen with navigation

### Technical Features

- **🌐 Cross-Platform** - Runs on Web (Chrome/Edge), Windows, macOS, Linux
- **💾 Dual Storage** - SharedPreferences (web) and SQLite (desktop) for order persistence
- **🔥 Firebase Integration** - Cloud storage for orders via Firebase Realtime Database
- **🎨 Custom UI** - Styled buttons, app bar, and consistent theming
- **📱 Responsive Design** - Adapts to different screen sizes
- **🧪 Comprehensive Testing** - 107 unit and integration tests

### Order Management

- View order history with order ID, date/time, item count, and total amount
- Orders persist between sessions
- Easy navigation between screens

## 🚀 Getting Started

### Prerequisites

1. **Terminal**:

   - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
   - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
   If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

   - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
   - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

   - **macOS**: `brew install --cask flutter`
   - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

   - **macOS**: `brew install --cask visual-studio-code`
   - **Windows**: `choco install vscode`

6. **Windows Desktop Development** (Optional) – For Windows native builds, enable Developer Mode:
   - Run `start ms-settings:developers` and turn on Developer Mode
   - Required for symlink support

## 📦 Installation

### Clone the Repository

```bash
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### Install Dependencies

```bash
flutter pub get
```

### Generate Code (JSON Serialization)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎮 Running the App

### Web (Recommended)

```bash
# Development mode
flutter run -d chrome

# Release mode (optimized)
flutter run -d chrome --release
```

### Windows Desktop

```bash
# Requires Developer Mode enabled
flutter run -d windows
```

### Build for Production

```bash
# Web release build
flutter build web --release

# Windows release build
flutter build windows --release
```

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

**Test Coverage:**

- ✅ 107 tests passing
- Unit tests for models, services, repositories
- Widget tests for all screens
- Integration tests for user flows

### Run Integration Tests

```bash
# Note: Integration tests require non-web platform
flutter test integration_test/app_test.dart -d windows
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── cart.dart            # Shopping cart state
│   ├── sandwich.dart        # Sandwich model
│   └── saved_order.dart     # Order history model
├── services/                # Business logic
│   ├── database_service.dart      # Local storage
│   └── firebase_order_service.dart # Cloud storage
├── repositories/            # Data access layer
│   └── pricing_repository.dart
├── views/                   # UI screens
│   ├── order_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── order_history_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   └── app_styles.dart
└── widgets/                 # Reusable components
    └── common_widgets.dart

test/                        # Unit tests
integration_test/           # Integration tests
```

## 🔧 Configuration

### Firebase Setup (Optional)

To enable cloud order storage:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Realtime Database
3. Update credentials in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL: 'YOUR_DATABASE_URL',
  ),
);
```

## 🎯 Features in Detail

### Order History

- **Web**: Orders saved to browser localStorage via SharedPreferences
- **Desktop**: Orders saved to SQLite database
- Displays order ID, date, time, item count, and total amount
- Persistent across app sessions

### Cart Management

- Add multiple sandwiches with different configurations
- Increment/decrement quantities
- Remove individual items
- Real-time price calculation
- Visual quantity indicators

### Customization

- **Sandwich Types**: Veggie Delight, Spicy Italian, Chicken Teriyaki, BLT
- **Bread Types**: White, Wheat, Wholemeal
- **Sizes**: Footlong (£11.00), Six-inch (£7.00)

### Settings

- Adjustable font size (12-24px)
- Changes persist across sessions
- Real-time preview

## 📊 Build Information

**Release Build Size (Web):**

- Total: 75.17 MB
- Main app: 10.01 MB (main.dart.js)
- Assets: ~16 MB (CanvasKit WASM)
- 42 files total

**Optimizations:**

- Tree-shaking removes unused code
- Minified JavaScript
- Compressed assets
- Production-ready performance

## 🛠 Technologies Used

- **Flutter 3.38.1** - UI framework
- **Dart 3.10.0** - Programming language
- **Provider** - State management
- **SQLite** - Local database (desktop)
- **SharedPreferences** - Key-value storage (web)
- **Firebase** - Cloud storage
- **JSON Serialization** - Data persistence
- **Material Design** - UI components

## 📝 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  shared_preferences: ^2.5.3
  sqflite: ^2.4.2
  path: ^1.9.1
  json_annotation: ^4.9.0
  firebase_core: ^4.3.0
  firebase_database: ^12.1.1
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  sqflite_common_ffi: ^2.3.0
  integration_test:
    sdk: flutter
  build_runner: ^2.10.4
  json_serializable: ^6.11.3
```

## 🐛 Known Issues

- Windows desktop builds require Developer Mode enabled for symlink support
- Integration tests don't run on web platform (use `flutter test` for unit tests on web)

## 📄 License

This project is for educational purposes.

## 👨‍💻 Development

### Code Generation

When modifying models with JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload

Development mode supports hot reload for rapid iteration:

- Press `r` in terminal to hot reload
- Press `R` to hot restart

## 🎉 Acknowledgments

Built as part of a Flutter development workshop demonstrating:

- State management with Provider
- Local and cloud storage
- Cross-platform development
- Testing best practices
- Production build optimization

```bash
git fetch origin
git checkout 8
```

## Run the app

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app in your web browser:

```bash
flutter pub get
flutter run
```

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
