import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_business_app/controllers/auth_controller.dart';
import 'package:sales_business_app/views/screens/auth_screen/register_screen.dart';
import 'package:sales_business_app/views/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // const LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;
  late String password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      body: Stack(children: [
        Positioned(
          left: 0,
          bottom: 0,
          top: 0,
          right: 0,
          child: Image.asset(
            'assets/images/bg_primary.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit
                .cover, // Phải có thuộc tính này ms làm cho width và height đc apply, để bóp ảnh.
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white.withOpacity(0.9)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // tự căn giữa :))))
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ĐĂNG NHẬP',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              fontSize: 24),
                        ),
                        Text(
                          'Săn ưu đãi cực sốc - khám phá ngay',
                          style: GoogleFonts.getFont('Lato',
                              color: Color(0xFF000000).withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.5,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email',
                            style: GoogleFonts.getFont('Lato',
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 16),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value){
                            email = value;
                          },
                          validator: (value) {
                            if(value!.isEmpty) return 'Email đang trống!';
                            else return null;
                            },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              // cho phép 'fillColor' được set, nếu false 'fillColor' sẽ k đc use
                              border: OutlineInputBorder(
                                  // Tạo viền cho input
                                  borderRadius:
                                      BorderRadius.circular(9) // Bo viền 9.
                                  ),

                              //Kiểu viền đc chọn, none là k hiển thị viền khi chọn
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2.0)),
                              // focusedBorder: InputBorder.none, //Kiểu viền đc chọn, none là k hiển thị viền khi chọn

                              //Kiểu viền khi k đc chọn, none là viền k hiển thị.
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1.0)),
                              // enabledBorder: InputBorder.none, //Kiểu viền khi k đc chọn, none là viền k hiển thị.

                              hintText: 'Nhập email của bạn',
                              hintStyle: GoogleFonts.getFont('Nunito Sans',
                                  fontSize: 14, letterSpacing: 0.1),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.email),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password',
                            style: GoogleFonts.getFont('Lato',
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 16),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value){
                            password = value;
                          },
                          validator: (value) {
                            if(value!.isEmpty) return 'Email đang trống!';
                            else return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              // cho phép 'fillColor' được set, nếu false 'fillColor' sẽ k đc use
                              border: OutlineInputBorder(
                                  // Tạo viền cho input
                                  borderRadius:
                                      BorderRadius.circular(9) // Bo viền 9.
                                  ),

                              //Kiểu viền đc chọn, none là k hiển thị viền khi chọn
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2.0)),
                              // focusedBorder: InputBorder.none, //Kiểu viền đc chọn, none là k hiển thị viền khi chọn

                              //Kiểu viền khi k đc chọn, none là viền k hiển thị.
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1.0)),
                              // enabledBorder: InputBorder.none, //Kiểu viền khi k đc chọn, none là viền k hiển thị.

                              hintText: 'Nhập mật khẩu của bạn',
                              hintStyle: GoogleFonts.getFont('Nunito Sans',
                                  fontSize: 14, letterSpacing: 0.1),

                              //icon trái trong input
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.password),
                              ),

                              //icon phải trong input
                              suffixIcon: Icon(Icons.visibility)),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        //Button đăng nhập
                        InkWell(
                          onTap: () async {
                            if( _formKey.currentState != null && _formKey.currentState!.validate()){
                              setState(() {
                                isLoading = true;
                              });
                              print(email);
                              print(password);
                              await _authController.signInUsers(context, email, password);
                              print('Correct');
                              setState(() {
                                isLoading = false;
                              });
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => MainScreen()),
                              //       (route) => false, // Xóa tất cả các màn hình trước đó khỏi stack
                              // );
                            }else{
                              print('false');
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xFF05999E),
                                ),
                                gradient: LinearGradient(colors: [
                                  // Colors.black.withOpacity(0.7),
                                  Color(0xFF05999E),
                                  Colors.white
                                ])),
                            child: Stack(
                              children: [
                                // Phần tử gốc
                                Center(
                                  child: isLoading ? CircularProgressIndicator() :
                                  Text(
                                    'ĐĂNG NHẬP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                // positioned: Phần tử phụ thuộc vào phần tử gốc

                                // START
                                Positioned(
                                    left: -15,
                                    bottom: 10,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 8,
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(60)),
                                      ),
                                    )),
                                Positioned(
                                    left: 40,
                                    top: 30,
                                    child: Opacity(
                                      opacity: 0.2,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 8,
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(60)),
                                      ),
                                    )),

                                // END
                                Positioned(
                                    right: -15,
                                    top: 10,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 8,
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.circular(60)),
                                      ),
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 30,
                                    child: Opacity(
                                      opacity: 0.2,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 8,
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.circular(60)),
                                      ),
                                    )),
                                Positioned(
                                    right: 40,
                                    bottom: 25,
                                    child: Opacity(
                                      opacity: 0.4,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.circular(60)),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),

                        //Desc
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bạn chưa có tài khoản?  ',
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return RegisterScreen();
                                },));
                              },
                              child: Text(
                                'Đăng kí ngay',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
