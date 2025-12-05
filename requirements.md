# Cart Modification Feature Requirements

## 1. Feature Description and Purpose

The cart modification feature enables users to edit the items in their cart on the Cart screen. Users can increase/decrease quantities, directly edit quantities, remove items, and optionally undo a removal. The cart should update reactively: per-item subtotals and the overall total price recompute immediately using existing pricing logic, and the UI reflects the current cart state (including empty-cart handling and checkout availability).

- Scope: Cart editing on the Cart screen; the Order screen’s add-to-cart flow remains unchanged.
- Constraints:
  - Quantity bounds: min 1, max equals `OrderScreen.maxQuantity`.
  - Totals: Recalculate via `PricingRepository`.
  - State: Use existing app state patterns; avoid new dependencies.
  - UX: Clear controls, accessible and responsive; confirm destructive actions or provide undo.

---

## 2. User Stories

### Subtask A: Increment/Decrement Quantity

- As a user, I can tap `+` to increase the quantity of a cart item by 1 up to the allowed maximum, so I can quickly add more of the same sandwich.
- As a user, I can tap `-` to decrease the quantity by 1, so I can adjust my order without starting over.
- As a user, I see disabled controls (or feedback) when I hit the maximum or minimum, so I understand the limits.

### Subtask B: Direct Quantity Edit (Optional)

- As a user, I can type or select a number for quantity, so I can jump directly to a desired amount without repeated taps.
- As a user, I receive validation feedback if I enter an invalid value (non-numeric or out of bounds), so I can correct it easily.

### Subtask C: Remove Item

- As a user, I can remove an item from my cart via a clear control (trash icon or button), so I can clean up my order.
- As a user, I see a confirmation or an undo option, so I don’t accidentally lose items.

### Subtask D: Undo Remove (Optional, Nice-to-have)

- As a user, I can undo an accidental removal within a brief window, so I can recover my previous cart state without re-adding from the Order screen.

### Subtask E: Price and Total Recalculation

- As a user, I see each item’s subtotal and the cart’s total update immediately after any change, so I always know the cost implications of my edits.

### Subtask F: Empty Cart Handling

- As a user, when my cart is empty, I see an “Empty cart” state and the checkout is disabled, so the UI reflects that there’s nothing to purchase.

---

## 3. Acceptance Criteria

### Subtask A: Increment/Decrement Quantity

- Controls:
  - Each cart item shows `-` and `+` quantity controls plus the current quantity and per-item subtotal.
  - `+` is disabled when quantity equals `OrderScreen.maxQuantity`.
  - `-` is disabled at quantity 1 (unless auto-remove at 0 is the chosen UX).
- Behavior:
  - Tapping `+` increases quantity by 1, clamped at max.
  - Tapping `-` decreases quantity by 1; if reaching 0:
    - If confirm flow: show a confirmation modal and only remove on confirm.
    - If auto-remove flow: remove immediately.
  - Cart model updates synchronously; UI reflects the new quantity and subtotal.
  - Cart total recalculates immediately via `PricingRepository`.

### Subtask B: Direct Quantity Edit (Optional)

- Input:
  - Each item can display a numeric input (`TextField` or `Dropdown`).
  - Input accepts only integers; rejects non-numeric or empty values.
- Validation:
  - On submit/change, value is clamped to `[1, OrderScreen.maxQuantity]`.
  - On invalid input, revert to last valid value and show inline feedback (hint or error).
- State/Totals:
  - Valid edits update the Cart model and trigger per-item subtotal and total recalculation.

### Subtask C: Remove Item

- UI:
  - Each item has a clear remove affordance (trash icon or “Remove” button).
- Behavior:
  - On remove, either:
    - Show a confirmation dialog with “Remove” and “Cancel”, or
    - Remove immediately and show a `SnackBar` with Undo.
  - Item is removed from the Cart model.
  - Cart total recalculates; cart list updates.
  - If the cart becomes empty, show the empty state and disable checkout.

### Subtask D: Undo Remove (Optional)

