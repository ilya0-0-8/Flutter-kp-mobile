import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kp/Models/ModelProduct.dart';

import 'CreateProductScreen.dart';
import 'EditProduct.dart';
import 'LkPageSreen.dart';

class ManagerPageSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: ManagerPageScreen(),
    );
  }
}
class ManagerPageScreen extends StatefulWidget {
  @override
  ManagerPageScreenState createState() => ManagerPageScreenState();
}

class ManagerPageScreenState extends State<ManagerPageScreen> {
  final url = Uri.parse('http://192.168.0.100:8092/api_announcements/announcements');
  final headers = {'Content-Type': 'application/json'};
  List<ModelProduct> dataList = [];

  Future<void> addProduct() async {
    final response = await http.get(Uri.parse('http://192.168.0.100:8092/api_products/products'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelProduct>.from(jsonData.map((data) => ModelProduct.fromJson(data)));
      });
    }
  }

  Future<void> delete(int id,BuildContext context) async {
    final response = await http.delete(Uri.parse('http://192.168.0.100:8092/api_products/delete/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      setState(() {
        dataList.removeWhere((element) => element.id == id);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    addProduct();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Список товаров', style: TextStyle(color: Colors.black)),
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
                      ],
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
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Цена: ${data?.price}',
                          style: TextStyle(fontSize: 16),
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
                    )
                    ,
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        onPrimary: Colors.black,
                      ),
                      child: Text('Редактировать'),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProduct(
                              id: data.id,
                              nameProduct: utf8.decode(data.name.codeUnits),
                              descriptionProduct: utf8.decode(data.description.codeUnits),
                              price: data.price,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        onPrimary: Colors.black,
                      ),
                      child: Text('Удалить'),
                      onPressed: () {
                        delete(data.id, context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProductScreen()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
