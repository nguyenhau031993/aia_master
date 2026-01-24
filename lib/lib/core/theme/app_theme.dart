import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Màu chính: Xanh Navy đậm (Tin cậy, Tài chính)
  static const Color primary = Color(0xFF0F172A); 
  // Màu phụ: Vàng Gold (Thịnh vượng, VIP)
  static const Color accent = Color(0xFFF59E0B); 
  // Màu nền: Xám khói nhẹ
  static const Color background = Color(0xFFF8FAFC);
  // Màu lời/lỗ
  static const Color profit = Color(0xFF10B981); // Xanh lá
  static const Color loss = Color(0xFFEF4444);   // Đỏ
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // Cấu hình Font chữ toàn App (Dùng Manrope hoặc Roboto)
      textTheme: GoogleFonts.manropeTextTheme(),
      
      // Cấu hình thanh App Bar chuẩn hãng lớn
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Cấu hình nút bấm
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent, // Nút màu vàng Gold
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
