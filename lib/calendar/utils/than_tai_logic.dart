import 'dart:math';

class ThanTaiLogic {
  // Xin số Vietlott (6/45 hoặc 6/55)
  static List<int> laySoVietlott(int limit) {
    final random = Random();
    final Set<int> boSo = {};
    
    // Random cho đến khi đủ 6 số không trùng nhau
    while (boSo.length < 6) {
      // +1 vì random từ 0->(limit-1)
      boSo.add(random.nextInt(limit) + 1);
    }
    
    // Sắp xếp tăng dần cho đẹp
    final List<int> ketQua = boSo.toList()..sort();
    return ketQua;
  }

  // Xin số Kiến thiết (5 chữ số)
  static String laySoKienThiet() {
    final random = Random();
    String ketQua = "";
    for (int i = 0; i < 5; i++) {
      ketQua += random.nextInt(10).toString();
    }
    return ketQua;
  }
}
