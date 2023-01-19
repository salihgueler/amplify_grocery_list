import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_grocery_item_state.dart';

class AddGroceryItemCubit extends Cubit<AddGroceryItemState> {
  AddGroceryItemCubit() : super(AddGroceryItemInitial());

  Future<void> addGroceryItem(
    int count,
    String itemName,
    String groceryId,
  ) async {
    emit(AddGroceryItemLoading());
    final item = GroceryItem(
      count: count,
      name: itemName,
      isBought: false,
      groceryID: groceryId,
    );
    final mutation = ModelMutations.create(item);
    final result = await runMutation(mutation, (error) {
      emit(AddGroceryItemError(error));
    });
    if (result != null) {
      emit(AddGroceryItemSuccess(result));
    }
  }
}
