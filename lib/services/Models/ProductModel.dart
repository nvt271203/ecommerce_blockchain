import 'package:web3dart/credentials.dart';

class ProductModel {
  late BigInt id;
  late String name;
  late String description;
  late String image;
 late bool sold;
  late EthereumAddress owner;
  late BigInt price;
  late String category;

  ProductModel({
    required this.id,required this.name,required this.description,required this.image,required this.sold,required this.owner,required this.price,required this.category,
});
  // Override toString để trả về chuỗi mô tả đối tượng
  @override
  String toString() {
    return 'ProductModel(\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  description: $description,\n'
        '  image: $image,\n'
        '  sold: $sold,\n'
        '  owner: $owner,\n'
        '  price: $price,\n'
        '  category: $category\n'
        ')';
  }
}
