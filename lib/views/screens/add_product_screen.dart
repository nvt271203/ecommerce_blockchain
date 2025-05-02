import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_business_app/controllers/category_controller.dart';
import 'package:sales_business_app/controllers/product_controller.dart';
import 'package:sales_business_app/controllers/subcategory_controller.dart';
import 'package:sales_business_app/providers/user_provider.dart';
import 'package:sales_business_app/views/screens/widgets/button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category.dart';
import '../../models/subcategory.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;

  Future<List<SubCategory>>? futureSubCategories;
  SubCategory? selectedSubCategory;

  late String productName = '';
  late int productPrice = 0;
  late int quantity = 0;
  late String description = '';
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
    // futureSubCategories = Future.value([]); // Khởi tạo tránh lỗi null
  }

  getSubcategoriesByCategory(Category category) {
    futureSubCategories =
        SubCategoryController().getSubCategoriesByCategoryName(category.name);
  }

  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('No image Picked');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Product')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: images.length > 0
                        ? Image.file(images[0], fit: BoxFit.cover)
                        : Center(child: Text('Image Product Null'))),
                ButtonWidget(
                    onClick: chooseImage,
                    title: 'Upload Image Product',
                    icon: Icons.upload_file,
                    colorTitle: Colors.white,
                    colorBackground: Colors.lightBlueAccent),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Product Name',
                    hintText: 'Enter Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product Name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    productName = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: FutureBuilder(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Categories'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<Category>(
                            value: selectedCategory,
                            hint: Text('Select Category'),
                            isExpanded: true,
                            items: snapshot.data!.map((Category category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                              getSubcategoriesByCategory(selectedCategory!);
                              selectedSubCategory =
                                  null; // Reset danh mục con sau khi chọn danh mục cha để tránh lỗi
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: FutureBuilder(
                    future: futureSubCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No SubCategories'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<SubCategory>(
                            value: selectedSubCategory,
                            hint: Text('Select SubCategory'),
                            isExpanded: true,
                            items:
                                snapshot.data!.map((SubCategory subCategory) {
                              return DropdownMenuItem(
                                value: subCategory,
                                child: Text(subCategory.subCategoryName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSubCategory = value;
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Price',
                        hintText: 'Enter Product Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Product Price';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        productPrice = int.parse(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Quantity',
                        hintText: 'Enter Product Quantity',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Product Quantity';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                    ),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Enter Product Description',
                    hintText: 'Enter Product Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product Description';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    description = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                        onClick: () {},
                        title: 'Reset',
                        icon: Icons.restart_alt,
                        colorTitle: Colors.white,
                        colorBackground: Colors.red),
                    isLoading ? CircularProgressIndicator() :
                    ButtonWidget(
                        onClick: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            final fullName = ref.read(userProvider)!.fullName;
                            final vendorId = ref.read(userProvider)!.id;

                            // print('productName - ' +productName);
                            // print('productPrice - ' +productPrice.toString());
                            // print('quantity - ' +quantity.toString());
                            // print('description - ' +description);
                            // print('selectedCategory - ' + selectedCategory!.name);
                            // print('vendorId - ' +vendorId);
                            // print('fullName - ' +fullName);
                            // print('selectedSubCategory - ' +selectedSubCategory!.subCategoryName);
                            // print('images - ' +images.length.toString());

                            try {
                              await _productController.uploadProduct(
                                productName: productName,
                                productPrice: productPrice,
                                quantity: quantity,
                                description: description,
                                category: selectedCategory!.name,
                                vendorId: vendorId,
                                fullName: fullName,
                                subCategory: selectedSubCategory!.subCategoryName,
                                pickedImages: images,
                                context: context,
                              );
                              // Nếu thành công, quay lại màn hình trước
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print("Lỗi khi tải sản phẩm: $e");
                            } finally {
                              setState(() {
                                isLoading = false;
                                _formKey.currentState!.reset();
                                selectedCategory = null;
                                selectedSubCategory = null;
                                images.clear();
                              });
                            }


                          }
                        },
                        title: 'Save',
                        icon: Icons.check_circle,
                        colorTitle: Colors.white,
                        colorBackground: Colors.blue),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
