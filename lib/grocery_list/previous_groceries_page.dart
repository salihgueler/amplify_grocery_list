import 'package:amplify_grocery_list/grocery_list/previous_grocery_details.dart';
import 'package:amplify_grocery_list/models/temporary_previous_grocery.dart';
import 'package:flutter/material.dart';

final previousGroceries = <TemporaryPreviousGrocery>[];

class PreviousGroceriesPage extends StatelessWidget {
  const PreviousGroceriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Groceries'),
      ),
      body: previousGroceries.isEmpty
          ? const Center(
              child: Text('No previous groceries in the list yet'),
            )
          : ListView.builder(
              itemCount: previousGroceries.length,
              itemBuilder: (context, index) {
                final item = previousGroceries[index];
                return ListTile(
                  title: Text(item.title!),
                  subtitle: Text(
                    'You paid ${item.totalAmount} on ${item.finalizationDate}',
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PreviousGroceryDetailsPage(
                            item: item,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
