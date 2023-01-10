import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:flutter/material.dart';

class AddGroceryItemView extends StatefulWidget {
  const AddGroceryItemView({
    required this.groceryId,
    required this.onItemAdded,
    Key? key,
  }) : super(key: key);

  final ValueSetter<GroceryItem> onItemAdded;
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
                    // New grocery item is created
                    final item = GroceryItem(
                      count: int.parse(countController.text),
                      name: itemController.text,
                      isBought: false,
                      groceryID: widget.groceryId,
                    );

// Mutation is created and passed.
                    final mutation = ModelMutations.create(item);
                    final result = await runMutation(mutation, (error) {
                      safePrint(error);
                    });

// Added item returned to be part of the list
                    if (result != null) {
                      widget.onItemAdded(result);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
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
