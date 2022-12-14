import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_view.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_view.dart';
import 'package:amplify_grocery_list/grocery_list/previous_groceries_page.dart';
import 'package:amplify_grocery_list/models/temporary_grocery_item.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:flutter/material.dart';

class CurrentGroceryListPage extends StatefulWidget {
  const CurrentGroceryListPage({Key? key}) : super(key: key);

  @override
  State<CurrentGroceryListPage> createState() => _CurrentGroceryListPageState();
}

class _CurrentGroceryListPageState extends State<CurrentGroceryListPage> {
  final items = <TemporaryGroceryItem>[];

  void onItemAdded(TemporaryGroceryItem item) {
    setState(() {
      items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // TODO(4): Initialize Amplify and Add Authentication
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
                child: AddGroceryItemView(onItemAdded: onItemAdded),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: [
                    AddGroceryItemView(onItemAdded: onItemAdded),
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
                    subtitle: Text('You need to buy ${item.count} of these'),
                  );
                }
              },
            ),
    );
  }
}
