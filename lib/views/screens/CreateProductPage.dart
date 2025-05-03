import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/views/screens/widgets/CustomLoaderWidget.dart';
import 'package:url_launcher/url_launcher_string.dart';

// import 'package:ercommerce_ddap/widgets/CustomButtonWIdget.dart';
// import 'package:ercommerce_ddap/widgets/CustomLoaderWidget.dart';
// import 'package:ercommerce_ddap/widgets/CustomTextFieldWidgets.dart';

import '../../services/ContractFactoryServies.dart';

// import '../services/ContractFactoryServies.dart';
// import '../utils/Constants.dart';
import 'package:http/http.dart' as http;

import '../../utils/Constants.dart';
import 'CustomTextFieldWidgets.dart';
import 'nav_screen/widgets/CustomButtonWIdget.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key, required this.walletAddress}) : super(key: key);
  final String walletAddress;
  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  Constants constants = Constants();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String dropMenuValue = "3D";
  String ipfsImageHash = "";

  @override
  void initState() {
    super.initState();
    nameController.text = "Áo Chống Nắng Nam"; // Giá trị tĩnh cho tên sản phẩm
    descriptionController.text =
        "Áo Sơ Mi Dài Tay JAMINE HOUSE Mẫu Trơn Nam Nữ Mặc Được Cá Tính"; // Giá trị tĩnh cho mô tả
    priceController.text = "1000000000000000000"; // Giá trị tĩnh cho giá
  }

  @override
  Widget build(BuildContext context) {
    // var contractFactory = Provider.of<ContractFactoryServies>(context);
    ContractFactoryServies _contractFactoryServies = ContractFactoryServies();

    return Scaffold(
      backgroundColor: constants.mainBGColor,
      appBar: AppBar(
        title: Text("Upload Product To Bloackchain"),
        backgroundColor: constants.mainYellowColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Create Product and Add It to The Blockchain Network",
                style: TextStyle(
                  color: constants.mainBlackColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  customTextFieldWidget(1, "Product Name", nameController),
                  customTextFieldWidget(1, "Product Price", priceController),
                  customTextFieldWidget(
                      4, "Product Description", descriptionController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "Select Category",
                    style: TextStyle(
                      color: constants.mainBlackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: DropdownButton<String>(
                        value: dropMenuValue,
                        items: constants.categoryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropMenuValue = value!;
                          });
                        }),
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    customButtonWidget(() async {
                      await uploadToIPFS().then((value) {
                        setState(() {});
                        if (value["status"] == 'Success') {
                          ipfsImageHash = constants.PINATE_FETCH_IMAGE_URL +
                              value["IpfsHash"];
                        }
                        print(value);
                      });
                    },
                        1,
                        constants.mainRedColor,
                        "Select Image To Added to IPFS",
                        constants.mainWhiteGColor,
                        300),
                    ipfsImageHash != ""
                        ? _contractFactoryServies.productCreatedLoading
                            ? customLoaderWidget()
                            : Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: customButtonWidget(() async {
                                  print(
                                      'contractFactory.myAccount.toString() ${_contractFactoryServies.myAccount.toString()}');

                                  // launchUrlString(contractFactory.uri,
                                  //     mode: LaunchMode.externalApplication);

                                  await _contractFactoryServies.addProduct(
                                      nameController.text,
                                      descriptionController.text,
                                      ipfsImageHash,
                                      priceController.text,
                                      dropMenuValue,
                                      widget.walletAddress,
                                      // _contractFactoryServies.myAccount
                                      //     .toString(),
                                      // '0xe9ec2f28bcbb0650636e6188ed50317227de6fe0',
                                      context);
                                  // await contractFactory.addProduct(
                                  // 'Áo Chống Nắng Nam',
                                  // 'Áo Sơ Mi Dài Tay JAMINE HOUSE Mẫu Trơn Nam Nữ Mặc Được Cá Tính',
                                  // 'https://images.unsplash.com/photo-1618042164219-62c820f10723?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
                                  // '5000000000000000000',
                                  // 'Sport',
                                  //   contractFactory.myAccount.toString(),
                                  // context,
                                  // );
                                },
                                    10,
                                    constants.mainBlackColor,
                                    "Create Product",
                                    constants.mainWhiteGColor,
                                    150),
                              )
                        : Text(
                            "Please wait IPFS HASH UPlaoded",
                            style: TextStyle(color: constants.mainRedColor),
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> uploadToIPFS() async {
    final ImagePicker _picker = ImagePicker();

    XFile? result = await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      try {
        var file = File(result.path!);
        var fileName = '${DateTime.now()}';

        var request = http.MultipartRequest(
            'POST', Uri.parse(constants.PINATE_END_POINT_API));

        //SEND AUTh DATA and Types

        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['pinata_api_key'] = constants.PINATA_API_KEY;
        request.headers['pinata_secret_api_key'] =
            constants.PINATA_API_SECRET_KEY;

        //SEND DATA

        request.fields['name'] = fileName;
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        var response = await request.send();

        final res = await http.Response.fromStream(response);

        print(res);

        if (response.statusCode != 200) {
          return {"status": "Faild", "IpfsHash": "NO HAsh"};
        } else if (response.statusCode == 200) {
          var hash = jsonDecode(res.body);
          return {"status": "Success", "IpfsHash": hash["IpfsHash"].toString()};
        }
      } catch (e) {
        print("Erroe at catch ${e}");
      }
    }

    return {"status": "Success", "IpfsHash": "cjhdgsdnvuy65d786sduhvs7dy"};
  }
}
