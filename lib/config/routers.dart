import 'package:flutter/material.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/recipe_page.dart';
import '../presentation/pages/product_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const WelcomePage(),
  '/home': (context) => HomePage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name?.startsWith('/recipe/') ?? false) {
    final recipeId = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => RecipePage(recipeId: recipeId),
      settings: settings,
    );
  }

  if (settings.name?.startsWith('/product/') ?? false) {
    final productId = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => ProductPage(productId: productId),
      settings: settings,
    );
  }

  return MaterialPageRoute(
    builder: (_) => Scaffold(body: Center(child: Text('Route not found'))),
  );
}
