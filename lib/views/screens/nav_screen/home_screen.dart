import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/banner_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/category_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/grid_product_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/header_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/popular_product_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/slider_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widgets/product_card_gridview.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 52),
            HeaderWidget(),
            BannerWidget(),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.white],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Icon(Icons.filter_alt_sharp),
                ],
              ),
            ),
            SizedBox(height: 10),
            CategoryWidget(),
            // SizedBox(height: 20),
            // Text('Products'),



            //-----------------------
            Consumer<ContractFactoryServies>(
              builder: (context, contractFactoryServies, child) {
                return Column(
                  children: [
                    // Hiển thị số lượng sản phẩm
                    Text(
                      'Số lượng sản phẩm: ${contractFactoryServies.allProducts.length}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Hiển thị trạng thái tải hoặc danh sách sản phẩm
                    if (contractFactoryServies.storeProductsLoading)
                      Center(child: CircularProgressIndicator())
                    else if (contractFactoryServies.allProducts.isEmpty)
                      Center(child: Text('Không có sản phẩm nào'))
                    else
                      Container(
                        child: AlignedGridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          padding: EdgeInsets.all(15),
                          itemCount: contractFactoryServies.allProducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            return customProductCardWidget(
                              context,
                              contractFactoryServies.allProducts[index].image,
                              contractFactoryServies.allProducts[index].name,
                              contractFactoryServies.allProducts[index].price.toString(),
                              contractFactoryServies.allProducts[index],
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}