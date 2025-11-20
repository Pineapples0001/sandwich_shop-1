import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('six-inch unit price and total', () {
      final repo = PricingRepository(quantity: 2, isFootlong: false);
      expect(repo.unitPrice, 7.0);
      expect(repo.totalPrice, 14.0);
      expect(repo.formattedTotal(), '£14.00');
    });

    test('footlong unit price and total', () {
      final repo = PricingRepository(quantity: 3, isFootlong: true);
      expect(repo.unitPrice, 11.0);
      expect(repo.totalPrice, 33.0);
      expect(repo.formattedTotal(), '£33.00');
    });

    test('static calculateTotal helper', () {
      expect(
        PricingRepository.calculateTotal(quantity: 1, isFootlong: false),
        7.0,
      );
      expect(
        PricingRepository.calculateTotal(quantity: 4, isFootlong: true),
        44.0,
      );
    });
  });
}
