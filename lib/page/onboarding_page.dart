import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'login_screen.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: '¡Bienvenido a Chatty!',
              bodyWidget: Column(
                children: [
                  Text(
                    'Conéctate y chatea con personas de todo el mundo',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.chat,
                    size: 150,
                    color: Colors.blue,
                  ),
                ],
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Explora el mundo de los chats',
              bodyWidget: Column(
                children: [
                  Text(
                    'Haz nuevos amigos y descubre nuevas experiencias',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.explore,
                    size: 150,
                    color: Colors.orange,
                  ),
                ],
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Conversaciones seguras y privadas',
              bodyWidget: Column(
                children: [
                  Text(
                    'Mantén tus chats protegidos con encriptación de extremo a extremo',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.security,
                    size: 150,
                    color: Colors.green,
                  ),
                ],
              ),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text(
            'Comenzar',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          onDone: () => goToLoginScreen(context),
          showSkipButton: true,
          skip: Text(
            'Saltar',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          onSkip: () => goToLoginScreen(context),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Página $index seleccionada'),
          globalBackgroundColor: Theme.of(context).primaryColor,
        ),
      );

  void goToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  void goToOnBoarding(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnBoardingPage()),
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(fontSize: 20),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
