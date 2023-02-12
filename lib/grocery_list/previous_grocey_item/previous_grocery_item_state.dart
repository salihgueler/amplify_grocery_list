part of 'previous_grocery_item_cubit.dart';

abstract class PreviousGroceryDetailsState extends Equatable {}

class PreviousGroceryDetailsInitial extends PreviousGroceryDetailsState {
  @override
  List<Object?> get props => [];
}

class PreviousGroceryDetailsLoading extends PreviousGroceryDetailsState {
  @override
  List<Object?> get props => [];
}

class PreviousGroceryDetailsError extends PreviousGroceryDetailsState {
  PreviousGroceryDetailsError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class PreviousGroceryDetailsSuccess extends PreviousGroceryDetailsState {
  PreviousGroceryDetailsSuccess(this.fileUrl);

  final String fileUrl;

  @override
  List<Object?> get props => [fileUrl];
}
