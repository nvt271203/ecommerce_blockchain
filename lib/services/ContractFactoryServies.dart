import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../utils/Constants.dart';
import '../utils/Preference.dart';
import '../wallet_services/config/crypto/eip155.dart';
import '../wallet_services/config/models/chain_metadata.dart';
import 'Models/ProductModel.dart';

import 'package:url_launcher/url_launcher.dart';

class ContractFactoryServies extends ChangeNotifier {
  Constants constants = Constants();

  // start----Get all product.
  BigInt? _productCount;
  String? storeName;
  String? myAccount;
  DeployedContract? _contract;
  bool storeNameLoading = true;
  List<ProductModel> allProducts = [];
  List<ProductModel> allUserProducts = [];

  bool storeProductsLoading = true;

  String? _abiCode;
  EthereumAddress? _contractAddress;


  // end -----Get all product.


  //99999999999999999999999999999
  SessionData? sessionData;
  Web3App? web3App;
  //
  ChainMetadata chain = const ChainMetadata(
    type: ChainTypeEnum.eip155,
    chainId: 'eip155:11155111',
    name: 'Sepolia Testnet',
    logo: '',
    color: Colors.transparent,
    isTestnet: true,
    rpc: ['https://sepolia.infura.io/v3/80bf8f251e6b4d468a47a90985640a64'],
  );

  // //SHARE DATA
  // String? storeName;
  // String? myAccount;
  // bool storeNameLoading = true;
  // bool storeProductsLoading = true;
  // bool productCreatedLoading = false;
  //
  String? myBalance;
  bool productCreatedLoading = false;  // add product


  //
  // List<ProductModel> allProducts = [];
  // List<ProductModel> categoryProducts = [];
  // List<ProductModel> allUserProducts = [];
  //
  // //1-Connect to blockchain Network(https/websocktio/web3dart)
  //
  Web3Client? _cleint;
  // String? _abiCode;
  // EthereumAddress? _contractAddress;
  // DeployedContract? _contract;
  // BigInt? _productCount;
  //
  // Web3Client? _client;
  // SignClient? signClient;
  // SessionData? session;
  //
  // var uri;

  ContractFactoryServies() {
    _setUpNetwork();
    // _initWalletConnect().then((_) {
    //   print("WalletConnect đã khởi tạo xong!");
    // });
  }

