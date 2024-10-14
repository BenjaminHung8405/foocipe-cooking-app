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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailVerified = false;
  bool _isLoading = false;
  bool _isObscure = true;
  bool _isPasswordTenCharacters = false;
  bool _isPasswordHaveNum = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordTenCharacters = password.length >= 10;
      _isPasswordHaveNum = password.contains(RegExp(r'[0-9]'));
    });
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
          'password': _passwordController.text,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please fill in the form to continue',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF9FA5C0),
                ),
              ),
              const SizedBox(height: 30),
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
              if (_isEmailVerified) ...[
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _otpController,
                  hintText: 'Enter OTP',
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                _buildPasswordRequirements(),
              ],
              const SizedBox(height: 30),
              _buildSubmitButton(),
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
            : suffixIcon,
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

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Password must contain:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF2E3E5C),
          ),
        ),
        const SizedBox(height: 10),
        _buildRequirementRow(
            _isPasswordTenCharacters, 'At least 10 characters'),
        const SizedBox(height: 5),
        _buildRequirementRow(_isPasswordHaveNum, 'Contains a number'),
      ],
    );
  }

  Widget _buildRequirementRow(bool isMet, String requirement) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isMet
                ? const Color(0xFFFD8B51).withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(
              color: isMet ? const Color(0xFFFD8B51) : const Color(0xFF9FA5C0),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: isMet
              ? const Icon(Icons.check, color: Color(0xFFFD8B51), size: 14)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          requirement,
          style: TextStyle(
            color: isMet ? const Color(0xFF2E3E5C) : const Color(0xFF9FA5C0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed:
          _isLoading ? null : (_isEmailVerified ? _register : _verifyEmail),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFD8B51),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              _isEmailVerified ? 'Sign Up' : 'Verify Email',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
    );
  }
}
