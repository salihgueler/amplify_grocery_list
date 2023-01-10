import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_grocery_list/grocery_list/current_grocery_list_page.dart';
import 'package:amplify_grocery_list/models/ModelProvider.dart';
import 'package:amplify_grocery_list/utils/theme.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/amplifyconfiguration.dart';

Future<void> main() async {
  // (2) Bind widgets before Amplify is configured
  WidgetsFlutterBinding.ensureInitialized();
  // (3) Wait for Amplify to be configured before you run the app.
  await _configureAmplify();
  runApp(const AmplifyGroceryListApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(modelProvider: ModelProvider.instance),
      AmplifyStorageS3(),
    ]);

    await Amplify.configure(amplifyconfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

// TODO(5): Add GraphQL API

class AmplifyGroceryListApp extends StatelessWidget {
  const AmplifyGroceryListApp({Key? key}) : super(key: key);

  // TODO(3): Initialize Amplify and Add Authentication
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: customLightTheme,
        darkTheme: customDarkTheme,
        builder: Authenticator.builder(),
        home: const CurrentGroceryListPage(),
      ),
    );
  }
}
