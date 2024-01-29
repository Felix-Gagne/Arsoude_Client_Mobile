import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

import 'Models.dart';

final dio = Dio(); // With default `Options`.

void configureDio() {
  // Set default configs
  dio.options.baseUrl = 'http://10.0.2.2:5050/api';
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 3);
}

final storage = new Storage.FlutterSecureStorage();



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

Future<bool> login(LoginDTO data) async{
  try{
    configureDio();
    var response = await dio.post("/User/Login", data: data, options: Options(
        contentType: "application/json"
    ));
    print(response);
    var token = response.data["token"];
    await storage.write(key: 'jwt', value: token);

    return true;
  }
  catch (e){
    print(e);
    throw (e);
  }
}








