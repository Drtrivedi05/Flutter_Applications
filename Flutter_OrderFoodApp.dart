import 'package:flutter/material.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  State<FoodOrderPage> createState() => FoodOrderPageState();
}

class FoodOrderPageState extends State<FoodOrderPage> {
  bool selectAll = false;
  bool pizza = false;
  bool fries = false;
  bool colddrink = false;

  String selectedItems = "";
  int totalPrice = 0;

  void updateItems() {
    List<String> items = [];
    int price = 0;

    if (pizza) {
      items.add("Pizza");
      price += 250;
    }
    if (fries) {
      items.add("French Fries");
      price += 80;
    }
    if (colddrink) {
      items.add("Colddrink");
      price += 50;
    }

    setState(() {
      selectedItems = items.join(", ");
      totalPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Food')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Select All'),
              value: selectAll,
              onChanged: (value) {
                setState(() {
                  selectAll = value!;
                  pizza = fries = colddrink = selectAll;
                  updateItems();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Pizza (Rs.250)'),
              value: pizza,
              onChanged: (value) {
                setState(() {
                  pizza = value!;
                  updateItems();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('French Fries (Rs.80)'),
              value: fries,
              onChanged: (value) {
                setState(() {
                  fries = value!;
                  updateItems();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Colddrink (Rs.50)'),
              value: colddrink,
              onChanged: (value) {
                setState(() {
                  colddrink = value!;
                  updateItems();
                });
              },
            ),
            const SizedBox(height: 20),
            Text("Selected Items: $selectedItems", style: const TextStyle(fontSize: 16)),
            Text("Total Price: Rs. $totalPrice", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