  _setUpNetwork() async {
    _cleint =
        Web3Client(constants.NETWORK_HTTPS_RPC, Client(), socketConnector: () {
          return IOWebSocketChannel.connect(constants.NETWORK_WSS_RPC)
              .cast<String>();
        });

    // start----
    await _fetchABIAndContractAdrress();
    await _getDeployedContract();
    // end -----
  }
  Future<void> _fetchABIAndContractAdrress() async {
    // Thêm abis ở assets vào
    // Thêm constract ở . vào

    String abiFileRoot =
    await rootBundle.loadString(constants.CONTRACT_ABI_PATH);
    var abiJsonFormat = jsonDecode(abiFileRoot);
    _abiCode = jsonEncode(abiJsonFormat["abi"]);
    //Get Address
    _contractAddress = EthereumAddress.fromHex(constants.CONTRACT_ADDRESS);
  }
  Future<void> _getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "MarketplaceProducts"),
        _contractAddress!);
    print('_contract ${_contract!.address.toString()}');
    print('_contract ${_contract!.abi.name}');
    await _getStoreName();
    await _getStoreProductCount();
    await _getAllProducts();
  }

  Future<void> _initWallet() async {
    //QUan trọng, phải có cái này, ko có là lỗi
    await Preference.shared
        .init(); // Đảm bảo SharedPreferences đã được khởi tạo
    //-----------------------------------------

    String? prefSessionData =
        Preference.shared.getString(Preference.sessionData);

    if (prefSessionData != null && prefSessionData.isNotEmpty) {
      try {
        var decodedData = jsonDecode(prefSessionData);

        if (decodedData is Map<String, dynamic>) {
          sessionData = SessionData.fromJson(decodedData);
        } else {
          debugPrint("Lỗi: Dữ liệu session không phải Map<String, dynamic>");
          sessionData = null;
        }
      } catch (e) {
        debugPrint("Lỗi parse sessionData: $e");
        sessionData = null;
      }
    } else {
      sessionData = null;
    }

    web3App = await Web3App.createInstance(
      projectId: '9b33a43d15958fe96e9e2035a2f323fc',
      metadata: const PairingMetadata(
        name: 'Ecommerce Dapp',
        description: 'The Ecommerce dapp',
        url: 'https://www.magicclub.io/',
        icons: [
          'https://firebasestorage.googleapis.com/v0/b/magic-club-dev-20a01.appspot.com/o/app_logo.png?alt=media&token=7f819657-cf78-441c-8294-ce1fbaf31580&_gl=1*1ruy4yv*_ga*MjU4NjA5MzQuMTY2MDY0MzgwMg..*_ga_CW55HF8NVT*MTY4NTUyODkwOS4xOS4xLjE2ODU1MjkxMTQuMC4wLjA.'
        ],
      ),
    );

    web3App?.onSessionUpdate.subscribe((args) {
      debugPrint("onSessionUpdate: ${args}");
    });

    web3App?.registerEventHandler(
        chainId: chain.chainId, event: EIP155.events.values.toList()[0]);

    web3App?.onSessionPing.subscribe(_onSessionPing);
    web3App?.onSessionEvent.subscribe(_onSessionEvent);
  }

  void _onSessionPing(SessionPing? args) {
    // Utils.showToast(Get.context!, 'Received Ping :::: ${args!.topic}');

    debugPrint("_onSessionPing$args");
  }

  void _onSessionEvent(SessionEvent? args) {
    // Utils.showToast(Get.context!,'Received Ping :::: Topic: ${args!.topic}\nEvent Name: ${args.name}\nEvent Data: ${args.data}');
    debugPrint("_onSessionEvent$args");
  }

  Future<String?> onWalletConnect() async {
    // await Future.delayed(Duration(seconds: 1));
    print('-----------------------------------');
    try {
      await _initWallet();
    } catch (e) {
      print("⚠️ Lỗi trong onWalletConnect: $e");
    }

    final Map<String, RequiredNamespace> requiredNamespaces = {};

    final String chainName = chain.chainId.split(':')[0];
    if (requiredNamespaces.containsKey(chainName)) {
      requiredNamespaces[chainName]!.chains!.add(chain.chainId);
    }
    final RequiredNamespace rNamespace = RequiredNamespace(
      chains: [chain.chainId],
      methods: EIP155.methods.values.toList(),
      events: EIP155.events.values.toList(),
    );
    requiredNamespaces[chainName] = rNamespace;

    debugPrint('Required namespaces:' '$requiredNamespaces');

    final ConnectResponse res = await web3App!.connect(
      requiredNamespaces: requiredNamespaces,
    );

    debugPrint("ConnectResponse" "$res");

    /// NAVIGATE URL INTO THE WALLET
    debugPrint("URI ${res.uri}");
    await moveToWalletApp(res.uri);

    try {
      sessionData = await res.session.future;
      print('Data Session after connect - ${sessionData}');
      print('------------------------------------------------');
      await Preference.shared
          .setString(Preference.sessionData, jsonEncode(sessionData));

      debugPrint("sessionData${sessionData?.toJson()}");

      var walletAddress =
          (sessionData?.namespaces[chainName]?.accounts.first ?? "")
              .split(":")
              .last;

      // WalletConnectSecureStorage().store(WalletConnectSession(
      //     accounts: sessionData?.namespaces[chainName]?.accounts ?? []));

      debugPrint("WALLET-ADDRESS FROM WALLET$walletAddress");
      this.myAccount = walletAddress.toString();
      return walletAddress;
    } catch (e) {
      debugPrint('Exexption: $e');
    }

    return null;
  }
  Future<void> moveToWalletApp(Uri? uri) async {
    if (uri == null) {
      debugPrint("URI is null, cannot launch wallet app");
      return;
    }
    Preference.shared.setString(Preference.connectionURL, uri.toString());
    debugPrint("Launching URL: $uri");
    bool isLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!isLaunch) {
      debugPrint("Failed to launch URL: $uri");
      throw 'Failure - Could not open URL $uri.';
    } else {
      debugPrint("Successfully launched URL, waiting for wallet response");
    }
    notifyListeners();
  }

