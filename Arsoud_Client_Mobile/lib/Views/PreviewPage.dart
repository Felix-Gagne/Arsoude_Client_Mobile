import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Http/Models.dart';
import '../generated/l10n.dart';
import 'package:untitled/Http/HttpService.dart';

class PreviewPage extends StatelessWidget {
  PreviewPage({Key? key, required this.picture, required this.randonne})
      : super(key: key);

  final Randonne randonne;
  final XFile picture;

  String imageUrl = "";

  @override
  void initState() {}

  SendImage() async {
    final firebaseStorage = FirebaseStorage.instance;

    var imageFile = File(picture.path);
    List<String> filename = imageFile.path.split('/');
    var snapshot = await firebaseStorage
        .ref()
        .child(filename[filename.length - 1])
        .putFile(imageFile)
        .whenComplete(() => print('upload image'));

    var url = await snapshot.ref.getDownloadURL();
    imageUrl = url;
    sendImage(imageUrl.toString(), randonne.id);
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
                if(!context.mounted) return;
                Navigator.of(context).popUntil((_) => count++ >= 2);
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
                  Text(S.of(context).sendPhoto,
                      style: const TextStyle(color: Colors.white)),
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
