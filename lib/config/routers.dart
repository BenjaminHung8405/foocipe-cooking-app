import 'package:flutter/material.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/Recipe/recipe_page.dart';
import '../presentation/pages/Recipe/recipe_management_page.dart';
import '../presentation/pages/SettingPage/setting_page.dart';
import '../presentation/pages/cart_page.dart';
import '../presentation/pages/Recipe/add_recipe_page.dart';
import '../presentation/pages/SettingPage/product_management_page.dart';
import '../presentation/pages/SettingPage/add_product_page.dart';
import '../presentation/pages/SettingPage/order_management_page.dart';
import '../presentation/pages/shop_page.dart';
import '../presentation/pages/product_page.dart';
import '../presentation/pages/SettingPage/account_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const WelcomePage(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/recipe': (context) => const RecipeManagementPage(),
  '/recipe_management': (context) => const RecipeManagementPage(),
  '/setting': (context) => const SettingPage(),
  '/cart': (context) => const CartPage(),
  '/recipe/add': (context) => const AddRecipePage(),
  '/setting/management/product': (context) => const ProductManagementPage(),
  '/setting/add/product': (context) => const AddProductPage(),
  '/setting/management/order': (context) => const OrderManagementPage(),
  '/shop': (context) => const ShopPage(),
  '/setting/account': (context) => const AccountPage()
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
    builder: (_) =>
        const Scaffold(body: Center(child: Text('Route not found'))),
  );
}
