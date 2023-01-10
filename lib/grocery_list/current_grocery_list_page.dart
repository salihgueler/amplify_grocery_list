import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_view.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_view.dart';
import 'package:amplify_grocery_list/grocery_list/previous_groceries_page.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CurrentGroceryListPage extends StatefulWidget {
  const CurrentGroceryListPage({Key? key}) : super(key: key);

  @override
  State<CurrentGroceryListPage> createState() => _CurrentGroceryListPageState();
}

class _CurrentGroceryListPageState extends State<CurrentGroceryListPage> {
  final items = <GroceryItem>[];

  void onItemAdded(GroceryItem item) {
    setState(() {
      items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Grocery>(
      future: fetchCurrentGrocery(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // (1) Define the current grocery list.
          final grocery = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Current Grocery List'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PreviousGroceriesPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                ),
                IconButton(
                  onPressed: () {
                    Amplify.Auth.signOut();
                  },
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (isMobile()) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0) +
                          MediaQuery.of(context).viewInsets,
                      child: AddGroceryItemView(
                        onItemAdded: onItemAdded,
                        groceryId: grocery.id,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        backgroundColor: Colors.transparent,
                        children: [
                          AddGroceryItemView(
                            onItemAdded: onItemAdded,
                            groceryId: grocery.id,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              label: const Text('Add Item'),
            ),
            body: items.isEmpty
                ? const Center(
                    child: Text('No current groceries'),
                  )
                : ListView.builder(
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return ElevatedButton(
                          onPressed: () {
                            if (isMobile()) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(8.0) +
                                      MediaQuery.of(context).viewInsets,
                                  child: FinalizeGroceryView(
                                    items: List.from(items),
                                    currentGrocery: grocery,
                                    onFinalized: () {
                                      setState(() {
                                        items.clear();
                                      });
                                    },
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    backgroundColor: Colors.transparent,
                                    children: [
                                      FinalizeGroceryView(
                                        items: List.from(items),
                                        currentGrocery: grocery,
                                        onFinalized: () {
                                          setState(() {
                                            items.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text('End shopping'),
                        );
                      } else {
                        final item = items[index];
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isBought
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle:
                              Text('You need to buy ${item.count} of these'),
                        );
                      }
                    },
                  ),
          );
        }
      },
    );
  }

  Future<Grocery> fetchCurrentGrocery() async {
    // (1) Get the available grocery list for the current item
    final queryPredicate = Grocery.FINALIZATIONDATE.eq(null);
    final groceryRequest =
        ModelQueries.list<Grocery>(Grocery.classType, where: queryPredicate);
    final groceryResponse =
        await Amplify.API.query(request: groceryRequest).response;
    final grocery = groceryResponse.data?.items.whereNotNull().singleOrNull;
    // (2) Grocery items needs to be shown as well for the current item, that item is processed with grocery
    if (grocery != null) {
      final id = grocery.id;
      final queryPredicate = GroceryItem.GROCERYID.eq(id);
      final groceryItemRequest = ModelQueries.list<GroceryItem>(
        GroceryItem.classType,
        where: queryPredicate,
      );
      final groceryItemResponse =
          await Amplify.API.query(request: groceryItemRequest).response;
      final fetchedItems = groceryItemResponse.data?.items
          .whereNotNull()
          .toList(growable: false);
      items
        ..clear()
        ..addAll(fetchedItems ?? []);
      return grocery.copyWith(
        groceryItems: fetchedItems,
      );
    } else {
      final grocery = Grocery(groceryItems: const <GroceryItem>[]);
      final request = ModelMutations.create(grocery);
      await runMutation(request, (error) {
        safePrint(
            'The creationg has failed. Try it again or check the errors: $error');
      });
      return grocery;
    }
  }
}
