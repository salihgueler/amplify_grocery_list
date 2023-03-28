import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_cubit.dart';
import 'package:amplify_grocery_list/add_grocery_item/add_grocery_item_page.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_page.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/current_grocery/current_grocery_list_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/previous_grocery_list/previous_groceries_page.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
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
    currentGroceryCubit.subscribeToCurrentGrocery();
  }

  // @override
  // void dispose() {
  //   currentGroceryCubit.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGroceryListCubit, CurrentGroceryListState>(
      bloc: currentGroceryCubit,
      builder: (context, state) {
        // if (state is CurrentGroceryListSuccess) {
        // final grocery = state.currentGrocery;
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
          floatingActionButton: (state is CurrentGroceryListSuccess)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return _AddGroceryItemView(
                            onItemAdded: (groceryItem) {},
                            groceryId: state.currentGrocery.id,
                          );
                        },
                      ),
                    );
                  },
                  label: const Text('Add Item'),
                )
              : null,
          body: (state is CurrentGroceryListSuccess)
              ? state.currentGrocery.groceryItems == null ||
                      state.currentGrocery.groceryItems!.isEmpty
                  ? const Center(
                      child: Text('No current groceries'),
                    )
                  : _GroceryItemsView(
                      items: state.currentGrocery.groceryItems!,
                      grocery: state.currentGrocery,
                      onFinalized: () {},
                    )
              : (state is CurrentGroceryListError)
                  ? Center(child: Text(state.errorMessage))
                  : const Center(child: CircularProgressIndicator()),
        );
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinalizeGroceryCubit, FinalizeGroceryState>(
      listener: (context, state) {
        if (state is FinalizeGrocerySuccess) {
          Navigator.of(context).pop();
          widget.onFinalized();
        }
      },
      builder: (context, state) {
        return FinalizeGroceryPage(
          items: List.from(widget.items),
          currentGroceryId: widget.grocery.id,
          isLoading: state is FinalizeGroceryLoading,
          uploadPercentage: (state is FinalizeGroceryFileUploadState)
              ? state.percentage
              : null,
          errorMessage:
              (state is FinalizeGroceryError) ? state.errorMessage : null,
          onFinalized: (
            totalAmount,
            title,
            id,
            finalizationDate,
            filePath,
          ) {
            context.read<FinalizeGroceryCubit>().finalizeGrocery(
                  filePath,
                  id,
                  title,
                  totalAmount,
                  widget.grocery,
                );
          },
        );
        // }
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
        if (state is AddGroceryItemError) {
          return Text(state.errorMessage);
        } else {
          return AddGroceryItemPage(
            isLoading: (state is AddGroceryItemLoading),
            onItemAdded: (
              count,
              amount,
              itemName,
              groceryId,
            ) {
              addGroceryItemCubit.addGroceryItem(
                count,
                amount,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return _FinalizeGroceryView(
                      onFinalized: onFinalized,
                      items: items,
                      grocery: grocery,
                    );
                  },
                ),
              );
            },
            child: const Text('End shopping'),
          );
        } else {
          final item = items[index];
          return ListTile(
            onTap: () {},
            title: Text(
              item.name,
            ),
            subtitle: Text(
                'You bought ${item.count} of these, each costing ${item.amount} and should overall cost \$${item.count * item.amount}'),
          );
        }
      },
    );
  }
}
