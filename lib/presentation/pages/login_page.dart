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
            Image(
              image: AssetImage('assets/logos/foocipe-1.png'),
              width: 250,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please enter your account here',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF9FA5C0)),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: SizedBox(
                height: 56,
                width: 327,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Email or phone number',
                    hintStyle:
                        TextStyle(color: Color(0xffDDDADA), fontSize: 16),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.mail_outline_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 56,
                width: 327,
                child: TextField(
                  obscureText: _isObsure,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Password',
                    hintStyle:
                        TextStyle(color: Color(0xffDDDADA), fontSize: 16),
                    suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        onPressed: () {
                          setState(() {
                            _isObsure = !_isObsure;
                          });
                        },
                        icon: _isObsure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.lock_outline_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFD8B51),
                    minimumSize: Size(327, 62),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
            SizedBox(
              height: 20,
            ),
            Text(
              'Or continue with',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF9FA5C0)),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
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
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5842),
                      fixedSize: Size(327, 62),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
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
                            builder: (context) => RegisterPage(),
                          ));
                    },
                    child: Text(
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
