# Navigation Drawer Implementation Guide

## How Drawer Widgets Work

### What is a Drawer?

A `Drawer` is a Material Design panel that slides in from the edge of the screen (typically the left side) to provide navigation options and app information. It's a common pattern in mobile and responsive web applications for organizing navigation when screen space is limited.

### Key Components

1. **Drawer Widget**: The container that holds navigation content
2. **DrawerHeader**: Optional header section for branding, user info, or app logo
3. **ListTile**: Individual navigation items with icons, text, and tap handlers
4. **Scaffold.drawer**: Property that connects the drawer to the screen

### How Drawer Integrates with AppBar

The Drawer automatically integrates with the AppBar through the Scaffold widget:

```dart
Scaffold(
  drawer: MyDrawer(),  // Drawer widget
  appBar: AppBar(
    title: Text('My App'),
    // Flutter automatically adds hamburger icon (☰) when drawer is provided
  ),
  body: MyContent(),
)
```

When a `drawer` is provided to Scaffold:

- Flutter automatically adds a hamburger menu icon (☰) to the AppBar's leading position
- Tapping the hamburger icon opens the drawer with a slide animation
- Tapping outside the drawer or the back button closes it
- The drawer slides in from the left by default

## Implementation in Sandwich Shop App

### 1. Reusable Drawer Component (`lib/widgets/app_drawer.dart`)

We created a reusable `AppDrawer` widget that:

- Accepts `currentRoute` to highlight the active screen
- Accepts optional `cart` to display item count badge
- Provides consistent navigation across all screens
- Eliminates code duplication

Key features:

```dart
class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final Cart? cart;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.cart,
  });
```

### 2. Shared Cart State

To ensure cart data persists across navigation, we moved cart management to the root App widget:

**Before**: Each screen created its own cart instance (data lost on navigation)
**After**: App creates a single cart instance passed to all screens

```dart
class _AppState extends State<App> {
  final Cart _sharedCart = Cart();  // Single cart for entire app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Pass _sharedCart to screens that need it
      },
    );
  }
}
```

### 3. Named Routes

We switched from imperative navigation to named routes:

**Benefits**:

- Centralized route management
- Easier to use with drawer navigation
- Better for deep linking and web URLs
- Cleaner navigation code

```dart
onGenerateRoute: (settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => OrderScreen(...));
    case '/cart':
      return MaterialPageRoute(builder: (_) => CartScreen(...));
    // etc.
  }
}
```

### 4. Integration in All Screens

Every screen now includes:

```dart
Scaffold(
  drawer: AppDrawer(currentRoute: '/profile', cart: cart),
  appBar: AppBar(
    title: Row([
      Image.asset('logo.png'),
      Text('Screen Title'),
    ]),
  ),
  body: ...
)
```

## Reducing Code Redundancy

### Problem

Without a reusable drawer, we'd need to duplicate drawer code in every screen (~100 lines × 5 screens = 500 lines of redundant code).

### Solution: Reusable Widget Pattern

1. **Created `AppDrawer` widget** - Define drawer UI once
2. **Accept parameters** - Make it flexible (currentRoute, cart)
3. **Use in all screens** - Just one line: `drawer: AppDrawer(...)`

**Result**: 150 lines of reusable code instead of 500 lines of duplication

### Code Comparison

**Without Reusability (Old Way)**:

```dart
// In order_screen.dart
Scaffold(
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(...),  // 30 lines
        ListTile(...),      // 100 lines total
        // etc.
      ],
    ),
  ),
)

// Same code repeated in cart_screen.dart
// Same code repeated in profile_screen.dart
// Same code repeated in about_screen.dart
// Same code repeated in checkout_screen.dart
```

**With Reusability (New Way)**:

