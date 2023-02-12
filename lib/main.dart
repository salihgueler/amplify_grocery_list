import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_grocery_list/finalize_grocery/finalize_grocery_cubit.dart';
import 'package:amplify_grocery_list/grocery_list/current_grocery/current_grocery_list_page.dart';
import 'package:amplify_grocery_list/models/ModelProvider.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_grocery_list/amplifyconfiguration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FinalizeGroceryCubit>(
            create: (context) => FinalizeGroceryCubit(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(
            scheme: FlexScheme.amber,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 9,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.amber,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 15,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
          themeMode: ThemeMode.system,
          builder: Authenticator.builder(),
          home: const CurrentGroceryListPage(),
        ),
      ),
    );
  }
}
