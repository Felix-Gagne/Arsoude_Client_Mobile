import 'package:flutter/material.dart';
import 'package:untitled/Http/Models.dart';

import '../Http/HttpService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  HelloWorld helloWorld = new HelloWorld();

  Future loadHelloWorld() async{
    try{
      helloWorld = await getHttp();
    }
    catch (e){
      print(e);
    }
  }
  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  void initState(){
    loadHelloWorld();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: (helloWorld != null) ? Text(helloWorld.text) : Text("ca marche pas du tout la par contre"),

      ),
    );
  }
}