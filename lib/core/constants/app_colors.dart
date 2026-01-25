import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // 1. MÀU CHỦ ĐẠO (BRAND COLORS)
  // ===========================================================================
  
  // Xanh Navy Đậm: Dùng cho AppBar, Nút bấm chính, BottomBar active
  // Mang cảm giác tin cậy, chuyên nghiệp (Tài chính)
  static const Color primary = Color(0xFF0F172A); 

  // Vàng Gold: Dùng cho Icon nổi bật, Thần tài, Điểm nhấn
  static const Color accent = Color(0xFFF59E0B);

  // ===========================================================================
  // 2. MÀU NỀN (BACKGROUND)
  // ===========================================================================
  
  // Màu nền chính của toàn bộ màn hình (Xám rất nhạt, dịu mắt)
  static const Color scaffoldBackground = Color(0xFFF1F5F9); // Hoặc 0xFFF8FAFC
  
  // Màu nền của các Khối/Thẻ (Card) (Trắng tinh)
  static const Color cardBackground = Colors.white;

  // ===========================================================================
  // 3. MÀU TRẠNG THÁI (STATUS COLORS)
  // ===========================================================================
  
  // Màu Xanh lá: Dùng cho Thu nhập (Income), Số dương, Thành công
  static const Color success = Color(0xFF22C55E); // Green-500
  
  // Màu Đỏ: Dùng cho Chi tiêu (Expense), Số âm, Báo lỗi, Xóa
  static const Color error = Color(0xFFEF4444);   // Red-500
  
  // Màu Cam: Cảnh báo, Chờ xử lý
  static const Color warning = Color(0xFFF97316); // Orange-500
  
  // Màu Xanh dương: Thông tin, Link
  static const Color info = Color(0xFF3B82F6);    // Blue-500

  // ===========================================================================
  // 4. MÀU VĂN BẢN (TYPOGRAPHY)
  // ===========================================================================
  
  // Chữ chính (Tiêu đề, Số tiền to) - Đen gần như tuyệt đối
  static const Color textPrimary = Color(0xFF1E293B); // Slate-800
  
  // Chữ phụ (Ghi chú, Ngày tháng, Label nhỏ) - Xám trung tính
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  
  // Chữ mờ (Hint text, Placeholder)
  static const Color textHint = Color(0xFF94A3B8); // Slate-400
  
  // Chữ trắng (Dùng trên nền tối)
  static const Color textWhite = Colors.white;

  // ===========================================================================
  // 5. MÀU ĐẶC THÙ TỪNG MODULE
  // ===========================================================================
  
  // --- Module Xổ Số & Bóng Đá (Giao diện tối Dark Mode) ---
  static const Color darkBackground = Color(0xFF111827); // Nền tối
  static const Color darkCard = Color(0xFF1F2937);       // Card tối màu
  
  // --- Module Lịch ---
  static const Color calendarRed = Color(0xFFB91C1C);    // Đỏ lịch âm
}
