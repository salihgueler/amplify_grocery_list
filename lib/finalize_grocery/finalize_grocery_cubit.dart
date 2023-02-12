import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'finalize_grocery_state.dart';

class FinalizeGroceryCubit extends Cubit<FinalizeGroceryState> {
  FinalizeGroceryCubit() : super(FinalizeGroceryInitial());

  Future<void> finalizeGrocery(
    String filePath,
    String id,
    String title,
    double totalAmount,
    Grocery currentGrocery,
  ) async {
    emit(FinalizeGroceryLoading());
    await Amplify.Storage.uploadFile(
      localFile: AWSFile.fromPath(
        filePath,
      ),
      key: id,
      onProgress: (progress) {
        emit(
          FinalizeGroceryFileUploadState(progress.fractionCompleted),
        );
      },
    ).result;

    emit(FinalizeGroceryLoading());

    final newGrocery = currentGrocery.copyWith(
      totalAmount: totalAmount,
      fileKey: id,
      finalizationDate: TemporalDate(DateTime.now()),
      title: title,
    );

    final request = ModelMutations.update(newGrocery);
    await runMutation(request, (error) {
      emit(FinalizeGroceryError(error));
    });
    emit(FinalizeGrocerySuccess(newGrocery));
  }
}
