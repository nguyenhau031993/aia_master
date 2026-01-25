import 'package:flutter/material.dart';

// 1. Định nghĩa Loại giao dịch (Thu hoặc Chi)
enum TransactionType { expense, income }

// 2. Định nghĩa Hạng mục (Ví dụ: Ăn uống, Lương...)
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

// 3. Định nghĩa Giao dịch chi tiết
class Transaction {
  final String id;
  final double amount;
  final CategoryItem category;
  final DateTime date;
  final String note;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
}

// 4. KHO DỮ LIỆU TĨNH (Giả lập Database)
class FinanceData {
  // --- DANH MỤC CHI TIÊU (Màu đỏ/cam/hồng) ---
  static List<CategoryItem> expenseCategories = [
    CategoryItem(id: 'e1', name: 'Ăn uống', icon: Icons.restaurant, color: Colors.orange, type: TransactionType.expense),
    CategoryItem(id: 'e2', name: 'Di chuyển', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    CategoryItem(id: 'e3', name: 'Mua sắm', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    CategoryItem(id: 'e4', name: 'Điện nước', icon: Icons.lightbulb, color: Colors.yellow[700]!, type: TransactionType.expense),
    CategoryItem(id: 'e5', name: 'Nhà cửa', icon: Icons.home, color: Colors.brown, type: TransactionType.expense),
    CategoryItem(id: 'e6', name: 'Y tế', icon: Icons.medical_services, color: Colors.red, type: TransactionType.expense),
  ];

  // --- DANH MỤC THU NHẬP (Màu xanh) ---
  static List<CategoryItem> incomeCategories = [
    CategoryItem(id: 'i1', name: 'Lương', icon: Icons.attach_money, color: Colors.green, type: TransactionType.income),
    CategoryItem(id: 'i2', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.purple, type: TransactionType.income),
    CategoryItem(id: 'i3', name: 'Đầu tư', icon: Icons.trending_up, color: Colors.teal, type: TransactionType.income),
    CategoryItem(id: 'i4', name: 'Khác', icon: Icons.savings, color: Colors.blueAccent, type: TransactionType.income),
  ];

  // Danh sách giao dịch mẫu
  static List<Transaction> transactions = [
    Transaction(id: 't1', amount: 25000000, category: incomeCategories[0], date: DateTime.now(), note: 'Lương tháng 1'),
    Transaction(id: 't2', amount: 55000, category: expenseCategories[0], date: DateTime.now(), note: 'Phở bò'),
    Transaction(id: 't3', amount: 500000, category: expenseCategories[1], date: DateTime.now().subtract(const Duration(days: 1)), note: 'Đổ xăng'),
  ];
  
  // Hàm lấy danh mục theo loại
  static List<CategoryItem> getCategories(TransactionType type) {
    return type == TransactionType.expense ? expenseCategories : incomeCategories;
  }
}
