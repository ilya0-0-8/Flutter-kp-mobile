import 'package:flutter/material.dart';
import 'package:kp/Models/ModelProduct.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/ModelUser.dart';
import 'LkPageSreen.dart';
import 'MyCartScreen.dart';

class UserPageSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: UserPageScreen(),
    );
  }
}
class UserPageScreen extends StatefulWidget {
  @override
  UserPageScreenState createState() => UserPageScreenState();
}

class UserPageScreenState extends State<UserPageScreen> {
  final url = Uri.parse('http://192.168.0.100:8092/api_products/products');
  final headers = {'Content-Type': 'application/json'};

  List<ModelProduct> dataList = [];
  ModelUser? user;

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> addAnnouncement() async {
    final response = await http.get(Uri.parse('http://192.168.0.100:8092/api_products/products'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelProduct>.from(jsonData.map((data) => ModelProduct.fromJson(data)));
      });
    }
  }
  Future<void> addCart(int? productId, BuildContext context) async {
    int? userId = await getUserId();
    final response = await http.post(Uri.parse('http://192.168.0.100:8092/api_carts/addProductCart/$productId/$userId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    addAnnouncement();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Список товар', style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LkPageScreen()));
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            return Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Text(
                            'Наименование: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.name.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                        children: [
                          Text(
                            'Описание: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.description.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                        children: [
                          Text(
                            'Цена: ${data?.price}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ]
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Фото:',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              height: 300,
                              child: data?.image != null
                                  ? Image.memory(
                                data!.image,
                                fit: BoxFit.cover,
                              )
                                  : Placeholder(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        onPrimary: Colors.black,
                      ),
                      child: Text('Добавить в корзину'),
                      onPressed: () {
                        addCart(data.id, context);
                      },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen()));
          },
          child: Icon(Icons.shopping_cart),
          backgroundColor: Colors.blueGrey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
