import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/ModelLogin.dart';
import 'AdminPageScreen.dart';
import 'ManagerPageScreen.dart';
import 'RegisterScreen.dart';
import 'UserPageScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Авторизация',style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Введите имя',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Введите пароль',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                login(context);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    String name = usernameController.text;
    String password = passwordController.text;

    final url = Uri.parse('http://192.168.0.100:8092/api_users/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {

      ModelLogin modelLogin = ModelLogin.fromJson(json.decode(response.body));

      List roles = modelLogin.roles;
      int userId = modelLogin.id;

      Future<void> saveUserId(int userId) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
      }
      saveUserId(userId);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setInt('id', userId);

      for (String role in roles)
      {
        if (role == 'ROLE_USER')
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.body),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserPageScreen()),
          );
        }
        if (role == 'ROLE_ADMIN') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.body),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPageScreen()),
          );
        }
        if (role == 'ROLE_MANAGER') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Вы успешно авторизировались!"),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManagerPageScreen()),
          );
        }
        // Future<void> saveUserRole(String role) async {
        //   final prefsRole = await SharedPreferences.getInstance();
        //   await prefsRole.setString('role', role);
        // }
        // saveUserRole("ROLE_USER");
      }
    }
    else{
      if(response.statusCode == 204) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Ошибка!'),
                content: Text('У вас нет аккаунта, хотите создать его ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Создать аккаунт'),
                  ),
                ],
              ),
        );
      }
      else{
        if(response.statusCode == 404)
        {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Ошибка!'),
                  content: Text('Ваш аккаунт заблокирован ! Пожалуйста, создайте новый аккаунт.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text('Создать аккаунт'),
                    ),
                  ],
                ),
          );
        }
        else{
          if(response.statusCode == 500)
          {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Ошибка!'),
                content: Text('У Вас есть аккаунт ? Если да, то проверьте правильность введённых данных!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('У меня нет аккаунта, создать'),
                  ),
                ],
              ),
            );
          }
        }
      }
    }
  }
}