import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  TestPage({Key? key, required this.url}) : super(key: key);
  final String url;


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              url, // Replace with your image URL
              width: 200,
              height: 200,
              fit: BoxFit.cover, // Adjust the BoxFit as needed
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Test Page!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your button press logic here
              },
              child: Text('Press Me'),
            ),
          ],
        ),
      ),
    );
  }
}

