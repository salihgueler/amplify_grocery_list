import 'package:amplify_grocery_list/grocery_list/previous_grocey_item/previous_grocery_item_cubit.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousGroceryItem extends StatelessWidget {
  const PreviousGroceryItem({
    required this.item,
    Key? key,
  }) : super(key: key);

  final Grocery item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _InvoiceView(fileKey: item.fileKey!),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title!,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    'Spent: \$${item.totalAmount}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    item.finalizationDate.toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                  // ...item.groceryItems
                  //         ?.map(
                  //           (groceryItem) => ListTile(
                  //             title: Text(groceryItem.name),
                  //             subtitle:
                  //                 Text('You bought ${groceryItem.count} of these'),
                  //           ),
                  //         )
                  //         .toList(growable: false) ??
                  //     <Widget>[]
                ],
              ),
            ),
          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100,
      child:
          BlocBuilder<PreviousGroceryDetailsCubit, PreviousGroceryDetailsState>(
        bloc: previousGroceryDetailsCubit,
        builder: (context, state) {
          if (state is PreviousGroceryDetailsSuccess) {
            return CachedNetworkImage(
              imageUrl: state.fileUrl,
              imageBuilder: (context, imageProvider) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      state.fileUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          } else if (state is PreviousGroceryDetailsError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
