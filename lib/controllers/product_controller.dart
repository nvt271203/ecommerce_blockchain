import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sales_business_app/models/product.dart';

import '../global_variables.dart';
import '../services/manage_http_response.dart';

class ProductController {
  //Method post Banner

  Future<List<Product>> loadPopularProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/popular-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(response.statusCode == 200){
        final List<dynamic> data = json.decode(response.body);
        List<Product> products = data.map((e) {
          return Product.fromMap(e);
        },).toList();
        print(products.length);
        print(json.encode(json.decode(response.body)));
        return products;

      }else{
        print('Upload Banner Fail');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> uploadProduct({required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context
  }) async {
    try {
      if (pickedImages != null) {
        final cloudinary = CloudinaryPublic('doiar6ybd', 'qyekpvza');
        List<String> images = [];
        for (var i = 0; i < pickedImages!.length; i++) {
          CloudinaryResponse imgResponse = await cloudinary.uploadFile(
              CloudinaryFile.fromFile(pickedImages[i].path, folder: productName)
          );
          images.add(imgResponse.secureUrl);
        }

        if (category.isNotEmpty && subCategory.isNotEmpty) {
          final Product product = Product(id: '',
              productName: productName,
              productPrice: productPrice,
              quantity: quantity,
              description: description,
              category: category,
              vendorId: vendorId,
              fullName: fullName,
              subCategory: subCategory,
              images: images);

          http.Response response = await http.post(
            Uri.parse('$uri/api/add-product'),
            body: product.toJson(),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          manageHttpResponse(response, context, () {
            showSnackBar(context, 'Upload Product Success');
          });

        }else
          showSnackBar(context, 'Please select Category');
      }else{
        showSnackBar(context, 'Please select Image');
      }

      print('Upload Banner Success');
    } catch (e) {
      print(e);
    }
  }

  // //Method getAll banners
  // Future<List<BannerModel>> getBanners() async {
  //   try {
  //     http.Response response = await http.get(
  //       Uri.parse('$uri/api/banners'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     print('getDataImage:' + response.body);
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);
  //       // or List<Map<String, String>> data = jsonDecode(response.body);
  //
  //       List<BannerModel> banners =
  //       data.map((item) => BannerModel.fromMap(item)).toList();
  //       print('getLengthImage:' + banners.length.toString());
  //       print('image:' + banners[0].image.toString());
  //       return banners;
  //     } else {
  //       throw Exception('Failed to load banners');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }
}
