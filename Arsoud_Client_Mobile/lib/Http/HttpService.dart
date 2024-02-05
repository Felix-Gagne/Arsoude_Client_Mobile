
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

import 'Models.dart';

  final dio = Dio(); // With default `Options`.

  void configureDio() {
    // Set default configs
    //dio.options.baseUrl = 'https://arsoudeserv.azurewebsites.net/api';
    dio.options.baseUrl = 'http://10.0.2.2:5050/api';
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);
  }

  final storage = new Storage.FlutterSecureStorage();

  Future<String> addCoordinates(List<Coordinates> coords, int trailId) async {
    try{
      //Il faudra changer l'adresse lors du deploiment du serveur
      final response = await dio.post(dio.options.baseUrl + "trail/addcoordinates/$trailId", data: coords);
      print(response);
      return "Coordinates changed";
    }
    catch (e){
      print(e);
      throw(e);
    }
  }

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

  Future<List<Randonne>> getTrailListUser() async{
    try{
      String? token = await storage.read(key: 'jwt');

      var response = await dio.get('/Trail/GetUserTrails', options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": "Bearer $token",
        }
      ));
      print(response);
      var listJson = response.data as List;
      var listTrail = listJson.map((elementJson){
        return Randonne.fromJson((elementJson));
      }).toList();
      return listTrail;
    }
    catch (e){
        print(e);
        throw e;
    }
  }








