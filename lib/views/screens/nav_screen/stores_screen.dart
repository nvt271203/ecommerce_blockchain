import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/product_controller.dart';
import 'package:sales_business_app/views/screens/CreateProductPage.dart';
import 'package:sales_business_app/views/screens/add_product_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/popular_product_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/product_card_gridview.dart';
import 'package:sales_business_app/views/screens/widgets/button_widget.dart';
import '../../../models/product.dart';
import '../../../services/ContractFactoryServies.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late Future<List<Product>> futureProducts;
  final ContractFactoryServies _contractFactoryServies = ContractFactoryServies();
  String? walletAddress;
  bool isLoading = false; // Biến để kiểm soát trạng thái loading
  String? balance; // Biến lưu số dư ví (nếu cần)

  // @override
  // void initState() {
  //   super.initState();
  //   // Không gọi _checkExistingConnection ngay tại initState để tránh kiểm tra ví không cần thiết
  //   // futureProducts = ProductController().loadPopularProducts();
  // }
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _checkExistingConnection();
      var contractFactory = Provider.of<ContractFactoryServies>(context, listen: false);
      // await contractFactory.saveAccountAddress(widget.account);
      // Phải có dòng này
      //1. lưu trạng thái ví, để từ địa chỉ ví mà lọc đến các hàm như get ra các sản phẩm hiện tại của người dùng.
      await contractFactory.getBalance(walletAddress!);
      // await contractFactory.fetchProductCount(); // Gọi trước
      await contractFactory.getUserProducts(walletAddress!); // Gọi sau
    });
  }
  Future<void> _checkExistingConnection() async {
    setState(() {
      isLoading = true; // Bật loading khi bắt đầu kiểm tra
    });

    final address = await _contractFactoryServies.restoreWalletConnection();
    if (address != null) {
      setState(() {
        walletAddress = address;
        print('walletAddress: $walletAddress');

        // Lấy số dư ví (nếu cần)
        _contractFactoryServies.getBalance(address).then((value) {
          setState(() {
            balance = value;
            print('Số dư ví: $balance');
          });
        });
        isLoading = false; // Tắt loading khi lấy địa chỉ ví thành công
      });
    } else {
      setState(() {
        isLoading = false; // Tắt loading nếu không lấy được địa chỉ ví
      });
      // Có thể hiển thị thông báo lỗi nếu cần
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể kết nối ví. Vui lòng thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var contractFactory = Provider.of<ContractFactoryServies>(context);
    print('contractFactory.allUserProducts.length - ${contractFactory.allUserProducts.length}');

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
              // Nút Add Product với trạng thái loading
              isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ButtonWidget(
                onClick: () async {
                  await _checkExistingConnection(); // Kiểm tra ví khi nhấn nút
                  if (walletAddress != null) {
                    // Chỉ điều hướng nếu lấy được địa chỉ ví
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateProductPage(walletAddress: walletAddress!,)),
                    );
                  }
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
              // PopularProductWidget(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: ListView.builder(
                      itemCount: contractFactory.allUserProducts.length,
                      itemBuilder: (context, index) {
                        return customProductCardWidget(
                            context,
                            contractFactory.allUserProducts[index].image,
                            contractFactory.allUserProducts[index].name,
                            contractFactory.allUserProducts[index].price
                                .toString(),
                            contractFactory.allUserProducts[index]);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}