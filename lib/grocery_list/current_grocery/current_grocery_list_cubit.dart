import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

part 'current_grocery_list_state.dart';

class CurrentGroceryListCubit extends Cubit<CurrentGroceryListState> {
  CurrentGroceryListCubit() : super(CurrentGroceryListInitial());

  void subscribeToCurrentGrocery() {
    final subscriptionRequest = ModelSubscriptions.onCreate(
      Grocery.classType,
      // where: Grocery.FINALIZATIONDATE.ne(null),
    );

    emit(
      CurrentGroceryListSuccess(
        Grocery(groceryItems: const <GroceryItem>[]),
      ),
    );

    final operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () {
        safePrint('Subscription established');
      },
    );

    try {
      operation.listen((event) {
        safePrint('Subscription event data received: ${event.data}');
      });
    } on Exception catch (e) {
      safePrint('Error in subscription stream: $e');
    }
  }
  // Future<void> fetchCurrentGrocery() async {
  //   emit(CurrentGroceryListLoading());
  //   // FIXME: Fix this with the predicate fix.
  //   // final queryPredicate = Grocery.FINALIZATIONDATE.eq(null);
  //   // final groceryRequest =
  //   //     ModelQueries.list<Grocery>(Grocery.classType, where: queryPredicate);
  //   final groceryRequest = ModelQueries.list<Grocery>(Grocery.classType);
  //   final groceryResponse = await runMutation(groceryRequest, (error) {
  //     emit(CurrentGroceryListError(error));
  //   });

  //   final grocery = groceryResponse?.items
  //       .whereNotNull()
  //       // FIXME: Remove this with the predicate fix.
  //       .where((item) => item.finalizationDate == null)
  //       .firstOrNull;
  //   if (grocery != null) {
  //     final id = grocery.id;
  //     final queryPredicate = GroceryItem.GROCERYID.eq(id);
  //     final groceryItemRequest = ModelQueries.list<GroceryItem>(
  //       GroceryItem.classType,
  //       where: queryPredicate,
  //     );
  //     final groceryItemResponse = await runMutation(
  //       groceryItemRequest,
  //       (error) {
  //         emit(CurrentGroceryListError(error));
  //       },
  //     );
  //     final fetchedItems =
  //         groceryItemResponse?.items.whereNotNull().toList(growable: false);

  //     emit(
  //       CurrentGroceryListSuccess(
  //         grocery.copyWith(
  //           groceryItems: fetchedItems,
  //         ),
  //       ),
  //     );
  //   } else {
  //     final grocery = Grocery(groceryItems: const <GroceryItem>[]);
  //     final request = ModelMutations.create(grocery);
  //     await runMutation(request, (error) {
  //       emit(
  //         CurrentGroceryListError(
  //           'The creation has failed. Try it again or check the errors: $error',
  //         ),
  //       );
  //     });
  //     emit(
  //       CurrentGroceryListSuccess(grocery),
  //     );
  //   }
  // }

  void signUserOut() {
    Amplify.Auth.signOut();
  }
}
