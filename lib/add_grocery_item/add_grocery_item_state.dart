part of 'add_grocery_item_cubit.dart';

abstract class AddGroceryItemState extends Equatable {}

class AddGroceryItemInitial extends AddGroceryItemState {
  @override
  List<Object?> get props => [];
}

class AddGroceryItemLoading extends AddGroceryItemState {
  @override
  List<Object?> get props => [];
}

class AddGroceryItemSuccess extends AddGroceryItemState {
  AddGroceryItemSuccess(this.groceryItem);

  final GroceryItem groceryItem;

  @override
  List<Object?> get props => [groceryItem];
}

class AddGroceryItemError extends AddGroceryItemState {
  AddGroceryItemError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
