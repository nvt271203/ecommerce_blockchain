import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/banner_controller.dart';
import 'package:sales_business_app/controllers/category_controller.dart';
import 'package:sales_business_app/models/category.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/slider_widget.dart';
import '../../../../models/banner.dart';
import '../../../../utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // late Future<List<Category>> futureCategories;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   futureCategories = CategoryController().loadCategories();
  //   print('Hello E-commerce');
  // }

  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    // Tạo danh sách Category từ Constants.categoryList
    // categories = Constants().categoryList.map((categoryName) {
    //   return Category(
    //     id: categoryName.toLowerCase(), // Tạo ID từ tên danh mục
    //     name: categoryName,
    //     image: Constants().imageMoke,// Sử dụng ảnh mặc định từ Constants
    //     banner: '',
    //   );
    // }).toList();
    categories = Constants().categoryList.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value;

      // Lấy ảnh từ categoryImageList, nếu không có thì dùng ảnh mặc định
      final image = index < Constants().categoryImageList.length
          ? Constants().categoryImageList[index]
          : Constants().imageMoke;

      return Category(
        id: categoryName.toLowerCase(), // Tạo ID từ tên danh mục
        name: categoryName,
        image: image, // Gán ảnh tương ứng
        banner: '', // Giữ nguyên banner rỗng
      );
    }).toList();

    print('Hello E-commerce');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Tránh lỗi Overflow
              children: [
                ClipRRect(
                  // borderRadius: BorderRadius.circular(20)
                  // child: Image.network(
                  //   category.image,
                  //   height: 60,
                  //   width: 60,
                  //   fit: BoxFit.cover,
                  // ),
                  child: SvgPicture.asset(
                    category.image,
                    width: 60,
                    height: 60,
                    // colorFilter: ColorFilter.mode(
                    //   Colors.blue, // Tùy chọn đổi màu icon
                    //   BlendMode.srcIn,
                    // ),
                  ),
                ),
                const SizedBox(height: 8), // Khoảng cách giữa ảnh và text
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
