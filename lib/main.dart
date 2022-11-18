import 'package:amplify_grocery_list/grocery_list/current_grocery_list_page.dart';
import 'package:amplify_grocery_list/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  // TODO(2): Initialize Amplify and Add Authentication
  runApp(const AmplifyGroceryListApp());
}

// TODO(5): Add GraphQL API

class AmplifyGroceryListApp extends StatelessWidget {
  const AmplifyGroceryListApp({Key? key}) : super(key: key);

  // TODO(3): Initialize Amplify and Add Authentication
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customLightTheme,
      darkTheme: customDarkTheme,
      home: const CurrentGroceryListPage(),
    );
  }
}
