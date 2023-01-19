import 'package:flutter/material.dart';

typedef GroceryItemSetter = void Function(
  int count,
  String itemName,
  String groceryId,
);

class AddGroceryItemView extends StatefulWidget {
  const AddGroceryItemView({
    required this .groceryId,
    required this.onItemAdded,
    Key? key,
  }) : super(key: key);

  final GroceryItemSetter onItemAdded;
  final String groceryId;

  @override
  State<AddGroceryItemView> createState() => _AddGroceryItemViewState();
}

class _AddGroceryItemViewState extends State<AddGroceryItemView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController itemController;
  late final TextEditingController countController;

  @override
  void initState() {
    super.initState();
    itemController = TextEditingController();
    countController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onItemAdded(
                      int.parse(countController.text),
                      itemController.text,
                      widget.groceryId,
                    );
                  }
                },
                child: const Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
