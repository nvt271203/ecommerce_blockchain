import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/subcategory.dart';
import '../services/manage_http_response.dart';

class SubCategoryController {
  uploadCategory({
    required String categoryId  ,
    required String categoryName  ,
    required dynamic pickedImage,
    required String subCategoryName  ,
    required BuildContext context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('doiar6ybd', 'qyekpvza');
      //upload Image
      CloudinaryResponse imgSubCategoryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'PickedImgSubCategory',
          folder: 'CategoryImages',
        ),
      );
      // print(imgCategoryResponse);
      String urlImgCategory = imgSubCategoryResponse.secureUrl;
      SubCategory subCategory = SubCategory(id: '', categoryId: categoryId, categoryName: categoryName, image: urlImgCategory, subCategoryName: subCategoryName);


      http.Response response = await http.post(
        Uri.parse('$uri/api/subcategories'),
        body: subCategory.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(response, context, () {
        showSnackBar(context, 'Upload SubCategory Success');
      });
      print('upload SubCategory Success');
    } catch (e) {
      print('Error upload to cloudinary: $e');
    }
  }


  Future<List<SubCategory>> loadSubCategories()async{
    try{
      http.Response response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('dataGetSubcategory: '+ response.body);
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        // or List<Map<String, String>> data = jsonDecode(response.body);

        List<SubCategory> subCategories = data.map((item) => SubCategory.fromMap(item)).toList();
        print('getLengthSubCategories:'+ subCategories.length.toString());
        // print('image:'+ banners[0].image.toString());
        return subCategories;
      } else{
        throw Exception('Failed to load categories');
      }
    }catch(e){
      print('Error get SubCategories: $e');
      return [];
    }
  }
  Future<List<SubCategory>> getSubCategoriesByCategoryName(String categoryName)async{
    try{
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/${categoryName}/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('dataGetSubcategory: '+ response.body);
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);

        if(data.isNotEmpty){
          return data.map((subCategory) => SubCategory.fromMap(subCategory),).toList();
        }else{
          print('subcategories not found');
          return [];
        }


        // List<SubCategory> subCategories = data.map((item) => SubCategory.fromMap(item)).toList();
        // print('getLengthSubCategories:'+ subCategories.length.toString());
        // // print('image:'+ banners[0].image.toString());
        // return subCategories;
      } else if(response.statusCode == 404){
        print('subcategories not found');
        return [];

      } else{
        throw Exception('Failed to load categories');
        return [];

      }
    }catch(e){
      print('Error get SubCategories: $e');
      return [];
    }
  }
}
