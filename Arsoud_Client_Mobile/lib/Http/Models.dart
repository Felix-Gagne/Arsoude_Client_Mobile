
import 'package:json_annotation/json_annotation.dart';

part 'Models.g.dart';

@JsonSerializable()
class HelloWorld {

  HelloWorld();

  String text = "";

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory HelloWorld.fromJson(Map<String, dynamic> json) => _$HelloWorldFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$HelloWorldToJson(this);
}

@JsonSerializable()
class LoginDTO{

  LoginDTO();

  String username = "";
  String password = "";


  factory LoginDTO.fromJson(Map<String, dynamic> json) => _$LoginDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDTOToJson(this);
}