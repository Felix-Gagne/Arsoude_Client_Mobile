// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelloWorld _$HelloWorldFromJson(Map<String, dynamic> json) =>
    HelloWorld()..text = json['text'] as String;

Map<String, dynamic> _$HelloWorldToJson(HelloWorld instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

LoginDTO _$LoginDTOFromJson(Map<String, dynamic> json) => LoginDTO()
  ..username = json['username'] as String
  ..password = json['password'] as String;

Map<String, dynamic> _$LoginDTOToJson(LoginDTO instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

Randonne _$RandonneFromJson(Map<String, dynamic> json) => Randonne()
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..location = json['location'] as String
  ..type = json['type'] as int
  ..imageUrl = json['imageUrl'] as String
  ..startingCoordinates =
      Coordinates.fromJson(json['startingCoordinates'] as Map<String, dynamic>)
  ..endingCoordinates =
      Coordinates.fromJson(json['endingCoordinates'] as Map<String, dynamic>);

Map<String, dynamic> _$RandonneToJson(Randonne instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'startingCoordinates': instance.startingCoordinates,
      'endingCoordinates': instance.endingCoordinates,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates()
  ..x = (json['x'] as num).toDouble()
  ..y = (json['y'] as num).toDouble();

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
