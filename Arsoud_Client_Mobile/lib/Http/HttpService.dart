import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'Models.dart';
final dio = Dio();

  getDio(){
    Dio dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:5050/api';
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    return dio;
  }

  void configureDio() {
    //dio.options.baseUrl = 'https://arsoudeserv.azurewebsites.net/api';
    dio.options.baseUrl = 'http://10.0.2.2:5050/api';
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
  }

   getOptions() async{
    String? token = await storage.read(key: 'jwt');
    return Options(
        contentType: "application/json",
        headers: {
        "Authorization": "Bearer $token",
        }
    );
  }


  const storage = Storage.FlutterSecureStorage();

  Future<String> addCoordinates(List<Coordinates> coords, int trailId) async {
    try{
      String? token = await storage.read(key: 'jwt');
      //Il faudra changer l'adresse lors du deploiment du serveur
      configureDio();
      List<Map<String, dynamic>> coordsJsonList = coords.map((coord) => coord.toJson()).toList();
      final response = await dio.post("/trail/addCoordinates/$trailId", data: jsonEncode(coordsJsonList),options: await getOptions());
      print(response);
      return "Coordinates changed";
    }
    catch (e){
      print(e);
      throw(e);
    }
  }

Future<String> CreateHike(Hike hike) async {
  try{
    configureDio();

    String? token = await storage.read(key: 'jwt');
    final response = await dio.post("/trail/CreateHike", data: hike.toJson(), options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": "Bearer $token",
        }));
    print(response);
    return "Hike Sent!";
  }
  catch (e){
    print(e);
    throw(e);
  }
}
Future<String> sendImage(String url, int trailId) async {
  try{
    String imageurl = url;
    configureDio();

    ImageRequestModel img = ImageRequestModel();
    img.url = url;

    final response = await dio.post("/trail/SendImage/$trailId", data: img.toJson(),options: await getOptions());
    var responseInfo = response;
    print(response);
    return "Image added to list";
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
      final response = await dio.get("${dio.options.baseUrl}/trail/CheckOwnerByTrailId/$trailId",options: await getOptions());
      print(response);
      bool result = bool.parse(response.data.toString());
      return result ;
    }
    catch (e){
      print(e);
      throw(e);
    }
  }


  Future<void> SetPublic(int trailId) async{
    try{
      configureDio();
      final response = await dio.get("/trail/SetTrailStatus/$trailId/true",options: await getOptions());
    }
    catch(e){
      print(e);
      throw(e);
    }
  }

Future<void> SetPrivate(int trailId) async{
  try{
    configureDio();
    await dio.get("/trail/SetTrailStatus/$trailId/false",options: await getOptions());
  }
  catch(e){
    print(e);
    throw(e);
  }
}

Future<List<Coordinates>> getCoordinates(int trailId) async {
  try{
    String? token = await storage.read(key: 'jwt');
    List<Coordinates> result = [];
    final response = await getDio().get("/trail/GetTrailCoordinates/$trailId", options: await getOptions());
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

      var response = await dio.get('/Trail/GetUserTrails', options: await getOptions());
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
    //print(response);
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
    var response = await dio.get('/Trail/GetFavoriteTrails', options: await getOptions());
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
    var response = await dio.get('/Trail/ManageTrailFavorite/$id', options: await getOptions());
    return !etat;
  }
  catch (e){
    print(e);
    throw e;
  }
}

Future<List<String>> getTrailImages(int trailId) async{
  try{
    configureDio();
    var response = await dio.get('/Trail/GetTrailImages/$trailId', options: await getOptions());
    List<dynamic> list = response.data;
    List<String> imageList = list.cast<String>();
    return imageList;
  }
  catch (e){
    print(e);
    throw e;
  }
}

Future<String> rateHike(int trailId, double rating) async{
  try{
    configureDio();

    RatingRequestModel ratingModel = RatingRequestModel();
    ratingModel.Rating = rating.toString();

    var response = await dio.post('/Trail/RateTrail/$trailId', data: ratingModel.toJson(), options: await getOptions());
    return rating.toString();
  }
  catch (e){
    print(e);
    throw e;
  }
}









