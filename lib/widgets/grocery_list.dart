import 'package:shopping_list/data/categories.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as myhttp;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'shopping-list-c97ea-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list_Folder.json');
    final response = await myhttp.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.type == item.value['category'])
          .value;
      loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      ));
    }
    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) return;
    setState(
      () {
        _groceryItems.add(newItem);
      },
    );
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items are added yet'));
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          final item = _groceryItems[index];
          return Dismissible(
            onDismissed: (direction) {
              _removeItem(item);
            },
            key: ValueKey(item.id),
            child: ListTile(
              title: Text(item.name),
              leading: Container(
                width: 24,
                height: 24,
                color: item.category.colour,
              ),
              trailing: Text(
                item.quantity.toString(),
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