- UX:
  - After removal, display a `SnackBar` with message “Item removed” and an “Undo” action for ~3–5 seconds.
- Behavior:
  - If Undo is tapped, restore the removed item (same sandwich, previous quantity) to the Cart.
  - Totals and UI update immediately upon restoration.
  - If timeout expires or navigation occurs, the removal persists.

### Subtask E: Price and Total Recalculation

- Correctness:
  - Per-item subtotal equals `unit price × quantity` (including any pricing rules).
  - Cart total equals the sum of item subtotals, incorporating discounts/tiered pricing if applicable.
- Reactivity:
  - Totals update after every quantity change or removal without manual refresh.
- Display:
  - Totals are visible in the Cart screen footer/summary.
  - Formatting follows existing app conventions.

### Subtask F: Empty Cart Handling

- UI:
  - When the Cart has zero items, display an “Empty cart” placeholder message and illustration (if available).
  - Hide the item list when empty.
- Behavior:
  - Checkout button is disabled or hidden when empty.
  - Navigating back to the Order screen preserves current app state.

### Non-Functional Criteria

- Accessibility: Controls have sufficient hit targets, semantic labels, and tooltips (where appropriate).
- Performance: Rapid taps do not create inconsistent state; updates are debounced or safely handled to avoid race conditions.
- Consistency: Styling matches existing `views` conventions; changes are localized to cart-related components and models.
- Testing:
  - Unit tests validate:
    - Quantity increment/decrement clamping at bounds.
    - Removal and optional undo restoration.
    - Per-item subtotal and total recalculation after changes.
  - Widget tests cover:
    - Control enable/disable states at bounds.
    - Empty cart state and checkout disabling.

### Definition of Done

- All acceptance criteria above pass.
- No regressions in add-to-cart flow from the Order screen.
- Code adheres to existing patterns and lint rules.
- Tests for modified cart behavior run and pass.

---

# Profile Screen Feature Requirements

## 1. Feature Description and Purpose

The profile screen allows users to view and edit their personal information including name, email, phone number, and delivery address. This screen provides a simple user interface for managing customer details without requiring actual authentication or data persistence at this stage.

- Scope: Create a standalone profile screen accessible from the Order screen with form inputs for user details.
- Constraints:
  - No backend integration or data persistence required at this stage.
  - Form validation for email and phone number formats.
  - Use existing app styling and patterns.
  - Navigation link added to bottom of Order screen.

---

## 2. User Stories

### Story 1: View Profile Screen

- As a user, I can navigate to a profile screen from the Order screen, so I can manage my personal information.
- As a user, I see a clear title and navigation controls, so I understand where I am in the app.

### Story 2: Enter Personal Information

- As a user, I can enter my name, email, phone number, and delivery address, so I can provide my details for orders.
- As a user, I see appropriate input types for each field (text, email, phone), so data entry is convenient.

### Story 3: Form Validation

- As a user, I receive validation feedback for invalid email or phone formats, so I can correct errors before submitting.
- As a user, I see which fields are required, so I know what information is necessary.

### Story 4: Save Profile

- As a user, I can tap a "Save Profile" button to validate and confirm my details, so I can complete the profile form.
- As a user, I see a confirmation message after saving, so I know my action was successful.

---

## 3. Acceptance Criteria

### Profile Screen UI

- Display:
  - App bar with title "Profile" and back button.
  - Form fields for:
    - Full Name (text input, required)
    - Email (email input, required, validated format)
    - Phone Number (phone input, required, validated format)
    - Delivery Address (multiline text input, required)
  - "Save Profile" button at bottom.
  - "Back to Order" button below save button.

### Form Validation

- Requirements:
  - All fields are required; empty fields show validation errors.
  - Email must match valid email format (contains @, domain).
  - Phone number must match valid format (10-11 digits, optional formatting).
- Behavior:
  - Validation triggers on "Save Profile" tap.
  - Invalid fields show error messages below the field.
  - Form only processes when all validations pass.

