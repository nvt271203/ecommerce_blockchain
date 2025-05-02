
import 'dart:convert';

class User{
  // Các trường dữ liệu này ko phải lúc nào cx phải có, tùy theo get hay post mà sẽ set cho phù hợp
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  User({required this.id, required this.fullName, required this.email, required this.state, required this.city, required this.locality, required this.password, required this.token});

//--------------------- Chuyển Object thành Map<key, Value> cho phù hợp định dạng JSON
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "fullName": this.fullName,
      "email": this.email,
      "state": this.state,
      "city": this.city,
      "locality": this.locality,
      "password": this.password,
      "token": this.token,
    };
  }
  //--------Convert data sang chuỗi json để gửi request lên API
  String toJson() => json.encode(toMap());

//----------------------------
// --------Handel data user from Json(get API) convert Map to use Object.
  //----nếu get k có dữ liệu đó thì set default = ""
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["_id"] as String? ?? "",
      fullName: json["fullName"] as String? ?? "",
      email: json["email"] as String? ?? "",
      state: json["state"] as String? ?? "",
      city: json["city"] as String? ?? "",
      locality: json["locality"] as String? ?? "",
        password: json["password"] as String? ?? "",
        token: json["token"] as String? ?? ""
    );
  }
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}