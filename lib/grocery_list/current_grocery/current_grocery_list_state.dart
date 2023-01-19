part of 'current_grocery_list_cubit.dart';

abstract class CurrentGroceryListState extends Equatable {}

class CurrentGroceryListInitial extends CurrentGroceryListState {
  @override
  List<Object?> get props => [];
}

class CurrentGroceryListLoading extends CurrentGroceryListState {
  @override
  List<Object?> get props => [];
}

class CurrentGroceryListError extends CurrentGroceryListState {
  CurrentGroceryListError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class CurrentGroceryListSuccess extends CurrentGroceryListState {
  CurrentGroceryListSuccess(this.currentGrocery);

  final Grocery currentGrocery;

  @override
  List<Object?> get props => [currentGrocery];

}