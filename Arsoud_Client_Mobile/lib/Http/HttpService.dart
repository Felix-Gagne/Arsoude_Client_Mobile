import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'Models.dart';

final dio = Dio();

Future<HelloWorld> getHttp() async {
  try{

    //Il faudra changer l'adresse lors du deploiment du serveur
    final response = await dio.get('http://10.0.2.2:5050/api/User/GetWord');
    print(response);
    return HelloWorld.fromJson(response.data);
  }
  catch (e){
    print(e);
    throw(e);
  }

}






