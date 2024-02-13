import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ManagerPageScreen.dart';
import 'UserPageScreen.dart';

class EditProduct extends StatefulWidget {

  final int id;
  final String nameProduct;
  final String descriptionProduct;
  final int price;

  EditProduct(
      {required this.id,required this.nameProduct, required this.descriptionProduct, required this.price});

  @override
  _EditProductState createState() => _EditProductState(id,nameProduct,descriptionProduct,price);
}
class _EditProductState extends State<EditProduct> {
  late TextEditingController idProductController;
  late TextEditingController nameProductController;
  late TextEditingController descriptionProductController;
  late TextEditingController priceProductController;

  _EditProductState(int id, String nameProduct,
      String descriptionProduct, int price);

  @override
  void initState() {
    super.initState();
    idProductController = TextEditingController(text: widget.id.toString());
    nameProductController =
        TextEditingController(text: widget.nameProduct);
    descriptionProductController =
        TextEditingController(text: widget.descriptionProduct);
    priceProductController =
        TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    idProductController.dispose();
    nameProductController.dispose();
    descriptionProductController.dispose();
    priceProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Редактирование товара',style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerPageScreen()),);
            },
          ),
        ],

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idProductController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Идентификатор товара',
                labelStyle: TextStyle(color: Colors.blueGrey),
              ),
            ),
            TextField(
              controller: nameProductController,
              decoration: InputDecoration(
                labelText: 'Наименование товара',
                labelStyle: TextStyle(color: Colors.blueGrey),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionProductController,
              decoration: InputDecoration(
                labelText: 'Описание товара',
                labelStyle: TextStyle(color: Colors.blueGrey),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: priceProductController,
              decoration: InputDecoration(
                labelText: 'Цена товара',
                labelStyle: TextStyle(color: Colors.blueGrey),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                editData(context);
              },
              child: Text('Изменить данные о товаре'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editData(BuildContext context) async {
    int? id = int.parse(idProductController.text);
    String nameProduct = nameProductController.text;
    String descriptionProduct = descriptionProductController.text;
    String priceProduct= priceProductController.text;

    final url = Uri.parse('http://192.168.0.100:8092/api_products/update/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'id': id,
      'name': nameProduct,
      'description': descriptionProduct,
      'price': priceProduct,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
  }
}
