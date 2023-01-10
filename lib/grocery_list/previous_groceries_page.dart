import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/grocery_list/previous_grocery_details.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PreviousGroceriesPage extends StatelessWidget {
  const PreviousGroceriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Groceries'),
      ),
      body: FutureBuilder<List<Grocery>>(
        future: fetchPreviousGroceries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final previousGroceries = snapshot.data!;
            return ListView.builder(
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
            );
          } else {
            return const Center(
              child: Text('No previous groceries in the list yet'),
            );
          }
        },
      ),
    );
  }

  Future<List<Grocery>> fetchPreviousGroceries() async {
    final queryPredicate = Grocery.FINALIZATIONDATE.ne(null);
    final request =
        ModelQueries.list<Grocery>(Grocery.classType, where: queryPredicate);
    final response = await Amplify.API.query(request: request).response;
    return response.data?.items.whereNotNull().toList(growable: false) ??
        <Grocery>[];
  }
}
