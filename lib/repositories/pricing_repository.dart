class PricingRepository {
  static const double sixInchPrice = 7.0;
  static const double footlongPrice = 11.0;

  final int quantity;
  final bool isFootlong;

  PricingRepository({required this.quantity, required this.isFootlong});

  /// Price for a single sandwich depending on its size.
  double get unitPrice => isFootlong ? footlongPrice : sixInchPrice;

  /// Total price for the order (quantity * unit price).
  double get totalPrice => unitPrice * quantity;

  /// Returns a user-friendly formatted total price, e.g. "£21.00".
  String formattedTotal() => '£${totalPrice.toStringAsFixed(2)}';

  /// Convenience static method to calculate total without creating an instance.
  static double calculateTotal({required int quantity, required bool isFootlong}) {
    final unit = isFootlong ? footlongPrice : sixInchPrice;
    return unit * quantity;
  }
}
