import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletService {
  Web3App? walletConnect;
  String? walletAddress;
  SignClient? signClient;
  WalletService() {
    _initWalletConnect();
  }

  /// Khởi tạo WalletConnect v2
  Future<void> _initWalletConnect() async {
    // walletConnect = await Web3App.createInstance(
    //   projectId: 'efcf5208c219e194a465a38b7aa101d8', // Thay bằng Project ID của bạn từ WalletConnect
    //   metadata: PairingMetadata(
    //     name: 'My Web3 App',
    //     description: 'Ứng dụng kết nối với MetaMask',
    //     url: 'https://myweb3app.com',
    //     icons: ['https://myweb3app.com/icon.png'],
    //   ),
    // );
    signClient = await SignClient.createInstance(
      projectId: "efcf5208c219e194a465a38b7aa101d8",
      relayUrl: "wss://relay.walletconnect.com",
      metadata: PairingMetadata(
        name: "Woo Store",
        description: "Decentralized mobile app with Flutter",
        url: "https://coodes.org",
        icons: ["https://coodes.org/wp-content/uploads/2020/07/ic.png"],
      ),
    );
    // Lắng nghe sự kiện kết nối
    signClient?.onSessionConnect.subscribe((session) {
      walletAddress = _getWalletAddress(session as SessionData);
      print("✅ Đã kết nối: $walletAddress");
    });

    // Lắng nghe sự kiện ngắt kết nối
    signClient?.onSessionDelete.subscribe((_) {
      print("❌ Đã ngắt kết nối");
      walletAddress = null;
    });
  }

  /// Hàm lấy địa chỉ ví từ SessionData WalletConnect v2
  String? _getWalletAddress(SessionData session) {
    var accounts = session.namespaces["eip155"]?.accounts;
    if (accounts != null && accounts.isNotEmpty) {
      // Định dạng account: "eip155:1:0xABC123..."
      return accounts.first.split(":")[2];
    }
    return null;
  }

  /// Hàm kết nối với MetaMask
  Future<String?> connectWallet() async {
    // if (walletConnect == null) return null;
    //
    // try {
    //   final connection = await walletConnect!.connect(
    //     requiredNamespaces: {
    //       'eip155': RequiredNamespace(
    //         chains: ['eip155:1'], // Ethereum Mainnet
    //         methods: ['eth_sendTransaction', 'personal_sign'],
    //         events: ['chainChanged', 'accountsChanged'],
    //       ),
    //     },
    //   );
    //
    //   // Lấy SessionData từ AsyncCompleter thông qua .future
    //   final sessionData = await connection.session.future;
    //   walletAddress = _getWalletAddress(sessionData);
    //   print("✅ Kết nối thành công: $walletAddress");
    //   return walletAddress;
    // } catch (e) {
    //   print("❌ Lỗi khi kết nối: $e");
    //   return null;
    // }
  }


  /// Ngắt kết nối ví bằng disconnectSession()
  // Future<void> disconnectWallet() async {
  //   if (walletConnect != null) {
  //     // Lấy danh sách các phiên kết nối đang hoạt động (Map<String, SessionData>)
  //     final sessions = walletConnect!.getActiveSessions();
  //     if (sessions.isNotEmpty) {
  //       // Lấy phần tử đầu tiên từ giá trị của Map
  //       final topic = sessions.values.first.topic;
  //       await walletConnect!.disconnectSession(
  //         topic: topic,
  //         reason: {"code": 6000, "message": "User disconnected"},
  //       );
  //       walletAddress = null;
  //       print("❌ Đã ngắt kết nối");
  //     }
  //   }
  // }


  /// Kiểm tra trạng thái kết nối
  bool isConnected() {
    return walletAddress != null;
  }
}
