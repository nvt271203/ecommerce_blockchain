import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/product_controller.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/grid_product_widget.dart';

import '../../../../models/product.dart';
class PopularProductWidget extends StatefulWidget {
  const PopularProductWidget({super.key});

  @override
  State<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends State<PopularProductWidget> {
  late Future<List<Product>> futureProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureProducts = ProductController().loadPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No Products'),
          );
        } else {
          final products = snapshot.data!;
          // final List<String> bannerImages = categories.map((banner) => banner.image).toList();
          // return SliderWidget(imgList: bannerImages);
          return GridProductWidget(numberColumn: 2, products: products);

          //   SingleChildScrollView(
          //   scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
          //   child: Row(
          //     children: products.map((product) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min, // Tránh lỗi Overflow
          //           children: [
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(20),
          //               child: Image.network(
          //                 product.images[0],
          //                 height: 60,
          //                 width: 60,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             SizedBox(height: 8), // Khoảng cách giữa ảnh và text
          //             Text(
          //               product.productName,
          //               textAlign: TextAlign.center,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ],
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // );
        }
      },
    );
  }
}
