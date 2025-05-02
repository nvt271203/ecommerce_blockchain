import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_business_app/models/banner.dart';

import '../global_variables.dart';

class BannerController {
  Future<List<BannerModel>> loadBanners()async {
    try {
      http.Response response = await http.get(Uri.parse('$uri/api/banners'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print('PRINT response.body: ${response.body}');
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> bannes = data.map((e) =>
          BannerModel.fromMap(e)
        ).toList();
        return bannes;
      }else{
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error request-response Auth Signup: $e');
      return [];
    }
  }
}