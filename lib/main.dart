import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const ShoppingListPage(),
    );
  }
}

class Item {
  Item({required this.name, this.bought = false, this.quantity = 1});

  final String name;
  bool bought;
  int quantity;
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Item> _items = [
    Item(name: 'Milk'),
    Item(name: 'Bread'),
    Item(name: 'Rice'),
  ];

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(Item(name: text));
    });
    _controller.clear();
  }

  void _toggleBought(int index) {
    setState(() {
      _items[index].bought = !_items[index].bought;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    });
  }

  Widget _buildRow(int index) {
    final item = _items[index];
    return ListTile(
      onTap: () => _toggleBought(index),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.bought
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: item.bought ? Colors.grey : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _decrementQuantity(index),
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _incrementQuantity(index),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteItem(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add an item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addItem, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Your list is empty'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) => _buildRow(index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