```dart
// In app_drawer.dart (define once)
class AppDrawer extends StatelessWidget {
  // 150 lines of drawer implementation
}

// In order_screen.dart
Scaffold(drawer: AppDrawer(currentRoute: '/order', cart: cart))

// In cart_screen.dart
Scaffold(drawer: AppDrawer(currentRoute: '/cart', cart: cart))

// In profile_screen.dart
Scaffold(drawer: const AppDrawer(currentRoute: '/profile'))

// etc. - just one line per screen!
```

## Responsive Design Implementation

### Breakpoints

We use `MediaQuery` to detect screen width and adjust the drawer:

```dart
final screenWidth = MediaQuery.of(context).size.width;
final isWideScreen = screenWidth > 1200;
final drawerWidth = isWideScreen ? 300.0 : 280.0;
```

### Responsive Behavior

**Mobile (< 600px)**:

- Drawer hidden by default
- Hamburger icon in AppBar
- Drawer slides in from left when opened
- Full overlay on content

**Tablet (600-1200px)**:

- Same as mobile
- Slightly wider drawer
- Better touch targets

**Desktop/Web (> 1200px)**:

- Wider drawer (300px vs 280px)
- Option to make persistent (always visible)
- Could switch to top navigation bar

### Advanced Responsive Pattern (Optional Enhancement)

For truly responsive navigation, you could implement:

```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        // Desktop: Persistent sidebar
        return Row([
          Container(width: 300, child: AppDrawerContent()),
          Expanded(child: mainContent),
        ]);
      } else {
        // Mobile/Tablet: Drawer
        return Scaffold(
          drawer: Drawer(child: AppDrawerContent()),
          body: mainContent,
        );
      }
    },
  );
}
```

## Features Implemented

### Visual Feedback

- ✅ Current route highlighted with background color
- ✅ Bold text for active screen
- ✅ Different icon colors (purple for active, gray for inactive)

### Cart Integration

- ✅ Red badge showing item count on "View Cart"
- ✅ Badge dynamically updates when cart changes
- ✅ No badge when cart is empty

### User Experience

- ✅ Drawer closes automatically after navigation
- ✅ Smooth slide-in/out animations
- ✅ Tapping current route closes drawer without navigation
- ✅ Tapping outside drawer closes it
- ✅ Back button closes drawer

### Design

- ✅ Branded header with logo and app name
- ✅ Consistent icons for each section
- ✅ Dividers separating content groups
- ✅ Version information in footer
- ✅ Responsive drawer width

## Testing Coverage

Our widget tests verify:

- Drawer renders with all navigation items
- Icons display correctly
- Current route is highlighted
- Cart badge shows/hides appropriately
- Navigation works correctly
- Drawer closes after navigation
- Responsive behavior at different screen sizes

## Benefits of This Approach

1. **Consistency**: Same navigation experience across all screens
2. **Maintainability**: Update navigation in one place
3. **Scalability**: Easy to add new screens/routes
4. **State Preservation**: Cart data persists across navigation
5. **Responsive**: Adapts to different screen sizes
6. **Accessible**: Proper semantic structure for screen readers
7. **Material Design**: Follows Flutter/Material guidelines

## How to Add a New Screen

To add a new screen to the app with drawer navigation:

1. Create your screen widget
2. Add route to `main.dart` onGenerateRoute:
   ```dart
   case '/newscreen':
     return MaterialPageRoute(builder: (_) => NewScreen());
   ```
3. Add navigation item to `app_drawer.dart`:
   ```dart
   _buildDrawerItem(
     context: context,
     icon: Icons.new_icon,
     title: 'New Screen',
     route: '/newscreen',
     isSelected: currentRoute == '/newscreen',
   ),
   ```
4. Add route case to `_navigateToRoute` method in `app_drawer.dart`
5. Include drawer in your new screen:
   ```dart
   Scaffold(
     drawer: AppDrawer(currentRoute: '/newscreen'),
     // ...
   )
   ```

That's it! Five simple steps and your new screen is integrated with consistent navigation.
