import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/widgets/app_drawer.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  final int maxQuantity;

  const CartScreen({super.key, required this.cart, required this.maxQuantity});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  Sandwich? _lastRemovedSandwich;
  int? _lastRemovedQty;
  final Map<Sandwich, TextEditingController> _quantityControllers = {};

  void _goBack() {
    Navigator.pop(context);
  }

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  String _getSizeText(bool isFootlong) {
    return isFootlong ? 'Footlong' : 'Six-inch';
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  TextEditingController _getController(Sandwich sandwich, int quantity) {
    if (_quantityControllers.containsKey(sandwich)) {
      final controller = _quantityControllers[sandwich]!;
      final currentText = controller.text;
      final newText = quantity.toString();
      if (currentText != newText) {
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
      return controller;
    } else {
      final controller = TextEditingController(text: quantity.toString());
      _quantityControllers[sandwich] = controller;
      return controller;
    }
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    _quantityControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentRoute: '/cart', cart: widget.cart),
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 40,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(width: 12),
            const Text(
              'Cart View',
              style: heading1,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              if (widget.cart.isEmpty)
                Column(
                  children: const [
                    SizedBox(height: 40),
                    Text('Your cart is empty', style: heading2),
                    SizedBox(height: 8),
                    Text('Add sandwiches from the order screen.',
                        style: normalText),
                    SizedBox(height: 40),
                  ],
                )
              else
                for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                  Column(
                    children: [
                      Text(entry.key.name, style: heading2),
                      Text(
                        '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                        style: normalText,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: entry.value > 1
                                ? () {
                                    final newQty = entry.value - 1;
                                    setState(() {
                                      widget.cart
                                          .updateQuantity(entry.key, newQty);
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              controller:
                                  _getController(entry.key, entry.value),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                border: OutlineInputBorder(),
                              ),
                              onFieldSubmitted: (val) {
                                final parsed = int.tryParse(val.trim());
                                if (parsed == null) {
                                  // revert to current quantity in controller
                                  _getController(entry.key, entry.value).text =
                                      entry.value.toString();
                                  setState(() {});
                                  return;
                                }
                                int clamped = parsed;
                                if (clamped < 1) clamped = 1;
                                if (clamped > widget.maxQuantity) {
                                  clamped = widget.maxQuantity;
                                }
                                setState(() {
                                  widget.cart
                                      .updateQuantity(entry.key, clamped);
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: entry.value < widget.maxQuantity
                                ? () {
                                    final newQty = entry.value + 1;
                                    setState(() {
                                      widget.cart
                                          .updateQuantity(entry.key, newQty);
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              _lastRemovedSandwich = entry.key;
                              _lastRemovedQty = entry.value;
                              setState(() {
                                widget.cart.removeItem(entry.key);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Item removed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      if (_lastRemovedSandwich != null &&
                                          _lastRemovedQty != null) {
                                        setState(() {
                                          widget.cart.updateQuantity(
                                            _lastRemovedSandwich!,
                                            _lastRemovedQty!,
                                          );
                                        });
                                      }
                                    },
                                  ),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            },
                            tooltip: 'Remove item',
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                      Text(
                        '£${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                        style: normalText,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              if (!widget.cart.isEmpty)
                Text(
                  'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                  style: heading2,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Builder(
                builder: (BuildContext context) {
                  final bool cartHasItems = widget.cart.items.isNotEmpty;
                  if (cartHasItems) {
                    return StyledButton(
                      onPressed: _navigateToCheckout,
                      icon: Icons.payment,
                      label: 'Checkout',
                      backgroundColor: Colors.orange,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
