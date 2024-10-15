import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foocipe_cooking_app/presentation/pages/login_page.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  bool _isEmailVerified = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(
            'https://foocipe-user-service.onrender.com/auth/email-verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
        }),
      );
      if (response.statusCode == 200) {
        setState(() => _isEmailVerified = true);
      } else {
        _showErrorSnackBar('Failed to verify email. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again later.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(
            'https://foocipe-user-service.onrender.com/auth/register-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'otp': _otpController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _showErrorSnackBar('Registration failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again later.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please fill in the form to continue',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color(0xFF9FA5C0),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.mail_outline_rounded,
                suffixIcon: _isEmailVerified
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isLoading ? null : _verifyEmail,
                      ),
              ),
              const SizedBox(height: 12),
              if (_isEmailVerified) ...[
                _buildTextField(
                  controller: _otpController,
                  hintText: 'Enter OTP',
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
              ],
              const SizedBox(height: 24),
              _buildRegisterButton(),
              const SizedBox(height: 24),
              const Text(
                'Or sign up with',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF9FA5C0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildSocialSignupButtons(),
              const SizedBox(height: 16),
              _buildSignInRow(),
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
    Widget? suffixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _isObscure,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xffDDDADA),
            fontSize: 25,
            fontWeight: FontWeight.w500),
        prefixIcon: Icon(prefixIcon, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                    size: 20),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : suffixIcon,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFD8B51), width: 2.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed:
          _isLoading ? null : (_isEmailVerified ? _register : _verifyEmail),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFD8B51),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : Text(
              _isEmailVerified ? 'Sign Up' : 'Verify Email',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
    );
  }

  Widget _buildSocialSignupButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('Google', 'assets/icons/google-logo.png'),
        const SizedBox(width: 8),
        _buildSocialButton('Facebook', 'assets/icons/facebook-logo.png'),
        const SizedBox(width: 8),
        _buildSocialButton('GitHub', 'assets/icons/github-logo.png'),
      ],
    );
  }

  Widget _buildSocialButton(String text, String iconPath) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 20),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFF9FA5C0),
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Sign In',
            style: TextStyle(fontSize: 25, color: Color(0xFFFD8B51)),
          ),
        )
      ],
    );
  }
}
