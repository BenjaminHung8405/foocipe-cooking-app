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
  '/recipe': (context) => const RecipePage(),
};
