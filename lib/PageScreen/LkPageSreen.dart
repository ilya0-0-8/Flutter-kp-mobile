import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../Models/ModelUser.dart';
import 'HomeScreen.dart';
import 'UserPageScreen.dart';

class LkPageScreen extends StatefulWidget {
  @override
  _LkPageScreenState createState() => _LkPageScreenState();
}

class _LkPageScreenState extends State<LkPageScreen> {

  ModelUser? user;
  final picker = ImagePicker();
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    fingByUser();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> displayAvatar() async {
    int? userId = await getUserId();
    var response = await http.get(
        Uri.parse('http://192.168.0.100:8092/api_users/user/$userId/getAvatar'));
    if (response.statusCode == 200) {
      setState(() {
        avatarUrl = response.body;
      });
    } else {
      // Handle error
    }
  }

  // Future<void> uploadImage() async {
  //   int? userId = await getUserId();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     var request = http.MultipartRequest('PUT', Uri.parse('http://172.20.10.3:8092/api_users/user/$userId/avatar'));
  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     var response = await request.send();
  //     if (response.statusCode == 200)
  //     {
  //
  //     } else {
  //       // Handle error
  //     }
  //     displayAvatar();
  //   }
  // }
  // Future<String?> getUserRole() async {
  //   final prefsRole = await SharedPreferences.getInstance();
  //   return prefsRole.getString('role');
  // }

  Future<void> fingByUser() async
  {
    int? userId = await getUserId();
    final response = await http.get(
        Uri.parse('http://192.168.0.100:8092/api_users/user/$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        user = ModelUser.fromJson(jsonData);
      });
    }
    else {
      throw Exception('Ошибка загрузки пользователя!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Профиль',style: TextStyle(color: Colors.black)),
        leading: user != null && user!.roles.contains("ROLE_USER")
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPageScreen()),);
          },
        )
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Личный идентификатор: ${user?.id}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Имя: ${user?.name}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${user?.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Номер телефона: ${user?.numberPhone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Активность: ${user?.active}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Роль: ${user?.roles}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                onPrimary: Colors.black,
                fixedSize: Size(200, 35),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}