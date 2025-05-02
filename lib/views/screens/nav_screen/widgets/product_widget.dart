import 'package:flutter/material.dart';
import 'package:sales_business_app/helpers/format_helper.dart';
import 'package:sales_business_app/views/screens/detail_product_screen.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../models/product.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({required this.product});
  // const ProductWidget({super.key});

  final Product product;

  @override
  State<ProductWidget> createState() => _ItemIntroUserState();
}

class _ItemIntroUserState extends State<ProductWidget> {
  // String image = 'assets/images/background.jpg';
  // // void _navigatorDetailUser(BuildContext context) {
  // //   Navigator.of(context).push(MaterialPageRoute(
  // //     builder: (context) => ItemDetailUser(
  // //       person: widget.person,
  // //       showBar: true,
  // //     ),
  // //   ));
  // // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final isScreenWeb = constraints.maxWidth > 600;
        return
          InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return DetailProductScreen(product: widget.product);
              // },));
            },
            child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // bo góc
            ),
            clipBehavior: Clip.hardEdge,
            // bất kì phần tử nào tràn ra ngoài đều bị cắt.
            elevation: 20,

            // Đổ bóng
            child: Container(
              child: Stack(
                children: [
                  Positioned.fill(
                    // ---------- Dùng để chiếm full kích thước theo cha
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      // image: const AssetImage('assets/images/son_tung_mtp.jpg'),
                      // image: AssetImage(image),
                      image: NetworkImage(widget.product.images[0]),
                      fit: BoxFit.cover,
                      // Ảnh sẽ phủ đầy Card
                      width: double.infinity,
                      alignment: Alignment.center, // Căn giữa ảnh
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.6)
                                  ]),
                                  border: Border.all(width: 2, color: Colors.white)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.product.productName.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, // Khi quá dài sẽ hiển thị dấu "..."
                                      // textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:  10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // Căn đều các phần tử
                                children: [
                                  Container(
                                    width: 35, // Chiều rộng của nút
                                    height: 35, // Chiều cao của nút
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Màu nền
                                      borderRadius: BorderRadius.circular(10), // Bo góc
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      iconSize: 20,
                                      icon: const Icon(Icons.favorite_border),
                                      color: Colors.red, // Màu biểu tượng
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Container(
                                      // decoration: BoxDecoration(color: Color(0xFF6B0000)),
                                      decoration: BoxDecoration(color: Color(0xFF8b0000)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(FormatHelper.formatCurrency(widget.product.productPrice), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                      top: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: ToolsColors.primary,
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.white,
                          //     Colors.white.withOpacity(0.9),
                          //   ],
                          // ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10), // Bo góc dưới bên trái
                            topRight: Radius.circular(10), // Bo góc dưới bên trái
                          ),
                          // border: Border.all(width: 3, color: ToolsColors.primary)

                        ),
                        // child: Row(
                        //   children: [
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //   ],
                        // ),
                      ))
                ],
              ),
            ),
                    ),
          );
      },

    );
  }
}
