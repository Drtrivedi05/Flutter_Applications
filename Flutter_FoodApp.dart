import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp = MaterialApp(
      title: 'Food Shop App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FoodShopScreen(),
      debugShowCheckedModeBanner: false,
    );

    return materialApp;
  }
}

class FoodShopScreen extends StatefulWidget {
  @override
  _FoodShopScreenState createState() => _FoodShopScreenState();
}

class _FoodShopScreenState extends State<FoodShopScreen> {
  List<Item> items = [
    Item(name: "Breakfast", unitPrice: 40, initialStock: 30),
    Item(name: "Lunch", unitPrice: 80, initialStock: 40),
    Item(name: "Dinner", unitPrice: 60, initialStock: 30),
  ];

  int totalSaleAmountAchieved = 0;
  int totalTargetSaleAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalTargetSaleAmount();
  }

  void calculateTotalTargetSaleAmount() {
    totalTargetSaleAmount = items.fold(0, (sum, item) => sum + (item.initialStock * item.unitPrice));
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text("Food Shop"),
    );

    List<Widget> itemSections = items.map((item) {
      ItemSection section = ItemSection(
        item: item,
        onOrderPlaced: (quantity) {
          setState(() {
            item.quantitySold += quantity;
            item.quantityRemaining -= quantity;
            totalSaleAmountAchieved += item.unitPrice * quantity;
          });
        },
      );
      return section;
    }).toList();

    SizedBox space = SizedBox(height: 20);

    Text targetText = Text("Total Target Sale Amount: Rs. $totalTargetSaleAmount");
    Text achievedText = Text("Total Sale Amount Achieved: Rs. $totalSaleAmountAchieved");
    Text remainingText = Text("Remaining from Target: Rs. ${totalTargetSaleAmount - totalSaleAmountAchieved}");

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemSections,
        space,
        targetText,
        achievedText,
        remainingText,
      ],
    );

    Padding padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: column,
    );

    Scaffold scaffold = Scaffold(
      appBar: appBar,
      body: padding,
    );

    return scaffold;
  }
}

class ItemSection extends StatefulWidget {
  final Item item;
  final Function(int) onOrderPlaced;

  ItemSection({required this.item, required this.onOrderPlaced});

  @override
  _ItemSectionState createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  int selectedQuantity = 1;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice = widget.item.unitPrice * selectedQuantity;
  }

  List<int> getAvailableQuantities() {
    List<int> quantities = [1, 2, 3, 4, 5];
    quantities.removeRange(
        widget.item.quantityRemaining < 5 ? widget.item.quantityRemaining : 5, quantities.length);
    return quantities;
  }

  @override
  Widget build(BuildContext context) {
    Text itemName = Text(
      widget.item.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    Text quantityLabel = Text("Quantity to sell:");

    DropdownButton<int> quantityDropdown = DropdownButton<int>(
      value: selectedQuantity,
      items: getAvailableQuantities().map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedQuantity = value;
            calculateTotalPrice();
          });
        }
      },
    );

    Row quantityRow = Row(
      children: [quantityLabel, quantityDropdown],
    );

    Text priceText = Text("Total Price: Rs. $totalPrice");

    ElevatedButton placeOrderButton = ElevatedButton(
      onPressed: widget.item.quantityRemaining > 0
          ? () {
        widget.onOrderPlaced(selectedQuantity);
        setState(() {
          selectedQuantity = 1;
          calculateTotalPrice();
        });
      }
          : null,
      child: const Text("Place Order"),
    );

    Text soldText = Text("Total Quantity Sold: ${widget.item.quantitySold}");
    SizedBox spacing = SizedBox(width: 20);
    Chip remainingChip = Chip(label: Text("Remaining: ${widget.item.quantityRemaining}"));

    Row soldRow = Row(
      children: [soldText, spacing, remainingChip],
    );

    Divider divider = Divider();

    Column itemColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemName,
        quantityRow,
        priceText,
        placeOrderButton,
        soldRow,
        divider,
      ],
    );

    return itemColumn;
  }
}

class Item {
  String name;
  int unitPrice;
  int initialStock;
  int quantityRemaining;
  int quantitySold;

  Item({
    required this.name,
    required this.unitPrice,
    required this.initialStock,
  })  : quantityRemaining = initialStock,
        quantitySold = 0;
}
