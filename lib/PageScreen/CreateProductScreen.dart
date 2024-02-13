import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kp/PageScreen/ManagerPageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Создание товара', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Наименование товара',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Описание товара',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Цена',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectImage();
              },
              child: Text('Выбрать изображение'),
            ),
            if (_image != null)
              Image.file(File(_image!.path)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                add(context);
              },
              child: Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> add(BuildContext context) async {
    int? userId = await getUserId();
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;

    if (_image != null) {
      final url = Uri.parse('http://192.168.0.100:8092/api_products/addProducts/$userId');
      var request = http.MultipartRequest('POST', url);

      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price;

      Uint8List imageBytes = await _image!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Товар успешно добавлен !'),
          ),
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerPageScreen()));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Выберите изображение !'),
        ),
      );
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) =>ManagerPageScreen()));
  }

}



// Future<void> add(BuildContext context) async {
  //   int? userId = await getUserId();
  //   String name = nameController.text;
  //   String description = descriptionController.text;
  //   String price = priceController.text;
  //
  //   final imagePicker = ImagePicker();
  //   final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  //
  //   final url = Uri.parse('http://192.168.0.100:8092/api_products/addProducts/$userId');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //   });
  //
  //   final response = await http.post(url, headers: headers, body: body);
  //
  //   if (response.statusCode == 200)
  //   {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(response.body),
  //       ),
  //     );
  //     Navigator.push(context,MaterialPageRoute(builder: (context) => ManagerPageScreen()));
  //   }
  //   else
  //   {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Ошибка!'),
  //         content: Text('Проверьте введенные данные !'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
