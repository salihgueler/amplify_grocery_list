import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'previous_grocery_item_state.dart';

class PreviousGroceryDetailsCubit extends Cubit<PreviousGroceryDetailsState> {
  PreviousGroceryDetailsCubit() : super(PreviousGroceryDetailsInitial());

  Future<void> getDownloadUrl({
    required String key,
  }) async {
    try {
      emit(PreviousGroceryDetailsLoading());
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
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
