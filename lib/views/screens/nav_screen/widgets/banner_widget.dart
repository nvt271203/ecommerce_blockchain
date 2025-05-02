import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/banner_controller.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/slider_widget.dart';
import '../../../../models/banner.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  // late Future<List<BannerModel>> futureBanners;
  final List<String> bannerImages =
  [
    'assets/images/bg_1.jpg',
    'assets/images/bg_2.jpg',
    'assets/images/bg_3.jpg',
    'assets/images/bg_4.jpg',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureBanners = BannerController().loadBanners();
    print('Hello E-commerce');
  }

  @override
  Widget build(BuildContext context) {
    return SliderWidget(imgList: bannerImages);


    //   FutureBuilder(
    //   future: futureBanners,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return Center(
    //         child: Text('Error: ${snapshot.error}'),
    //       );
    //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //       return Center(
    //         child: Text('No banners'),
    //       );
    //     } else {
    //       final banners = snapshot.data!;
    //       final List<String> bannerImages = banners.map((banner) => banner.image).toList();
    //       return SliderWidget(imgList: bannerImages);
    //     }
    //   },
    // );
  }
}
