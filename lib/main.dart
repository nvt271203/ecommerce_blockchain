import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';
import 'package:sales_business_app/views/screens/auth_screen/login_screen.dart';
import 'package:sales_business_app/views/screens/main_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());

  // WidgetsFlutterBinding.ensureInitialized();
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => ContractFactoryServies()),
  //       // Nếu có provider khác (như userProvider), thêm vào đây
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractFactoryServies>(create: (context)=>ContractFactoryServies(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    home: MainScreen(),
      ),);

  }
}