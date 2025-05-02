import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';
import 'package:sales_business_app/views/screens/auth_screen/login_screen.dart';
import 'package:sales_business_app/views/screens/main_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContractFactoryServies()),
        // Nếu có provider khác (như userProvider), thêm vào đây
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> _checkTokenAndUser(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString('auth_token');
    final String? userJson = preferences.getString('user');
    print('token - userJson - $token - $userJson');
    return userJson; // Trả về userJson để dùng trong UI
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder<String?>(
        future: _checkTokenAndUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final userJson = snapshot.data;
          // Nếu userJson != null thì vào MainScreen, ngược lại vào LoginScreen
          return userJson != null ?  MainScreen() : MainScreen();
        },
      ),
    );
  }
}