import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kp/Models/ModelProduct.dart';
import 'package:kp/PageScreen/UserPageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import "package:flutter_localizations/flutter_localizations.dart";

import '../Models/ModelCart.dart';
import '../Models/ModelUser.dart';

class MyCartScreen extends StatefulWidget {
  @override
  MyCartScreenState createState() => MyCartScreenState();
}

class MyCartScreenState extends State<MyCartScreen> {
  ModelCart? cart;
  int total = 0;

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  final headers = {'Content-Type': 'application/json'};
  List<ModelCart> dataList = [];

  Future<void> addCart() async {
    int? userId = await getUserId();
    final response = await http.get(Uri.parse('http://192.168.0.100:8092/api_carts/my_products/$userId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelCart>.from(jsonData.map((data) => ModelCart.fromJson(data)));
        total = dataList.fold(0, (previousValue, element) => previousValue + element.total);
      });
    }
  }
  Future<void> deleteCart(int? productId, BuildContext context) async {
    final response = await http.delete(Uri.parse('http://192.168.0.100:8092/api_carts/delete/$productId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    addCart();
  }
  Future<void> addCount(int? productId, BuildContext context) async {
    int? userId = await getUserId();
    final response = await http.post(Uri.parse(
        'http://192.168.0.100:8092/api_carts/addProductCart/$productId/$userId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    addCart();
  }
  @override
  void initState() {
    super.initState();
    addCart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Корзина', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPageScreen()),);
            },
          ),
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
                            utf8.decode(data.product.name.codeUnits),
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
                          SizedBox(height: 8),
                          Text(
                            utf8.decode(data.product.description.codeUnits),
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
                            'Цена: ${data?.product.price}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Количество: ${data?.count}',
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            addCount(data?.product.id, context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.blueGrey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteCart(data?.id, context);
                          },
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ],
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
                              child: data?.product.image != null
                                  ? Image.memory(
                                data!.product.image,
                                fit: BoxFit.cover,
                              )
                                  : Placeholder(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              onPrimary: Colors.black,
                            ),
                            child: Text('Удалить'),
                            onPressed: () {
                              deleteCart(data?.id,context);
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Общая сумма: $totalAmount',
                    //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],

                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Общая сумма: $total',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}