import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<String> images;

  Product({required this.id, required this.productName, required this.productPrice, required this.quantity, required this.description, required this.category, required this.vendorId, required this.fullName, required this.subCategory, required this.images});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "productName": this.productName,
      "productPrice": this.productPrice,
      "quantity": this.quantity,
      "description": this.description,
      "category": this.category,
      "vendorId": this.vendorId,
      "fullName": this.fullName,
      "subCategory": this.subCategory,
      "images": this.images,
    };
  }

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      productName: json["productName"],
      productPrice: json["productPrice"],
      quantity: json["quantity"],
      description: json["description"],
      category: json["category"],
      vendorId: json["vendorId"],
      fullName: json["fullName"],
      subCategory: json["subCategory"],
      // images: List.of(json["images"]).map((i) => json["images"]).toList(),
      // images: json["images"]
        images: (json["images"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? []

    );
  }
  //--------Convert data sang chuỗi json để gửi request lên API
  String toJson() => json.encode(toMap());
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
//
}