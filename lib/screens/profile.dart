import 'package:flutter/material.dart';
import 'package:flutter_product_app/screens/product_list_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product App'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/eye.jpeg'),
            Text('Orawan Sukham'),
            Text('64010914610'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ProductListScreen()),
                  );
                },
                child: Text('แสดงรายการสิงค้า'))
          ],
        ),
      ),
    );
  }
}
