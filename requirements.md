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
