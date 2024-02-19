
import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

import 'Models.dart';

  final dio = Dio(); // With default `Options`.

  getDio(){
    Dio dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:5050/api';
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);
    return dio;
  }

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
      String? token = await storage.read(key: 'jwt');
      //Il faudra changer l'adresse lors du deploiment du serveur
      List<Map<String, dynamic>> coordsJsonList = coords.map((coord) => coord.toJson()).toList();
      final response = await dio.post(dio.options.baseUrl + "/trail/addCoordinates/$trailId", data: jsonEncode(coordsJsonList),options: Options(
          contentType: "application/json",
          headers: {
            "Authorization": "Bearer $token",
          }));
      print(response);
      return "Coordinates changed";
    }
    catch (e){
      print(e);
      throw(e);
    }
  }


  Future<bool> IsOwner(int trailId) async{
    try{
      String? token = await storage.read(key: 'jwt');
      //Il faudra changer l'adresse lors du deploiment du serveur
      ;
      final response = await dio.get(dio.options.baseUrl + "/trail/CheckOwnerByTrailId/$trailId",options: Options(
          contentType: "application/json",
          headers: {
            "Authorization": "Bearer $token",
          }));
      print(response);
      bool result = bool.parse(response.data.toString());
      return result ;
    }
    catch (e){
      print(e);
      throw(e);
    }



  }


  Future<String> SetPublic(int Trailid) async{
    try{
      String? token = await storage.read(key: "jwt");
      final response = await dio.get(dio.options.baseUrl + "/SetTrailToPublic/"+Trailid.toString(),options: Options(
          contentType: "application/json",
          headers: {
            "Authorization": "Bearer $token",
          }));


    }
    catch(e){

      print(e);
      throw(e);
    }

    return "";
  }
Future<String> SetPrivate(int Trailid) async{
  try{
    String? token = await storage.read(key: "jwt");
    final response = await dio.get(dio.options.baseUrl + "/SetTrailToPrivate/"+Trailid.toString(),options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": "Bearer $token",
        }));


  }
  catch(e){

    print(e);
    throw(e);
  }

  return "";
}

Future<List<Coordinates>> getCoordinates(int trailId) async {
  try{
    String? token = await storage.read(key: 'jwt');
     List<Coordinates> result = [];
    final response = await getDio().get("/trail/GetTrailCoordinates/$trailId",options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": "Bearer $token",
        }
    ));
    for(var e in response.data)
    {
      result.add(Coordinates.fromJson(e));
    }
    return result ;
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
      await storage.write(key: 'email', value: data.username);

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

Future<List<Randonne>> getAllTrails() async{
  try{
    configureDio();
    var response = await dio.get('/Trail/GetAllTrails', options: Options(
        contentType: "application/json",
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

Future<List<Randonne>> getUserFavoriteTrails() async{
  try{
    String? token = await storage.read(key: 'jwt');

    var response = await dio.get('/Trail/GetFavoriteTrails', options: Options(
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

Future<bool> manageTrailFavorite(int id, bool etat) async{
  try{
    String? token = await storage.read(key: 'jwt');
    var response = await dio.get('/Trail/ManageTrailFavorite/$id', options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": "Bearer $token",
        }
    ));
    print(response);

    return !etat;
  }
  catch (e){
    print(e);
    throw e;
  }
}









