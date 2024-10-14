import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/presentation/pages/home_page.dart';
import 'package:foocipe_cooking_app/presentation/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://foocipe-user-service.onrender.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(
            key: 'access_token', value: data['data']['access_token']);
        await storage.write(
            key: 'refresh_token', value: data['data']['refresh_token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/logos/foocipe-1.png'),
                width: 250,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your account details',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF9FA5C0),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email or phone number',
                prefixIcon: Icons.mail_outline_rounded,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 20),
              const Text(
                'Or continue with',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF9FA5C0),
                ),
              ),
              const SizedBox(height: 20),
              _buildGoogleButton(),
              const SizedBox(height: 20),
              _buildSignUpRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 16),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isPassword
            ? IconButton(
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFFD8B51), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFD8B51),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Login',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white),
            ),
    );
  }

  Widget _buildGoogleButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement Google Sign-In
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/Google.png', height: 24),
          const SizedBox(width: 10),
          const Text(
            'Continue with Google',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF2E3E5C)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF1FCC79)),
          ),
        )
      ],
    );
  }
}
