import 'package:flutter/foundation.dart';

bool isMobile() =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

// TODO(8): Uncomment this to run mutations (part of other TODO(8)).
// Import this for function to work.
// import 'package:amplify_flutter/amplify_flutter.dart';
// // This method runs the mutations for the API category and handles the errors properly.
// Future<T?> runMutation<T>(
//   GraphQLRequest<T> request,
//   ValueSetter<String> onError,
// ) async {
//   try {
//     final response = await Amplify.API.mutate(request: request).response;
//     final item = response.data;
//     final errors = response.errors;
//     if (errors.isNotEmpty) {
//       throw Exception(errors);
//     }
//     if (item == null) {
//       throw Exception('Received null item');
//     }
//     return item;
//   } on Exception catch (e) {
//     onError('Error: $e');
//     return null;
//   }
// }
