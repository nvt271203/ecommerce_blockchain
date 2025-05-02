import 'dart:convert';
import 'package:sales_business_app/providers/user_provider.dart';
import 'package:sales_business_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_business_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:sales_business_app/services/manage_http_response.dart';
import '../global_variables.dart';
import '../views/screens/auth_screen/login_screen.dart';
import '../views/screens/nav_screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final providerContainer = ProviderContainer();
class AuthController {
  Future<void> signUpUsers(
      context, String email, String fullName, String password) async {
    try {
      User user = User(
          id: 'id',
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: '');
      //uri: địa chỉ ip máy, chạy local ở file global_variable
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          // Hàm convert Map -> sang chuỗi String Json ở Object User.
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      //Sau khi đã nhận response khi gửi request post, gọi hàm quản lý mã trạng thái trả về
      manageHttpResponse(response, context, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        showSnackBar(context, 'Account has been created for you');
      });
    } catch (e) {
      print('Error request-response Auth Signup: $e');
    }
  }

  Future<void> signInUsers(context, String email, String password) async {
    try {
      //uri: địa chỉ ip máy, chạy local ở file global_variable
      http.Response response = await http.post(Uri.parse('$uri/api/signin'),
          // Hàm convert Map -> sang chuỗi String Json ở Object User.
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      //Sau khi đã nhận response khi gửi request post, gọi hàm quản lý mã trạng thái trả về
      manageHttpResponse(response, context, () async {

        //=-------- Lưu token đăng nhập vào SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();  // Mở bộ nhớ tạm của ứng dụng để lưu dữ liệu.
        String token = jsonDecode(response.body)['token']; //Trích xuất token từ phản hồi JSON.
        await preferences.setString('auth_token', token); //Lưu token vào SharedPreferences để sử dụng sau này (ví dụ: gọi API có xác thực).

        //=---------- Lưu thông tin User vào Provider và SharedPreferences
        final userJson = jsonEncode(jsonDecode(response.body)['user']); //  Chuyển thành chuỗi JSON để lưu trữ  từ phản hồi API..
        //providerContainer.read(userProvider.notifier): Lấy instance UserProvider.
        // .setUser(userJson): Cập nhật trạng thái người dùng từ dữ liệu API.
           providerContainer.read(userProvider.notifier).setUser(userJson);
        // Lưu user vào SharedPreferences: Để lần sau mở app không cần đăng nhập lại.
        await preferences.setString('user', userJson);

        print(jsonEncode(jsonDecode(response.body)));

        showSnackBar(context, 'Account has been created for you');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false, // Xóa tất cả các màn hình trước đó khỏi stack
        );
      });
    } catch (e) {
      print('Error request-response Auth Signin: $e');
    }
  }
}
