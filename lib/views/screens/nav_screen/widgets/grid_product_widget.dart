import 'package:flutter/material.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/product_widget.dart';
import '../../../../models/product.dart';

class GridProductWidget extends StatefulWidget {
  const GridProductWidget({super.key, required this.numberColumn, required this.products});
  final int numberColumn;
  final List<Product> products;

  @override
  State<GridProductWidget> createState() => _GridSecondState();
}

class _GridSecondState extends State<GridProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero, // Loại bỏ padding
      child: GridView.builder(
        padding: EdgeInsets.zero, // Loại bỏ padding bên trong GridView
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.numberColumn,
          childAspectRatio: 2 / 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          return ProductWidget(product: widget.products[index]);
        },
      ),
    );
  }
}
