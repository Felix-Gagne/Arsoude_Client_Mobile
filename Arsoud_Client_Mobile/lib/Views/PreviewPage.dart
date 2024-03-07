import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/Test.dart';
import 'dart:io';
import '../Http/Models.dart';
import '../generated/l10n.dart';
import 'package:untitled/Http/HttpService.dart';

class PreviewPage extends StatelessWidget {
  PreviewPage({Key? key, required this.picture, required this.randonne}) : super(key: key);

  final Randonne randonne;
  final XFile picture;
  //File _imageFile = File("fff");

  String _email = "";
  String imageUrl = "";

  @override
  void initState() {
    getEmail();
  }

  Future<String?> getEmail() async{
    String? email = await storage.read(key: 'email');
    _email = email!;
  }

  SendImage() async {
    final _firebaseStorage = FirebaseStorage.instance;

    var _imageFile = File(picture.path);
    List<String> filename = _imageFile.path.split('/');
    var snapshot = await _firebaseStorage.ref().child(filename[filename.length - 1]).putFile(_imageFile).whenComplete(() => print('upload image'));

    var url = await snapshot.ref.getDownloadURL();
    imageUrl = url;
    print(imageUrl);


    print(randonne.name);

    randonne.imageList ??= [];

    randonne.imageList?.add(imageUrl.toString());

    print(randonne.imageList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
                const SizedBox(height: 24),
                Text(picture.name)
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () async {
                await SendImage();
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage(url: imageUrl,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff09635f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).sendPhoto, style: const TextStyle(color: Colors.white)),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xff09635f),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
