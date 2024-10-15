import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_product_app/screens/product_list_screen.dart';
import '../services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductUpdateScreen extends StatefulWidget {
  final Map productData;
  const ProductUpdateScreen({super.key, required this.productData});

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _pronameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ProductService _productService = ProductService();
  Future<void> _pickImage(ImageSource source) async {
//ประกาศตัวแปร pickedFile สําหรับจัดเก็บไฟลgรูปภาพที่เลือก
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
//กําหนดให8ตัวแปร _image เก็บข8อมูลไฟลgรูปภาพที่อยูKในตัวแปร pickedFile

        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลสินค้า'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
//แสดงรูปภาพที่เลือก
              SizedBox(
                  height: 150,
                  child: _image != null
                      ? Image.file(_image!)
                      : Image.network(ProductService().imageUrl +
                          "/" +
                          widget.productData['image'])),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('ถ่ายรูป'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('เลือกรูปจากแกลเลอรี'),
                  ),
                ],
              ),
              TextField(
                controller: _pronameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_image != null) {
                      String proname = _pronameController.text;
                      double price = double.parse(_priceController.text);
//เรียกใช8api เพื่อแก8ไขข8อมูล
                      final upload = await _productService.updateProduct(
                          widget.productData['proId'], _image!, proname, price);
//ตรวจสอบตัวแปร upload
                      if (upload != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('สําเร็จ'),
                        ));
//กลับไปยังหน8าแสดงรายการสินค8า
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ProductListScreen()),
                            (Route<dynamic> route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('ผิดพลาด'),
                        ));
                      }
                    }
                  },
                  label: Text('แก้ไขข้อมูล')),
//ให8นิสิตเพิ่มโค8ดการลบข8อมูลสินค8า โดยดูตัวอยKางจากปุØมแก8ไขข8อมูล

              ElevatedButton.icon(
                onPressed: () async {
                  // Retrieve the product ID as an integer
                  int productId = widget.productData['proId'];

                  // Ensure the product ID is valid
                  if (productId != null) {
                    try {
                      // Call the API to delete the product using its ID
                      final upload =
                          await _productService.deleteProduct(productId);

                      // Check the response from the API
                      if (upload) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('สำเร็จ'),
                        ));

                        // Navigate back to the product list
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ProductListScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('ผิดพลาด'),
                        ));
                      }
                    } catch (e) {
                      // Handle any errors that occur during the API call
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
                      ));
                    }
                  } else {
                    // Show a message if the product ID is not available
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('ไม่พบรหัสสินค้านี้'),
                    ));
                  }
                },
                label: Text('ลบข้อมูล'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
