import 'dart:convert';

class Category {
  final String id;
  final String name;
  final String image;
  final String banner;
  Category({required this.id, required this.name, required this.image, required this.banner});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
      "banner": this.banner,
    };
  }

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      id: json["_id"],
      name: json["name"],
      image: json["image"],
      banner: json["banner"],
    );
  }
  //--------Convert data sang chuỗi json để gửi request lên API
  String toJson() => json.encode(toMap());
  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}