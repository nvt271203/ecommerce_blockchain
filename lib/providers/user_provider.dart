import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
      : super(null);

  //     (User(
  //           id: '',
  //           fullName: '',
  //           email: '',
  //           state: '',
  //           city: '',
  //           locality: '',
  //           password: '',
  //           token: '')
  // );

  //Getter
  // Trả về trạng thái hiện tại của User.
  // state chính là giá trị của StateNotifier<User>
  // tức là đối tượng User đang được quản lý.
  User? get user => state;

  //Setter
  // Mục đích: Cập nhật trạng thái User từ một chuỗi JSON.
  // User.fromJson(userJson): Chuyển đổi JSON thành một đối tượng User.
  // state = ...: Cập nhật trạng thái mới
  // tự động thông báo đến mọi nơi đang sử dụng userProvider.
  void setUser(String userJson){
    state = User.fromJson(userJson);
  }
  // 🔥 Hàm đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Xóa token
    await prefs.remove('user'); // Xóa thông tin user
    state = null; // Cập nhật trạng thái user thành null
  }


}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider(),);


// Tóm tắt chức năng
// UserProvider là một StateNotifier giúp quản lý trạng thái của một User.
// state chứa thông tin user và có thể cập nhật khi cần.
// Getter user để lấy dữ liệu user hiện tại.
// Setter setUser(userJson) để cập nhật trạng thái user từ JSON.
// userProvider là một StateNotifierProvider
// cho phép Flutter truy cập UserProvider và sử dụng dữ liệu trong toàn bộ ứng dụng.