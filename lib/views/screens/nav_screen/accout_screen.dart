import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_business_app/helpers/custom_helper.dart';
import 'package:sales_business_app/providers/user_provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';

class AccoutScreen extends StatefulWidget {
  const AccoutScreen({super.key});

  @override
  State<AccoutScreen> createState() => _AccoutScreenState();
}

class _AccoutScreenState extends State<AccoutScreen> {
  final String userName = 'Khách';
  String profileImage = 'assets/images/anynomus.jpg';
  final String defaultWalletAddress = '0x1234...5678';
  String balance = '0.0 ETH';

  String? chainName;
  String? walletAddress;
  bool isLoading = true; // Thêm biến trạng thái loading
  final ContractFactoryServies _contractFactoryServies = ContractFactoryServies();

  void connectWallet() async {
    setState(() {
      isLoading = true; // Bật loading khi kết nối ví
    });
    await _contractFactoryServies.onWalletConnect().then((value) async {
      print('_contractFactoryServies - ${_contractFactoryServies.chain}');
      if (value != null) {
        setState(() {
          chainName = _contractFactoryServies.chain.chainId.split(':')[0];
          walletAddress = value;
          profileImage = 'assets/images/avt.jpg';

          // lấy ra số dư ví
          // balance = await _contractFactoryServies.getBalance();// Cập nhật ảnh khi kết nối thành công
          _contractFactoryServies.getBalance(walletAddress.toString()).then((value) {
            setState(() {
              balance = value;
              print('So du vi - ${balance}');
            });
          });
          isLoading = false; // Tắt loading
        });
      } else {
        setState(() {
          isLoading = false; // Tắt loading nếu không có giá trị trả về
        });
      }
    });
  }
  void disconnectWallet() async {
    await _contractFactoryServies.disconnect(); // Gọi hàm ngắt kết nối của WalletConnect
    setState(() {
      walletAddress = null;
      balance = '0.0 ETH';
      profileImage = 'assets/images/anynomus.jpg';
    });
    debugPrint("Wallet Disconnected");
  }

  @override
  void initState() {
    super.initState();
    _checkExistingConnection(); // Kiểm tra kết nối khi khởi tạo
  }

  Future<void> _checkExistingConnection() async {
    final address = await _contractFactoryServies.restoreWalletConnection();
    setState(() async {
      if (address != null) {
        chainName = _contractFactoryServies.chain.chainId.split(':')[0];
        walletAddress = address;
        profileImage = 'assets/images/avt.jpg'; // Cập nhật ảnh nếu có kết nối

        // lấy số dư ví
        // Lấy số dư ví với address
        _contractFactoryServies.getBalance(address).then((value) {
          setState(() {
            balance = value;
            print('So du vi - ${balance}');
          });
        });
      }
      isLoading = false; // Tắt loading sau khi kiểm tra xong
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.black,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    connectWallet();
                  },
                  icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                  label: const Text(
                    'Kết nối ví MetaMask',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      isLoading
                          ? const SizedBox(
                        height: 140, // Chiều cao bằng 2 * radius của CircleAvatar
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                          : CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(profileImage),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.black,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Địa chỉ ví: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: isLoading
                                  ? const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                                  : Text(
                                walletAddress ?? defaultWalletAddress,
                                style: TextStyle(
                                  color: walletAddress != null
                                      ? CustomHelper.primary
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: const Icon(
                                Icons.monetization_on,
                                color: Colors.black,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Số dư: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      text: balance,
                                      style: TextStyle(
                                        color: CustomHelper.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Thêm logic để làm mới số dư ở đây
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // await ref.read(userProvider.notifier).logout();

                      disconnectWallet();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 1:
        return Icons.account_balance_wallet;
      case 2:
        return Icons.monetization_on;
      default:
        return Icons.info;
    }
  }
}