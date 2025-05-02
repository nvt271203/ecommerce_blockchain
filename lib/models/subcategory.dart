import 'dart:convert';

class SubCategory {
  final String id;
  final String categoryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubCategory({required this.id, required this.categoryId, required this.categoryName, required this.image, required this.subCategoryName});

  factory SubCategory.fromMap(Map<String, dynamic> json) {
    return SubCategory(id: json["_id"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      image: json["image"],
      subCategoryName: json["subCategoryName"],);
  }
  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "categoryId": this.categoryId,
      "categoryName": this.categoryName,
      "image": this.image,
      "subCategoryName": this.subCategoryName,
    };
  }
  String toJson() => json.encode(toMap());

}