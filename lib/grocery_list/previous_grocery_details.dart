import 'package:amplify_grocery_list/models/temporary_previous_grocery.dart';
import 'package:flutter/material.dart';

class PreviousGroceryDetailsPage extends StatelessWidget {
  const PreviousGroceryDetailsPage({
    required this.item,
    Key? key,
  }) : super(key: key);

  final TemporaryPreviousGrocery item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title!),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
                'Amount spent: ${item.totalAmount} on ${item.finalizationDate}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('File saved at: ${item.filePath}'),
          ),
          // TODO(12): Add ui to show the uploaded image
          Expanded(
            child: Column(
              children: item.groceryItems!
                  .map(
                    (groceryItem) => ListTile(
                      title: Text(groceryItem.name),
                      subtitle:
                          Text('You bought ${groceryItem.count} of these'),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
