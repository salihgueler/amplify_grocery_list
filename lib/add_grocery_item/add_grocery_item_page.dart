import 'package:flutter/material.dart';

typedef GroceryItemSetter = void Function(
  int count,
  double amount,
  String itemName,
  String groceryId,
);

class AddGroceryItemPage extends StatefulWidget {
  const AddGroceryItemPage({
    required this.groceryId,
    required this.onItemAdded,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  final GroceryItemSetter onItemAdded;
  final String groceryId;
  final bool isLoading;

  @override
  State<AddGroceryItemPage> createState() => _AddGroceryItemPageState();
}

class _AddGroceryItemPageState extends State<AddGroceryItemPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController itemController = TextEditingController();
  late final TextEditingController countController = TextEditingController();
  late final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    countController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Grocery Item'),
      ),
      body: Form(
        key: _formKey,
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Item',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please do not leave the item field empty.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: countController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Count (Should be an integer)',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please do not leave the count field empty.';
                    }
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null) {
                      return 'The value you entered is not an integer number.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount (Should be a number)',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please do not leave the amount field empty.';
                    }
                    final parsedValue = double.tryParse(value);
                    if (parsedValue == null) {
                      return 'The value you entered is not a number.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: widget.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            widget.onItemAdded(
                              int.parse(countController.text),
                              double.parse(amountController.text),
                              itemController.text,
                              widget.groceryId,
                            );
                          }
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Add Item'),
                      if (widget.isLoading) ...const [
                        SizedBox(width: 8),
                        SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
