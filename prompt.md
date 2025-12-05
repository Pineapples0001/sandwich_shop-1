```markdown
You are helping implement cart item modification features in a Flutter sandwich shop app with two pages:

- Order screen: users select sandwiches and add them to a cart.
- Cart screen: users view cart items and total price.

Goal: Add robust cart editing capabilities: change item quantity and remove items entirely. Use simple, idiomatic Flutter and keep logic consistent with existing models and repositories. Assume a `Cart` model, `Sandwich` model, and a `PricingRepository` exist.

Deliverables:

1. UI changes (widgets and interactions)
2. State updates (Cart updates, total price recalculation)
3. Edge-case handling
4. Minimal tests for the updated cart behavior

General Requirements:

- Keep updates localized to cart-related code and views.
- Ensure the cart total updates reactively with any change.
- Handle quantity bounds: minimum 1, maximum equals `OrderScreen.maxQuantity`.
- Avoid breaking current order flow: adding to cart from the order screen must still work.
- If the cart becomes empty, show an "Empty cart" state and disable checkout.
- Do not add new dependencies unless necessary.

Features to implement:

Feature: Change Quantity (Increment/Decrement)

- Description: Let users increase or decrease the quantity of a specific sandwich already in the cart.
- UI: In `CartScreen`, show each item with a quantity control (e.g., `-` and `+` buttons or a `Stepper`), and the item’s subtotal.
- Action: When the user taps `+`, increase quantity by 1 up to `OrderScreen.maxQuantity`. When the user taps `-`, decrease by 1; if it reaches 0, prompt to remove or automatically remove based on UX choice (see next feature).
- Expected Behavior:
  - Update the item’s quantity in `Cart`.
  - Recalculate subtotal for that item and cart total using `PricingRepository`.
  - Disable `+` when quantity == `maxQuantity`; disable `-` when quantity == 1 (if not auto-removing at 0).
  - Persist changes in the current app state and reflect immediately in the UI.

Feature: Direct Quantity Edit (Optional)

- Description: Allow editing quantity via a number input (e.g., `TextField` or `Dropdown`).
- UI: A compact numeric input per item, validated on submit.
- Action: On change, clamp value to `[1, maxQuantity]`.
- Expected Behavior:
  - Reject non-numeric input; show inline error or revert to last valid value.
  - Update the `Cart` and totals upon valid input commit.

Feature: Remove Item

- Description: Let users remove an item entirely from the cart.
- UI: Each item should have a remove affordance (trash icon or "Remove" button).
- Action: On tap, confirm removal (modal or snackbar with undo).
- Expected Behavior:
  - Remove the item from `Cart`.
  - Recalculate the cart total.
  - If cart becomes empty, show the empty state and disable checkout.
  - If using "undo," restore the item within a short timeout.

Feature: Undo Remove (Optional, Nice-to-have)

- Description: Provide a brief window to undo accidental removal.
- UI: Show a `SnackBar` with "Item removed" and an "Undo" action.
- Action: If Undo is tapped, restore the last removed item with its previous quantity.
- Expected Behavior:
  - Restore item in `Cart`.
  - Recalculate totals.
  - Dismiss snackbar after timeout or on navigation.

Feature: Price and Total Recalculation

- Description: Every modification should immediately reflect price changes.
- UI: Show per-item subtotal and a cart total summary at the bottom.
- Action: Invoke pricing logic (via `PricingRepository`) after any quantity change or removal.
- Expected Behavior:
  - Correct, up-to-date totals without requiring a manual refresh.
  - If discounts or tiered pricing exist, ensure they are applied based on the updated quantities.

Edge Cases:

- Max quantity: Prevent exceeding `OrderScreen.maxQuantity`; provide subtle visual feedback (e.g., disabled `+`).
- Min quantity: If using decrement to 0, confirm removal; otherwise clamp to 1.
- Empty cart: Show empty state, hide item list, disable checkout.
- Invalid input: Reject or correct non-numeric or out-of-range values gracefully.
- Rapid taps: Debounce or ensure state updates are consistent to prevent race conditions.
- Navigation: Ensure returning to the order screen reflects the current cart state.

Implementation Notes:

- Favor `setState`, `ChangeNotifier`, or existing state management used in the app; do not introduce new global state unless app already uses it.
- Keep UI accessible: buttons have tooltips, hit targets are adequate.
- Write small unit tests for:
  - Quantity increment/decrement clamping.
  - Removal and undo behavior.
  - Total recalculation after changes.

What to Provide:

- Updated `CartScreen` widget code snippet for quantity controls and remove action.
- Updates to the `Cart` model methods (e.g., `updateQuantity`, `removeItem`, `getTotal`).
- Minimal test cases validating cart behavior and pricing updates.
- Brief rationale for any UX choices (auto-remove at 0 vs confirm).

Constraints:

- Keep code changes minimal and aligned with existing styles.
- No unrelated refactors.
- No new license headers.

If anything is unclear about the existing `Cart`, `Sandwich`, or `PricingRepository` APIs, propose small adapter methods and document them briefly.
```
