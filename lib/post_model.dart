import 'dart:convert';

class PostModel {
  String? name;
  String? audio1;
  double? volume1;
  String? audio2;
  double? volume2;

  PostModel({
    required this.name,
    required this.audio1,
    required this.volume1,
    required this.audio2,
    required this.volume2,
  });

  factory PostModel.fromJson(String str) => PostModel.fromMap(json.decode(str));

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
        name: json["name"],
        audio1: json["audio1"],
        volume1: json["volume1"],
        audio2: json["audio2"],
        volume2: json["volume2"],
      );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "audio1": audio1,
      "volume1": volume1,
      "audio2": audio2,
      "volume2": volume2,
    };
  }
}
