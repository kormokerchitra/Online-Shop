import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  int discountAmt = 0;
  String userInfo = "";

  int getProductDiscount(String total, String percent) {
    int discountPercent = int.parse(percent);
    double totalPrice = double.parse(total);
    if (discountPercent > 0) {
      double amt = totalPrice * (discountPercent / 100);
      double totalAmt = totalPrice - amt;
      discountAmt = totalAmt.round();
    }

    return discountAmt;
  }
}
