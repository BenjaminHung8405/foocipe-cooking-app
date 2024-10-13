import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkCredentials();
    });
  }

  Future<void> checkCredentials() async {
    try {
      final accessToken = await storage.read(key: 'accessToken');
      final userId = await storage.read(key: 'user_id');

      if (accessToken != null && userId != null) {
        // Both accessToken and user_id exist, navigate to home page
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Either accessToken or user_id is missing, navigate to login page
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      // If there's an error reading from storage, navigate to login page
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome_background-3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/foocipe-1.png',
                  width: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
