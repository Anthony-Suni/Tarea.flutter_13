import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/chat_screen.dart';
import 'package:flutter_application_1/page/onboarding_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/onboarding', // Cambia la ruta inicial a '/onboarding'
      routes: {
        '/onboarding': (context) =>
            OnBoardingPage(), // Agrega la ruta '/onboarding' para OnBoardingPage
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
