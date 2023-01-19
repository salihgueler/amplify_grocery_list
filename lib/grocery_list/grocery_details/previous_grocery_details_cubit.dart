import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'previous_grocery_details_state.dart';

class PreviousGroceryDetailsCubit extends Cubit<PreviousGroceryDetailsState> {
  PreviousGroceryDetailsCubit() : super(PreviousGroceryDetailsInitial());

  Future<void> getDownloadUrl({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      emit(PreviousGroceryDetailsLoading());
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: S3GetUrlOptions(
          accessLevel: accessLevel,
          checkObjectExistence: true,
          expiresIn: const Duration(hours: 1),
        ),
      ).result;
      emit(PreviousGroceryDetailsSuccess(result.url.toString()));
    } on StorageException catch (e) {
      safePrint(e.message);
      emit(PreviousGroceryDetailsError(e.message));
      rethrow;
    }
  }
}
