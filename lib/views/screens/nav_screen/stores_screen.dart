import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/product_controller.dart';
import 'package:sales_business_app/views/screens/CreateProductPage.dart';
import 'package:sales_business_app/views/screens/add_product_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/popular_product_widget.dart';
import 'package:sales_business_app/views/screens/widgets/button_widget.dart';
import '../../../models/product.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductController().loadPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.grey[800]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ButtonWidget(
                onClick: () {},
                title: 'Add Banner',
                icon: Icons.add,
                colorTitle: Colors.white,
                colorBackground: Colors.black,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    'No Banner Available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(thickness: 1.5, color: Colors.grey[400]),
              SizedBox(height: 16),
              ButtonWidget(
                onClick: () {
                  Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => AddProductScreen()),
                    MaterialPageRoute(builder: (context) => CreateProductPage()),
                  );
                },
                title: 'Add Product',
                icon: Icons.add,
                colorTitle: Colors.white,
                colorBackground: Colors.blue,
              ),
              SizedBox(height: 16),
              Divider(thickness: 1.5, color: Colors.grey[400]),
              SizedBox(height: 10),
              Text(
                'My Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              PopularProductWidget(),
            ],
          ),
        ),
      ),
    );
  }
}