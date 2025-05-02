import 'dart:convert';

class BannerModel {
  final String id;
  final String image;

  BannerModel({required this.id, required this.image});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "image": this.image,
    };
  }
  String toJson() => json.encode(toMap());


  factory BannerModel.fromMap(Map<String, dynamic> json) {
    return BannerModel(
      id: json["_id"],
      image: json["image"],
    );
  }
  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}