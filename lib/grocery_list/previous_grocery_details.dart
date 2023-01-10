import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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
          FutureBuilder<String>(
            future: getDownloadUrl(
              key: item.fileKey!,
              accessLevel: StorageAccessLevel.guest,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Image.network(snapshot.data!);
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<GroceryItem>>(
              future: fetchCurrentGroceryItem(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final groceryItem = comments[index];
                      return ListTile(
                        title: Text(groceryItem.name),
                        subtitle:
                        Text('You bought ${groceryItem.count} of these'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getDownloadUrl({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: S3GetUrlOptions(
          accessLevel: accessLevel,
          checkObjectExistence: true,
          expiresIn: const Duration(hours: 1),
        ),
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint(e.message);
      rethrow;
    }
  }

  Future<List<GroceryItem>> fetchCurrentGroceryItem() async {
    final queryPredicate = GroceryItem.GROCERYID.eq(item.id);
    final groceryItemRequest = ModelQueries.list<GroceryItem>(
      GroceryItem.classType,
      where: queryPredicate,
    );
    final groceryItemResponse =
        await Amplify.API.query(request: groceryItemRequest).response;
    return groceryItemResponse.data?.items
            .whereNotNull()
            .toList(growable: false) ??
        <GroceryItem>[];
  }
}