### Save Action

- Behavior:
  - Tapping "Save Profile" validates all fields.
  - If valid: Show SnackBar with "Profile saved successfully" message (no actual persistence).
  - If invalid: Display error messages for problematic fields; form remains editable.

### Navigation

- Access:
  - Link/button at bottom of Order screen labeled "View Profile" or "My Profile".
  - Tapping navigates to Profile screen.
- Return:
  - Back button in app bar returns to Order screen.
  - "Back to Order" button also returns to Order screen.

### Styling and Consistency

- Use existing `app_styles.dart` styles (heading1, heading2, normalText).
- Use `StyledButton` for action buttons.
- Match overall app theme and color scheme.
- Form inputs use Flutter's `TextFormField` with appropriate decorations.

### Testing

- Widget tests verify:
  - Profile screen renders with all form fields.
  - Navigation from Order screen to Profile screen works.
  - Required field validation shows errors for empty fields.
  - Email validation rejects invalid formats.
  - Phone validation rejects invalid formats.
  - Save button shows success message when form is valid.
  - Back navigation returns to Order screen.

### Definition of Done

- Profile screen implemented with all required fields.
- Form validation working for all field types.
- Navigation to/from Order screen functional.
- Widget tests written and passing for Profile screen.
- Code follows existing patterns and passes lint checks.
- No regressions in existing app functionality.

---

# Navigation Drawer Feature Requirements

## 1. Feature Description and Purpose

Implement a consistent, responsive navigation system using a Drawer widget that provides access to all app screens from anywhere in the application. The navigation should adapt to different screen sizes - displaying as a drawer menu on mobile/tablet and potentially as a persistent sidebar or top navigation on larger screens (web/desktop).

**Key Concepts:**

- **Drawer Widget**: A Material Design panel that slides in from the edge of the screen (typically left), containing navigation links and app information.
- **AppBar Integration**: Drawer is accessed via the hamburger menu icon (☰) in the AppBar's leading position. When tapped, the Drawer slides open.
- **Code Reusability**: Create a shared widget/component to avoid duplicating drawer code across screens.
- **Responsive Design**: Use `MediaQuery` and `LayoutBuilder` to detect screen size and adjust navigation UI accordingly.

- Scope: Unified navigation accessible from Order, Cart, Checkout, Profile, and About screens.
- Constraints:
  - Use existing app styling and theme.
  - Maintain current navigation flow (no breaking changes).
  - Support both mobile and desktop/web layouts.
  - Ensure accessibility with proper semantic labels.

---

## 2. User Stories

### Story 1: Access Drawer Navigation

- As a user, I can tap the menu icon in the AppBar on any screen, so I can access the navigation drawer.
- As a user, I see a drawer slide in from the left showing all available screens, so I can navigate anywhere in the app.

### Story 2: Navigate Between Screens

- As a user, I can tap any item in the drawer to navigate to that screen, so I can quickly access different parts of the app.
- As a user, the drawer automatically closes after selecting a destination, so the UI remains clean.

### Story 3: Visual Feedback

- As a user, I see which screen I'm currently on highlighted in the drawer, so I know my location in the app.
- As a user, I see appropriate icons next to each navigation item, so I can quickly identify destinations.

### Story 4: Responsive Navigation

- As a user on a wide screen (web/desktop), I see an alternative navigation UI (persistent sidebar or top nav bar) instead of a hidden drawer, so navigation is more efficient for larger screens.
- As a user on mobile, I see the traditional drawer that slides in/out, so the screen space is maximized for content.

### Story 5: Consistent Experience

- As a user, I see the same navigation options on all screens, so the app feels cohesive.
- As a user, navigation preserves my cart state when switching between screens, so I don't lose my order.

---

## 3. Acceptance Criteria

### Drawer Widget Implementation

- UI Components:
  - Drawer header with app logo, name, and optional branding.
  - Navigation items for all screens:
    - Order Sandwiches (home icon)
    - View Cart (shopping cart icon) - shows item count badge
    - My Profile (person icon)
    - About Us (info icon)
  - Drawer footer with version or copyright info (optional).
