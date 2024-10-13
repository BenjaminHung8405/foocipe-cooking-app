import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/presentation/pages/home_page.dart';
import 'package:foocipe_cooking_app/presentation/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObsure = true;

  @override
  void initState() {
    super.initState();
    _isObsure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/logos/foocipe-1.png'),
              width: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Please enter your account here',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF9FA5C0)),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 30,
              ),
              child: SizedBox(
                height: 56,
                width: 327,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Email or phone number',
                    hintStyle:
                        const TextStyle(color: Color(0xffDDDADA), fontSize: 16),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.mail_outline_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 56,
                width: 327,
                child: TextField(
                  obscureText: _isObsure,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Password',
                    hintStyle:
                        const TextStyle(color: Color(0xffDDDADA), fontSize: 16),
                    suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        onPressed: () {
                          setState(() {
                            _isObsure = !_isObsure;
                          });
                        },
                        icon: _isObsure
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.lock_outline_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD8B51),
                    minimumSize: const Size(327, 62),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Or continue with',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF9FA5C0)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 30, right: 30),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5842),
                      fixedSize: const Size(327, 62),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/icons/Google.png'),
                      ),
                      Text(
                        'Google',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have any account?',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF2E3E5C)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ));
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF1FCC79)),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
