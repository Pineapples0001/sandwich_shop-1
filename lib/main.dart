import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String? _selectedType = 'Footlong'; // new state (nullable to be defensive)

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sandwich Counter'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
                    Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: DropdownButtonFormField<String?>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Sandwich Size',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Footlong', child: Text('Footlong')),
                DropdownMenuItem(value: 'Six-inch', child: Text('Six-inch')),
              ],
              onChanged: (value) {
                // be defensive: allow null but keep previous value if null
                if (value != null) setState(() => _selectedType = value);
              },
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 4,
            ),
          ),
          const SizedBox(height: 8),
          OrderItemDisplay(
            _quantity,
            _selectedType ?? 'Footlong', // ensure non-null string is passed
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140, // <--- button width here
                child: ElevatedButton(
                  onPressed: _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => states.contains(MaterialState.disabled) ? Colors.grey.shade400 : Colors.red,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Add'),
                ),
              ),
              const SizedBox(width: 24), // <--- gap between buttons
              SizedBox(
                width: 140, // <--- button width here
                child: ElevatedButton(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => states.contains(MaterialState.disabled) ? Colors.grey.shade400 : Theme.of(context).colorScheme.primary,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    final sandwiches = List.filled(quantity, '🥪').join();
    return Text('$quantity $itemType sandwich(es): $sandwiches');
  }
}
