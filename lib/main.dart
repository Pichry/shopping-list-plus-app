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
  String _filter = 'All';

  List<int> get _visibleIndices {
    final all = List<int>.generate(_items.length, (i) => i);
    switch (_filter) {
      case 'To buy':
        return all.where((i) => !_items[i].bought).toList();
      case 'Bought':
        return all.where((i) => _items[i].bought).toList();
      default:
        // Bought items always sit at the bottom, both groups keeping
        // their original order.
        return [
          ...all.where((i) => !_items[i].bought),
          ...all.where((i) => _items[i].bought),
        ];
    }
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final existingIndex = _items.indexWhere(
      (item) => item.name.toLowerCase() == text.toLowerCase(),
    );

    if (existingIndex == -1) {
      setState(() {
        _items.add(Item(name: text));
      });
    } else {
      setState(() {
        _items[existingIndex].quantity++;
      });
      final existing = _items[existingIndex];
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${existing.name} is already on the list: now ×${existing.quantity}',
          ),
        ),
      );
    }
    _controller.clear();
  }

  void _toggleBought(int index) {
    setState(() {
      _items[index].bought = !_items[index].bought;
    });
  }

  void _deleteItem(int index) {
    final removedItem = _items[index];

    setState(() {
      _items.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem.name} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _items.insert(index, removedItem);
            });
          },
        ),
      ),
    );
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

  Widget _buildList() {
    if (_items.isEmpty) {
      return const Center(child: Text('Your list is empty'));
    }

    final visible = _visibleIndices;
    if (visible.isEmpty) {
      return const Center(child: Text('Nothing here'));
    }

    return ListView.builder(
      itemCount: visible.length,
      itemBuilder: (context, i) => _buildRow(visible[i]),
    );
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
            Wrap(
              spacing: 8,
              children: ['All', 'To buy', 'Bought'].map((label) {
                return ChoiceChip(
                  label: Text(label),
                  selected: _filter == label,
                  onSelected: (_) => setState(() => _filter = label),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }
}
