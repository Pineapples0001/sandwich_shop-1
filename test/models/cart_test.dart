import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    late PricingRepository pricingRepository;
    late Cart cart;

    setUp(() {
      pricingRepository = PricingRepository();
      cart = Cart(pricingRepository);
    });

    test('add groups identical sandwiches and increments quantity', () {
      final s = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.white);

      cart.add(s);
      cart.add(s, 2);

      expect(cart.items.length, 1);
      expect(cart.items.first.sandwich, s);
      expect(cart.items.first.quantity, 3);
    });

    test('subtract decreases quantity and removes when zero or less', () {
      final s = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.wheat);

      cart.add(s, 3);
      cart.subtract(s);
      expect(cart.items.first.quantity, 2);

      cart.subtract(s, 2);
      expect(cart.items.length, 0);
    });

    test('edit sets exact quantity and creates item when missing', () {
      final s = Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: true, breadType: BreadType.wholemeal);

      cart.edit(s, 4);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 4);

      cart.edit(s, 2);
      expect(cart.items.first.quantity, 2);

      cart.edit(s, 0);
      expect(cart.items.length, 0);
    });

    test('delete removes an item entirely', () {
      final a = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.white);
      final b = Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.wheat);

      cart.add(a, 1);
      cart.add(b, 2);

      expect(cart.items.length, 2);

      cart.delete(a);
      expect(cart.items.length, 1);
      expect(cart.items.first.sandwich.type, SandwichType.meatballMarinara);
    });

    test('clear removes all items', () {
      final a = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.white);
      final b = Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.wheat);

      cart.add(a, 1);
      cart.add(b, 2);
      expect(cart.items.isNotEmpty, true);

      cart.clear();
      expect(cart.items.isEmpty, true);
    });

    test('itemPrice and totalPrice compute correctly', () async {
      final footlong = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.white);
      final six = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.wheat);

      cart.add(footlong, 2); // 2 * 11.00 = 22.0
      cart.add(six, 1); // 1 * 7.00 = 7.0

      final itemPrice = await cart.itemPrice(footlong);
      expect(itemPrice, 22.0);

      final total = await cart.totalPrice();
      expect(total, 29.0);
    });
  });
}