// Thêm một phương thức để kiểm tra và khôi phục kết nối từ dữ liệu phiên đã lưu:
  Future<String?> restoreWalletConnection() async {
    await _initWallet(); // Khởi tạo web3App và kiểm tra sessionData từ SharedPreferences

    if (sessionData != null) {
      // Kiểm tra xem phiên có còn hợp lệ không
      final String chainName = chain.chainId.split(':')[0];
      var walletAddress = (sessionData?.namespaces[chainName]?.accounts.first ?? "").split(":").last;

      if (walletAddress.isNotEmpty) {
        debugPrint("Khôi phục kết nối ví thành công: $walletAddress");
        return walletAddress;
      } else {
        debugPrint("Phiên đã lưu không hợp lệ, cần kết nối lại.");
        sessionData = null;
        await Preference.shared.remove(Preference.sessionData);
      }
    }
    return null;
  }

  Future<void> disconnect() async {
    if (sessionData != null) {
      try {
        await web3App?.disconnectSession(
          topic: sessionData!.topic,
          reason: WalletConnectError(
            code: 6000, // Mã lỗi tuỳ chỉnh, bạn có thể đặt mã khác
            message: "User disconnected the wallet",
          ),
        );
        sessionData = null; // Xóa dữ liệu phiên kết nối
        await Preference.shared
            .remove(Preference.sessionData); // Xóa dữ liệu lưu trữ

        debugPrint("Wallet disconnected successfully");
      } catch (e) {
        debugPrint("Error disconnecting wallet: $e");
      }
    } else {
      debugPrint("No active wallet connection to disconnect.");
    }
  }
  // Hàm lấy số dư với tham số địa chỉ ví
  Future<String> getBalance(String address) async {
    if (_cleint == null) {
      debugPrint("Web3Client chưa được khởi tạo.");
      return "Web3Client not create 0.0 ETH";
    }

    try {
      // Chuyển đổi địa chỉ ví thành EthereumAddress
      final EthereumAddress ethAddress = EthereumAddress.fromHex(address);

      // Lấy số dư từ blockchain
      final EtherAmount balance = await _cleint!.getBalance(ethAddress);

      // Chuyển đổi từ Wei sang Ether
      final double balanceInEther = balance.getValueInUnit(EtherUnit.ether);
      myBalance = balanceInEther.toStringAsFixed(4); // Làm tròn đến 4 chữ số thập phân

      debugPrint("Số dư của $address: $myBalance ETH");
      notifyListeners();

      return "$myBalance ETH";
    } catch (e) {
      debugPrint("Lỗi khi lấy số dư: $e");
      return "Error get getBalance ETH";
    }
  }


//-----------------------------GET COUNT AND GET DATA LIST PRODUCTS BLOCKCHAIN-----------------------------------------------------------------------------------------------------------------------------
  //3-Fetch All Functions and Data
//GET STORE NAME FROM BLOCKCHAIN
  _getStoreName() async {

    List<dynamic> storeData = await _cleint!.call(
        contract: _contract!,
        function: _contract!.function("storeName"),
        params: []);

    if (storeData[0].length > 0) {
      storeName = storeData[0];

      storeNameLoading = false;
    } else {
      storeNameLoading = true;
    }
    notifyListeners();
  }