- Behavior:
  - Drawer opens from left edge when hamburger icon tapped.
  - Tapping outside drawer or on navigation item closes it.
  - Current screen highlighted with different background color or indicator.
  - Smooth slide animation (Material Design default).

### AppBar Integration

- Every screen includes:
  - AppBar with leading hamburger menu icon (when drawer is enabled).
  - Tapping hamburger opens the drawer.
  - Screen title centered or left-aligned.
  - App logo in AppBar (consistent across screens).
- Behavior:
  - Back button automatically appears on sub-screens (Cart, Profile, About) when navigating via push.
  - Drawer takes precedence on home screen (Order screen).

### Code Reusability

- Create shared component:
  - `NavigationDrawerWidget` or similar - a reusable StatelessWidget containing drawer UI.
  - `AppScaffold` or `BaseScaffold` - optional wrapper widget that provides consistent AppBar + Drawer to all screens.
- Usage:
  - All screens use the shared drawer widget or base scaffold.
  - No code duplication - drawer defined once, used everywhere.
  - Easy to update navigation links in one place.

### Responsive Design

- Mobile/Narrow Screens (width < 600px):
  - Drawer hidden by default, accessed via hamburger menu.
  - Full-screen drawer slides in from left.
- Tablet/Medium Screens (width 600-1200px):
  - Same drawer behavior as mobile, or optional persistent drawer.
- Desktop/Wide Screens (width > 1200px):
  - Option 1: Persistent drawer/sidebar always visible.
  - Option 2: Top navigation bar with horizontal menu items.
  - Option 3: Keep drawer but with wider drawer width.
- Implementation:
  - Use `MediaQuery.of(context).size.width` to detect screen width.
  - Use `LayoutBuilder` for fine-grained responsive layout control.
  - Adjust drawer width, visibility, or switch to alternative navigation based on breakpoints.

### Navigation Behavior

- Navigation Method:
  - Use `Navigator.pushReplacement` or named routes to avoid deep navigation stacks when switching between main screens.
  - Order screen remains root/home - other main screens replace rather than push.
  - Cart with items should allow pushing to Checkout (existing flow preserved).
- State Preservation:
  - Cart state preserved across all navigation (already handled via shared Cart instance).
  - Form state in Profile screen cleared or preserved as appropriate.

### Visual Design

- Drawer Header:
  - Background color matching app theme (e.g., deep purple).
  - White text and logo.
  - Height ~150-200px.
- Navigation Items:
  - List of `ListTile` widgets with icon, text, and optional trailing badge.
  - Current item highlighted with background tint or leading indicator.
  - Icons use Material Icons matching each screen's purpose.
- Dividers:
  - Divider between header and items.
  - Optional divider between item groups (main screens vs. settings/about).

### Testing

- Widget tests verify:
  - Drawer renders with all navigation items.
  - Tapping hamburger icon opens drawer.
  - Tapping drawer item navigates to correct screen.
  - Current screen is highlighted in drawer.
  - Drawer closes after navigation.
  - Cart badge shows correct item count.
  - Responsive layout switches at correct breakpoints.
  - All screens display consistent AppBar and drawer.
- Integration tests:
  - Navigate between all screens via drawer.
  - Verify cart state persists across navigation.
  - Test responsive behavior at different screen sizes.

### Definition of Done

- `NavigationDrawerWidget` or equivalent reusable component created.
- All screens (Order, Cart, Checkout, Profile, About) integrated with navigation drawer.
- Responsive behavior implemented with at least 2 breakpoints (mobile/desktop).
- Current screen highlighted in drawer.
- Cart item count badge displayed in drawer.
- No code duplication - drawer defined once.
- Widget tests written and passing for drawer functionality.
- Integration tests verify navigation flow.
- Code follows existing patterns and passes lint checks.
- App tested on mobile and web layouts.
- No regressions in existing functionality.
