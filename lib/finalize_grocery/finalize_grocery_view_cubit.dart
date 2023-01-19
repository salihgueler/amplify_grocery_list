import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'finalize_grocery_view_state.dart';

class FinalizeGroceryViewCubit extends Cubit<FinalizeGroceryViewState> {
  FinalizeGroceryViewCubit() : super(FinalizeGroceryViewInitial());

  Future<void> finalizeGrocery(
    String filePath,
    String id,
    String title,
    double totalAmount,
    Grocery currentGrocery,
  ) async {
    emit(FinalizeGroceryViewLoading());
    await Amplify.Storage.uploadFile(
      localFile: AWSFile.fromPath(
        filePath,
      ),
      key: id,
      onProgress: (progress) {
        safePrint(
          'Fraction completed: ${progress.fractionCompleted}',
        );
      },
    ).result;
    final newGrocery = currentGrocery.copyWith(
      totalAmount: totalAmount,
      fileKey: id,
      finalizationDate: TemporalDate(DateTime.now()),
      title: title,
    );

    final request = ModelMutations.update(newGrocery);
    await runMutation(request, (error) {
      emit(FinalizeGroceryViewError(error));
    });
    emit(FinalizeGroceryViewSuccess(newGrocery));
  }
}
