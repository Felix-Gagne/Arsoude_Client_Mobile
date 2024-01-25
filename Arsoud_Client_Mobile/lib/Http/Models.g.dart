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
