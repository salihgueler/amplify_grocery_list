part of 'previous_groceries_cubit.dart';

abstract class PreviousGroceriesState extends Equatable {}

class PreviousGroceriesInitial extends PreviousGroceriesState {
  @override
  List<Object?> get props => [];
}

class PreviousGroceriesLoading extends PreviousGroceriesState {
  @override
  List<Object?> get props => [];
}

class PreviousGroceriesError extends PreviousGroceriesState {
  PreviousGroceriesError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class PreviousGroceriesSuccess extends PreviousGroceriesState {
  PreviousGroceriesSuccess(this.groceries);

  final List<Grocery> groceries;

  @override
  List<Object?> get props => [groceries];
}