//GET STORE PRODUCT COUT FROM BLOCKCHAIN
  _getStoreProductCount() async {
    List<dynamic> storeData = await _cleint!.call(
        contract: _contract!,
        function: _contract!.function("count"),
        params: []);

    _productCount = storeData[0];
    print("THE PRODUCT COUNT IS ${_productCount}");
    notifyListeners();
  }

  //GET ALL PRODUCTs DATA FROM BLOCKCHAIN
  _getAllProducts() async {
    try {
      int count = int.parse(_productCount.toString());
      allProducts.clear();
      for (int i = 1; i <= count; i++) {
        List<dynamic> product = await _cleint!.call(
          contract: _contract!,
          function: _contract!.function("storeProducts"),
          params: [BigInt.from(i)],
        );

        if (product[4] != true) {
          ProductModel productModel = ProductModel(
            id: product[0],
            name: product[1],
            description: product[2],
            image: product[3],
            sold: product[4],
            owner: product[5],
            price: product[6],
            category: product[7],
          );
          print('product.toString(); + ${productModel.toString()}');

          allProducts.add(productModel);
        }
      }
      storeProductsLoading = false;
      print("Số lượng sản phẩm thực tế: ${allProducts.length}"); // Thêm dòng này
    } catch (e) {
      storeProductsLoading = true;
      print("Lỗi khi lấy sản phẩm: $e"); // Debug lỗi
    }
    notifyListeners();
  }


  // saveAccountAddress(String account) {
  //   myAccount = account;
  //   notifyListeners();
  // }




  //==========================================ADD PRODUCT ==========================================
  //string  memory name,string memory description, string memory image,uint price, string  memory category

  //1-Create Web3 client connect with create product func
  //2-Create cridentials from conncetor provider
  //3-Test this function with Static data
  //4-Connect all use inputs with image at ipfs and sedn with wallet
  //5-work with Create product event and take action after this event
  addProduct(
      String name,
      String description,
      String image,
      String price,
      String category,
      String account,
      BuildContext context,
      ) async {

    if (myAccount == null) {
      String? walletAccount = await onWalletConnect();
      if (walletAccount == null) {
        print("⚠️ Không thể kết nối với ví - myAccount - ");
        print("⚠️ Không thể kết nối với ví - ");


        print("⚠️ Không thể kết nối với ví.");
        return;
      }
      saveAccountAddress(walletAccount);
    }

    // 🔹 Kiểm tra session có tồn tại không
    final sessions = web3App!.sessions.getAll();
    if (sessions.isEmpty) {
      print("⚠️ Không tìm thấy session hoạt động!");
      return;
    }
    final session = sessions.first; // Chọn session đầu tiên

    // 🔹 Mã hóa dữ liệu giao dịch (ABI Encoding)
    final function = _contract!.function("createProduct");
    final encodedData = function.encodeCall([
      name,
      description,
      image,
      BigInt.parse(price),
      category,
    ]);

    // 🔹 Chuẩn bị dữ liệu giao dịch
    final txData = {
      "from": account,
      "to": _contract!.address.hex,
      "data": "0x${hex.encode(encodedData)}",
    };

    // 🔹 Ký và gửi giao dịch bằng WalletConnect V2
    try {
      final result = await web3App!.request(
        topic: session.topic,
        chainId: 'eip155:${constants.CHAIN_ID}', // Chain ID của blockchain
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [txData],
        ),
      );

      print("✅ Giao dịch thành công: $result");
      await _setUpNetwork();
      // await _getStoreName();
      // await _getStoreProductCount();
      // await _getAllProducts();
      // Đợi giao dịch được xác nhận
      // await _waitForTransactionConfirmation(result);



      // Gọi _getAllProducts() ngay sau khi giao dịch thành công
      print("Danh sách sản phẩm đã được cập nhật: ${allProducts.length} sản phẩm");
      await _getAllProducts();

      notifyListeners();

    } catch (error) {
      print("❌ Lỗi khi gửi giao dịch: $error");
    }

    fetchProductCreatedEvent(context);
    // notifyListeners();
  }

  Future<void> _waitForTransactionConfirmation(String transactionHash) async {
    if (_cleint == null) {
      throw Exception("Web3Client chưa được khởi tạo.");
    }

    print("Đang đợi giao dịch $transactionHash được xác nhận...");
    TransactionReceipt? receipt;
    while (receipt == null) {
      receipt = await _cleint!.getTransactionReceipt(transactionHash);
      if (receipt == null) {
        await Future.delayed(Duration(seconds: 2)); // Đợi 2 giây trước khi thử lại
      }
    }
    print("Giao dịch $transactionHash đã được xác nhận trong block ${receipt.blockNumber}");
  }


  //Create Product Event
  fetchProductCreatedEvent(context) async {
    _cleint!
        .events(FilterOptions.events(
        contract: _contract!, event: _contract!.event("CreatedProduct")))
        .take(1)
        .listen((event) async {
      print("event of Create Product ${event}");
      if (event.transactionHash!.isNotEmpty) {
        productCreatedLoading = false;
        print('Đã chạy vào đây ');
        // Cập nhật lại danh sách sản phẩm
        await _getAllProducts(); // Làm mới allProducts
        print("Danh sách sản phẩm đã được cập nhật: ${allProducts.length} sản phẩm");
        notifyListeners();

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             AccountProfilePage(account: myAccount.toString())));
      }
    });
  }
  saveAccountAddress(String account) {
    myAccount = account;
    notifyListeners();
  }


  // -------------------BUY PRODUCT-----------------------------------------------------
  buyProduct(BigInt id, String account, BigInt amount) async {
    // if (_contract == null) {
    //   print("⚠️ Lỗi: Hợp đồng thông minh chưa được khởi tạo!");
    //   return;
    // }
    //
    // if (web3App == null) {
    //   print("⚠️ Lỗi: web3App chưa được khởi tạo!");
    //   return;
    // }

    if (myAccount == null) {
      String? walletAccount = await onWalletConnect();
      if (walletAccount == null) {
        print("⚠️ Không thể kết nối với ví.");
        return;
      }
      saveAccountAddress(walletAccount);
    }

    // 🔹 Kiểm tra session có tồn tại không
    final sessions = web3App!.sessions.getAll();
    if (sessions.isEmpty) {
      print("⚠️ Không tìm thấy session hoạt động!");
      return;
    }
    final session = sessions.first; // Chọn session đầu tiên

    // 🔹 Mã hóa dữ liệu giao dịch (ABI Encoding)
    final function = _contract!.function("buyProduct");
    final encodedData = function.encodeCall([id]);

    // 🔹 Chuẩn bị dữ liệu giao dịch
    final txData = {
      "from": account,
      "to": _contract!.address.hex,
      "data": "0x${hex.encode(encodedData)}",
      "value": "0x${amount.toRadixString(16)}", // Số tiền gửi đi (ETH)
    };


    // 🔹 Ký và gửi giao dịch bằng WalletConnect V2
    try {
      final result = await web3App!.request(
        topic: session.topic,
        chainId: 'eip155:${constants.CHAIN_ID}', // Chain ID của blockchain
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [txData],
        ),
      );

      print("✅ Giao dịch mua sản phẩm thành công: $result");
    } catch (error) {
      print("❌ Lỗi khi gửi giao dịch: $error");
    }

    notifyListeners();
  }
  // ----------------GET PRODUCT USER-----------------------
  getUserProducts(String addressWallet) async {
    try {
      int count = int.parse(_productCount.toString());
      print('conut number allproduct: $count');
      allUserProducts.clear();

      print('My Accout: ${myAccount.toString()}');
      // print('My Accout: ${.toString()}');

      for (int i = 1; i <= count; i++) {
        List<dynamic> product = await _cleint!.call(
          contract: _contract!,
          function: _contract!.function("storeProducts"),
          params: [BigInt.from(i)],
        );

        print("Dữ liệu sản phẩm [$i]: $product");

        // if (product.isNotEmpty && product[5].toString() == myAccount.toString()) {
        if (product.isNotEmpty && product[5].toString() == addressWallet) {
          allUserProducts.add(ProductModel(
            id: product[0],
            name: product[1],
            description: product[2],
            image: product[3],
            sold: product[4],
            owner: product[5],
            price: product[6],
            category: product[7],
          ));
          print("Dữ liệu sản phẩm length[$i]: ${allUserProducts.length}");

        }
      }
      storeProductsLoading = false;
    } catch (e) {
      storeProductsLoading = true;
      print("Lỗi khi tải sản phẩm: $e"); // Thêm dòng này để debug lỗi
    }
    notifyListeners();
  }
}
