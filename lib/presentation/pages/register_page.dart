import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObsure = true;
  bool _isPasswordTenCharacters = false;
  bool _isPasswordHaveNum = false;
  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordTenCharacters = false;
      if (password.length >= 10) _isPasswordTenCharacters = true;

      _isPasswordHaveNum = false;
      if (numericRegex.hasMatch(password)) _isPasswordHaveNum = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _isObsure = true;
    _isPasswordTenCharacters = false;
    _isPasswordHaveNum = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Color(0xFF2E3E5C)),
            ),
            SizedBox(
              height: 10,
            ),
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
                  fontSize: 16,
                  color: Color(0xFF9FA5C0)),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Email or phone number',
                  hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 16),
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
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                onChanged: (password) => onPasswordChanged(password),
                obscureText: _isObsure,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 16),
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
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Your Password must contain:',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF2E3E5C)),
              ),
            ]),
            SizedBox(height: 10),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _isPasswordTenCharacters
                        ? Color(0xFFFD8B51).withOpacity(0.3)
                        : Color(0xFF9FA5C0).withOpacity(0.3),
                    border: _isPasswordTenCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Color(0xFF9FA5C0).withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: _isPasswordTenCharacters
                          ? Color(0xFFFD8B51).withOpacity(0.8)
                          : Color(0xFF9FA5C0).withOpacity(0.3),
                      size: 15,
                    ),
                  ),
                ),
              ),
              Text(
                'Atleast 10 characters',
                style: TextStyle(
                    color: _isPasswordTenCharacters
                        ? Color(0xFF2E3E5C)
                        : Color(0xFF9FA5C0).withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ]),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _isPasswordHaveNum
                        ? Color(0xFFFD8B51).withOpacity(0.3)
                        : Color(0xFF9FA5C0).withOpacity(0.3),
                    border: _isPasswordHaveNum
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Color(0xFF9FA5C0).withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: _isPasswordHaveNum
                          ? Color(0xFFFD8B51).withOpacity(0.8)
                          : Color(0xFF9FA5C0).withOpacity(0.3),
                      size: 15,
                    ),
                  ),
                ),
              ),
              Text(
                'Contains a number',
                style: TextStyle(
                    color: _isPasswordHaveNum
                        ? Color(0xFF2E3E5C)
                        : Color(0xFF9FA5C0).withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ]),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFD8B51),
                    minimumSize: Size(327, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))))
          ],
        ),
      ),
    );
  }
}
