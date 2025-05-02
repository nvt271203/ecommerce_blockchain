import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_business_app/models/category.dart';

import '../global_variables.dart';

class CategoryController {
  Future<List<Category>> loadCategories()async {
    try {
      http.Response response = await http.get(Uri.parse('$uri/api/categories'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print('PRINT categories response.body: ${response.body}');
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        // List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data.map((e) =>
            Category.fromMap(e)
        ).toList();
        return categories;
      }else{
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error request-response categories: $e');
      return [];
    }
  }
}