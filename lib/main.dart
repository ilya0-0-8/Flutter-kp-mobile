import 'package:flutter/material.dart';
import 'package:kp/PageScreen/CreateProductScreen.dart';

import 'PageScreen/AdminPageScreen.dart';
import 'PageScreen/HomeScreen.dart';
import 'PageScreen/LkPageSreen.dart';
import 'PageScreen/LoginScreen.dart';

import 'PageScreen/ManagerPageScreen.dart';
import 'PageScreen/RegisterScreen.dart';
import 'PageScreen/UserPageScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин музыкального оборуудования',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin_page': (context) => AdminPageScreen(),
        '/moder_page': (context) => ManagerPageScreen(),
        '/user_page': (context) => UserPageScreen(),
        '/LkPageScreen': (context) => LkPageScreen(),
        '/CreateProductScreen': (context) => CreateProductScreen(),
      },
    );
  }
}