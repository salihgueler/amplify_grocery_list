part of 'finalize_grocery_view_cubit.dart';

abstract class FinalizeGroceryViewState extends Equatable {}

class FinalizeGroceryViewInitial extends FinalizeGroceryViewState {
  @override
  List<Object?> get props => [];
}

class FinalizeGroceryViewLoading extends FinalizeGroceryViewState {
  @override
  List<Object?> get props => [];
}

class FinalizeGroceryViewError extends FinalizeGroceryViewState {
  FinalizeGroceryViewError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class FinalizeGroceryViewSuccess extends FinalizeGroceryViewState {
  FinalizeGroceryViewSuccess(this.grocery);

  final Grocery grocery;

  @override
  List<Object?> get props => [grocery];
}
