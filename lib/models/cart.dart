import 'dart:async';

import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});
}

class Cart {
  final PricingRepository pricingRepository;
  final List<CartItem> _items = [];

  Cart(this.pricingRepository);

  List<CartItem> get items => List.unmodifiable(_items);

  // Add quantity (default 1). If item exists, increment quantity.
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _indexOf(sandwich);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  // Subtract quantity (default 1). Removes item when quantity <= 0.
  void subtract(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _indexOf(sandwich);
    if (idx < 0) return;
    _items[idx].quantity -= quantity;
    if (_items[idx].quantity <= 0) {
      _items.removeAt(idx);
    }
  }

  // Edit sets exact quantity; removes item if newQuantity <= 0.
  void edit(Sandwich sandwich, int newQuantity) {
    final idx = _indexOf(sandwich);
    if (newQuantity <= 0) {
      if (idx >= 0) _items.removeAt(idx);
      return;
    }
    if (idx >= 0) {
      _items[idx].quantity = newQuantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: newQuantity));
    }
  }

  // Delete removes the sandwich entirely from the cart.
  void delete(Sandwich sandwich) {
    final idx = _indexOf(sandwich);
    if (idx >= 0) _items.removeAt(idx);
  }

  // Returns the total price by using PricingRepository.calculatePrice
  // Returns the total price by using PricingRepository.calculatePrice.
  // Handles calculatePrice returning either `double`, `num`, `Future<double>` or `Future<num>`.
  Future<double> totalPrice() async {
    double total = 0.0;
    for (final item in _items) {
      final result = pricingRepository.calculatePrice(
        quantity: item.quantity,
        isFootlong: item.sandwich.isFootlong,
      );
      total += await _asFutureDouble(result);
    }
    return total;
  }

  // Returns the price for a single cart item (or 0 if not found).
  Future<double> itemPrice(Sandwich sandwich) async {
    final idx = _indexOf(sandwich);
    if (idx < 0) return 0.0;
    final item = _items[idx];
    final result = pricingRepository.calculatePrice(
      quantity: item.quantity,
      isFootlong: item.sandwich.isFootlong,
    );
    return await _asFutureDouble(result);
  }

  // Normalize the value returned by `calculatePrice` into a `Future<double>`.
  Future<double> _asFutureDouble(dynamic value) async {
    if (value is Future<double>) return await value;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is Future) {
      final res = await value;
      if (res is double) return res;
      if (res is num) return res.toDouble();
    }
    throw ArgumentError('calculatePrice returned unsupported type: ${value.runtimeType}');
  }

  // Helper to find item index by sandwich properties
  int _indexOf(Sandwich s) {
    for (var i = 0; i < _items.length; i++) {
      final other = _items[i].sandwich;
      if (_sameSandwich(s, other)) return i;
    }
    return -1;
  }

  bool _sameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type && a.isFootlong == b.isFootlong && a.breadType == b.breadType;
  }

  void clear() => _items.clear();
}