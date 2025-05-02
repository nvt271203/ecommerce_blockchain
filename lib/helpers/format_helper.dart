import 'package:intl/intl.dart'; // Thêm thư viện định dạng số

class FormatHelper {
  static String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)} đ";
  }
}