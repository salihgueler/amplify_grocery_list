import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_cubit.dart';
import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_view.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_view.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_view_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/current_grocery/current_grocery_list_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/previous_grocery_list/previous_groceries_page.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentGroceryListPage extends StatefulWidget {
  const CurrentGroceryListPage({Key? key}) : super(key: key);

  @override
  State<CurrentGroceryListPage> createState() => _CurrentGroceryListPageState();
}

class _CurrentGroceryListPageState extends State<CurrentGroceryListPage> {
  late final currentGroceryCubit = CurrentGroceryListCubit();

  @override
  void initState() {
    super.initState();
    currentGroceryCubit.fetchCurrentGrocery();
  }

  @override
  void dispose() {
    currentGroceryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGroceryListCubit, CurrentGroceryListState>(
      bloc: currentGroceryCubit,
      builder: (context, state) {
        if (state is CurrentGroceryListSuccess) {
          final grocery = state.currentGrocery;
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
                    currentGroceryCubit.signUserOut();
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
                      child: _AddGroceryItemView(
                        onItemAdded: (groceryItem) {
                          currentGroceryCubit.fetchCurrentGrocery();
                        },
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
                          _AddGroceryItemView(
                            onItemAdded: (groceryItem) {
                              currentGroceryCubit.fetchCurrentGrocery();
                            },
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
            body: grocery.groceryItems == null || grocery.groceryItems!.isEmpty
                ? const Center(
                    child: Text('No current groceries'),
                  )
                : _GroceryItemsView(
                    items: grocery.groceryItems!,
                    grocery: grocery,
                    onFinalized: () {
                      currentGroceryCubit.fetchCurrentGrocery();
                    },
                  ),
          );
        } else if (state is CurrentGroceryListError) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _FinalizeGroceryView extends StatefulWidget {
  const _FinalizeGroceryView({
    Key? key,
    required this.onFinalized,
    required this.grocery,
    required this.items,
  }) : super(key: key);

  final VoidCallback onFinalized;
  final Grocery grocery;
  final List<GroceryItem> items;

  @override
  State<_FinalizeGroceryView> createState() => _FinalizeGroceryViewState();
}

class _FinalizeGroceryViewState extends State<_FinalizeGroceryView> {
  late final FinalizeGroceryViewCubit finalizeGroceryViewCubit;

  @override
  void initState() {
    super.initState();
    finalizeGroceryViewCubit = FinalizeGroceryViewCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinalizeGroceryViewCubit, FinalizeGroceryViewState>(
      bloc: finalizeGroceryViewCubit,
      listener: (context, state) {
        if (state is FinalizeGroceryViewSuccess) {
          widget.onFinalized();
        }
      },
      builder: (context, state) {
        if (state is FinalizeGroceryViewLoading) {
          return const CircularProgressIndicator();
        } else if (state is FinalizeGroceryViewError) {
          return Text(state.errorMessage);
        } else {
          return FinalizeGroceryView(
            items: List.from(widget.items),
            currentGroceryId: widget.grocery.id,
            onFinalized: (
              totalAmount,
              title,
              id,
              finalizationDate,
              filePath,
            ) {
              finalizeGroceryViewCubit.finalizeGrocery(
                filePath,
                id,
                title,
                totalAmount,
                widget.grocery,
              );
            },
          );
        }
      },
    );
  }
}

class _AddGroceryItemView extends StatefulWidget {
  const _AddGroceryItemView({
    required this.onItemAdded,
    required this.groceryId,
    Key? key,
  }) : super(key: key);

  final ValueSetter<GroceryItem> onItemAdded;
  final String groceryId;

  @override
  State<_AddGroceryItemView> createState() => _AddGroceryItemViewState();
}

class _AddGroceryItemViewState extends State<_AddGroceryItemView> {
  late final AddGroceryItemCubit addGroceryItemCubit;

  @override
  void initState() {
    super.initState();
    addGroceryItemCubit = AddGroceryItemCubit();
  }

  @override
  void dispose() {
    addGroceryItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddGroceryItemCubit, AddGroceryItemState>(
      bloc: addGroceryItemCubit,
      listener: (context, state) {
        if (state is AddGroceryItemSuccess) {
          Navigator.of(context).pop();
          widget.onItemAdded(state.groceryItem);
        }
      },
      builder: (context, state) {
        if (state is AddGroceryItemLoading) {
          return const CircularProgressIndicator();
        } else if (state is AddGroceryItemError) {
          return Text(state.errorMessage);
        } else {
          return AddGroceryItemView(
            onItemAdded: (
              count,
              itemName,
              groceryId,
            ) {
              addGroceryItemCubit.addGroceryItem(
                count,
                itemName,
                groceryId,
              );
            },
            groceryId: widget.groceryId,
          );
        }
      },
    );
  }
}

class _GroceryItemsView extends StatelessWidget {
  const _GroceryItemsView({
    required this.items,
    required this.onFinalized,
    required this.grocery,
    Key? key,
  }) : super(key: key);

  final Grocery grocery;
  final List<GroceryItem> items;
  final VoidCallback onFinalized;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                    child: _FinalizeGroceryView(
                      onFinalized: onFinalized,
                      items: items,
                      grocery: grocery,
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
                        _FinalizeGroceryView(
                          onFinalized: onFinalized,
                          items: items,
                          grocery: grocery,
                        )
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
    );
  }
}
