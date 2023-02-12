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

  Future<void> fetchCurrentGrocery() async {
    emit(CurrentGroceryListLoading());
    final queryPredicate = Grocery.FINALIZATIONDATE.eq(null);

    final groceryRequest =
        ModelQueries.list<Grocery>(Grocery.classType, where: queryPredicate);

    final groceryResponse =
        await Amplify.API.query(request: groceryRequest).response;

    final grocery = groceryResponse.data?.items.whereNotNull().firstOrNull;
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

      emit(
        CurrentGroceryListSuccess(
          grocery.copyWith(
            groceryItems: fetchedItems,
          ),
        ),
      );
    } else {
      final grocery = Grocery(groceryItems: const <GroceryItem>[]);
      final request = ModelMutations.create(grocery);
      await runMutation(request, (error) {
        emit(
          CurrentGroceryListError(
            'The creation has failed. Try it again or check the errors: $error',
          ),
        );
      });
      emit(
        CurrentGroceryListSuccess(grocery),
      );
    }
  }

  void signUserOut() {
    Amplify.Auth.signOut();
  }
}
