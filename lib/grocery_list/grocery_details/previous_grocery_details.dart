import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/grocery_list/grocery_details/previous_grocery_details_cubit.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousGroceryDetailsPage extends StatelessWidget {
  const PreviousGroceryDetailsPage({
    required this.item,
    Key? key,
  }) : super(key: key);

  final Grocery item;

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
            child: Text('File saved at: ${item.fileKey}'),
          ),
          _InvoiceView(fileKey: item.fileKey!),
          ...item.groceryItems
                  ?.map(
                    (groceryItem) => ListTile(
                      title: Text(groceryItem.name),
                      subtitle:
                          Text('You bought ${groceryItem.count} of these'),
                    ),
                  )
                  .toList(growable: false) ??
              <Widget>[]
        ],
      ),
    );
  }
}

class _InvoiceView extends StatefulWidget {
  const _InvoiceView({
    required this.fileKey,
    Key? key,
  }) : super(key: key);

  final String fileKey;

  @override
  State<_InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<_InvoiceView> {
  late final previousGroceryDetailsCubit = PreviousGroceryDetailsCubit();

  @override
  void initState() {
    super.initState();
    previousGroceryDetailsCubit.getDownloadUrl(
      key: widget.fileKey,
      accessLevel: StorageAccessLevel.guest,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreviousGroceryDetailsCubit, PreviousGroceryDetailsState>(
      bloc: previousGroceryDetailsCubit,
      builder: (context, state) {
        if (state is PreviousGroceryDetailsSuccess) {
          return Image.network(state.fileUrl);
        } else if (state is PreviousGroceryDetailsError) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
