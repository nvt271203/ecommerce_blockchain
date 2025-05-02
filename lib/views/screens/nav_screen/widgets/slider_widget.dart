// import 'package:chat_dating_app/models/Person.dart';
// import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

// import '../item_detail_user.dart';

class SliderWidget extends StatefulWidget {
  // const SliderHome({super.key, required this.personList});
  const SliderWidget({super.key,required this.imgList, });
  final List<String> imgList;
  // final List<Person> personList;

  @override
  State<SliderWidget> createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderWidget> {
  int myCurrentIndex = 0;
  // final List<String> imgList = [
  //   'assets/images/bg_primary.jpg',
  //   'assets/images/background.jpg',
  //   'assets/images/bg_primary.jpg',
  // ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print('screenWidth - ${screenWidth}');

    return Column(
      children: [
        // Header Section
        Container(
          // margin: screenWidth > 600 ? null : const EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // ToolsColors.primary,
                Colors.black,
                Colors.white,
              ],
            ),
            borderRadius: screenWidth > 600
                ? BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Featured',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(Icons.arrow_right_alt,size: 30,)
            ],
          ),
        ),
        SizedBox(height: 20),

        // Carousel Slider Section
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                height: screenWidth < 600 ? 170 : null,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    myCurrentIndex = index;
                  });
                },
                viewportFraction: screenWidth > 600 ? 0.3 : 0.7,
                // Adjust for large screens
                scrollPhysics: BouncingScrollPhysics(),
              ),
              // items: imgList.map((item) {
              items: widget.imgList.map((item) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    // onTap: () => _navigatorDetailUser(context, person),
                    onTap: () {},
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: FadeInImage(

                            // placeholder: MemoryImage(kTransparentImage),
                            // image: NetworkImage(item),
                            // // image: AssetImage(item),
                            // fit: BoxFit.cover,
                            // width: double.infinity,
                            // alignment: Alignment.center,
                            placeholder: MemoryImage(kTransparentImage), // Giữ nguyên placeholder
                            image: AssetImage(item),     // Dùng AssetImage thay vì NetworkImage
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200, // Thêm chiều cao để giới hạn kích thước
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),

        // Indicator Section
        AnimatedSmoothIndicator(
          activeIndex: myCurrentIndex,
          count: widget.imgList.length,
          effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 7,
              dotColor: Colors.grey,
              activeDotColor: Colors.black,
              paintStyle: PaintingStyle.fill),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // void _navigatorDetailUser(BuildContext context, Person person) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => ItemDetailUser(
  //       person: person,
  //       showBar: true,
  //     ),
  //   ));
  // }
}
