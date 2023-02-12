part of 'finalize_grocery_cubit.dart';

abstract class FinalizeGroceryState extends Equatable {}

class FinalizeGroceryFileUploadState extends FinalizeGroceryState {
  FinalizeGroceryFileUploadState(this.percentage);

  final double percentage;

  @override
  List<Object?> get props => [percentage];
}

class FinalizeGroceryInitial extends FinalizeGroceryState {
  @override
  List<Object?> get props => [];
}

class FinalizeGroceryLoading extends FinalizeGroceryState {
  @override
  List<Object?> get props => [];
}

class FinalizeGroceryError extends FinalizeGroceryState {
  FinalizeGroceryError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class FinalizeGrocerySuccess extends FinalizeGroceryState {
  FinalizeGrocerySuccess(this.grocery);

  final Grocery grocery;

  @override
  List<Object?> get props => [grocery];
}
