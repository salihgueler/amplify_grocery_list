import 'package:amplify_grocery_list/grocery_list/previous_grocery_list/previous_groceries_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/previous_grocey_item/previous_grocery_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousGroceriesPage extends StatefulWidget {
  const PreviousGroceriesPage({Key? key}) : super(key: key);

  @override
  State<PreviousGroceriesPage> createState() => _PreviousGroceriesPageState();
}

class _PreviousGroceriesPageState extends State<PreviousGroceriesPage> {
  late final previousGroceriesCubit = PreviousGroceriesCubit();

  @override
  void initState() {
    super.initState();
    previousGroceriesCubit.fetchPreviousGroceries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Groceries'),
      ),
      body: BlocBuilder<PreviousGroceriesCubit, PreviousGroceriesState>(
        bloc: previousGroceriesCubit,
        builder: (context, state) {
          if (state is PreviousGroceriesSuccess) {
            final previousGroceries = state.groceries;
            if (previousGroceries.isEmpty) {
              return const Center(
                child: Text('No previous groceries in the list yet'),
              );
            } else {
              return ListView.builder(
                itemCount: previousGroceries.length,
                itemBuilder: (context, index) {
                  final item = previousGroceries[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PreviousGroceryItem(item: item),
                  );
                },
              );
            }
          } else if (state is PreviousGroceriesError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
