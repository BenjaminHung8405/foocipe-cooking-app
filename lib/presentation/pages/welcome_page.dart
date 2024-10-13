import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/presentation/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Image(
                image: AssetImage('assets/images/onboarding.png'),
            ),
            SizedBox(height: 30),
            Text(
              'Start Cooking',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: Color(0xFF2E3E5C),
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70, right: 70, top: 20),
              child: Text(
                'Let’s join our community to cook better food!',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Color(0xFF9FA5C0)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70),
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()
                      )
                    );
                  },
                child: Text(
                    'Get Started',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFD8B51),
                  minimumSize: Size(327, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                )
              ),
            )
          ],
        ),
      );
  }
}
