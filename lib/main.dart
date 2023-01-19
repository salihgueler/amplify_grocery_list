import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_grocery_list/grocery_list/current_grocery/current_grocery_list_page.dart';
import 'package:amplify_grocery_list/models/ModelProvider.dart';
import 'package:amplify_grocery_list/utils/color_schemes.g.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/amplifyconfiguration.dart';
import 'package:google_fonts/google_fonts.dart';

/// Why the state change is not shown
/// Twice grocery list creation issue
/// Dispose the finalizeGroceryViewCubit
/// Do a full UI revamp
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class AmplifyGroceryListApp extends StatelessWidget {
  const AmplifyGroceryListApp({Key? key}) : super(key: key);

  ThemeData _buildTheme(Brightness brightness, ColorScheme colorScheme) {
    var baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.ralewayTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light, lightColorScheme),
        darkTheme: _buildTheme(Brightness.dark, darkColorScheme),
        builder: Authenticator.builder(),
        home: const CurrentGroceryListPage(),
      ),
    );
  }
}
