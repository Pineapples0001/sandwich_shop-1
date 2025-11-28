// lib/models/sandwich_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns correct human-readable names', () {
      final expectedNames = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      expectedNames.forEach((type, expected) {
        final sandwich = Sandwich(
          type: type,
          isFootlong: true,
          breadType: BreadType.white,
        );
        expect(sandwich.name, expected);
      });
    });

    test('image getter builds correct asset path for footlong', () {
      final type = SandwichType.tunaMelt;
      final sandwich = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      expect(sandwich.image, 'assets/images/${type.name}_footlong.png');
    });

    test('image getter builds correct asset path for six_inch', () {
      final type = SandwichType.meatballMarinara;
      final sandwich = Sandwich(
        type: type,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      expect(sandwich.image, 'assets/images/${type.name}_six_inch.png');
    });

    test('image getter is independent of bread type and uses enum name exactly', () {
      final type = SandwichType.chickenTeriyaki;
      final sand1 = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sand2 = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      expect(sand1.image, sand2.image);
      expect(sand1.image, 'assets/images/${type.name}_footlong.png');
    });
  });
}