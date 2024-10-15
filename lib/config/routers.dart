import 'package:flutter/material.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/recipe_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const WelcomePage(),
  '/home': (context) => HomePage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
};

// Add this function to handle dynamic routes
Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name?.startsWith('/recipe/') ?? false) {
    final recipeId = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => RecipePage(recipeId: recipeId),
      settings: settings,
    );
  }

  // If no match is found, you can return a default route or throw an error
  return MaterialPageRoute(
    builder: (_) => Scaffold(body: Center(child: Text('Route not found'))),
  );
}
