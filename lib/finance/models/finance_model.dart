import 'package:flutter/material.dart';

// Định nghĩa loại giao dịch
enum TransactionType { expense, income }

// Định nghĩa hạng mục chi tiêu (Icon, Màu sắc, Tên)
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

// Định nghĩa một giao dịch
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

// KHO DỮ LIỆU TRUNG TÂM (DATABASE GIẢ LẬP)
class FinanceData {
  // --- DANH MỤC CHI TIÊU (EXPENSE) ---
  static List<CategoryItem> expenseCategories = [
    CategoryItem(id: 'e1', name: 'Ăn uống', icon: Icons.restaurant, color: Colors.orange, type: TransactionType.expense),
    CategoryItem(id: 'e2', name: 'Di chuyển', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    CategoryItem(id: 'e3', name: 'Mua sắm', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    CategoryItem(id: 'e4', name: 'Nhà cửa', icon: Icons.home, color: Colors.brown, type: TransactionType.expense),
    CategoryItem(id: 'e5', name: 'Điện nước', icon: Icons.electric_bolt, color: Colors.yellow[700]!, type: TransactionType.expense),
    CategoryItem(id: 'e6', name: 'Sức khỏe', icon: Icons.medical_services, color: Colors.red, type: TransactionType.expense),
    CategoryItem(id: 'e7', name: 'Giáo dục', icon: Icons.school, color: Colors.indigo, type: TransactionType.expense),
    CategoryItem(id: 'e8', name: 'Giải trí', icon: Icons.movie, color: Colors.purple, type: TransactionType.expense),
  ];

  // --- DANH MỤC THU NHẬP (INCOME) ---
  static List<CategoryItem> incomeCategories = [
    CategoryItem(id: 'i1', name: 'Lương', icon: Icons.attach_money, color: Colors.green, type: TransactionType.income),
    CategoryItem(id: 'i2', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.teal, type: TransactionType.income),
    CategoryItem(id: 'i3', name: 'Đầu tư', icon: Icons.trending_up, color: Colors.blueAccent, type: TransactionType.income),
    CategoryItem(id: 'i4', name: 'Bán đồ', icon: Icons.store, color: Colors.amber, type: TransactionType.income),
  ];

  // --- DANH SÁCH GIAO DỊCH (Dữ liệu mẫu ban đầu) ---
  static List<Transaction> transactions = [
    Transaction(id: 't1', amount: 25000000, category: incomeCategories[0], date: DateTime.now(), note: 'Lương tháng 1'),
    Transaction(id: 't2', amount: 55000, category: expenseCategories[0], date: DateTime.now(), note: 'Phở bò + Quẩy'),
    Transaction(id: 't3', amount: 1200000, category: expenseCategories[4], date: DateTime.now().subtract(const Duration(days: 1)), note: 'Tiền điện tháng 12'),
    Transaction(id: 't4', amount: 500000, category: expenseCategories[1], date: DateTime.now().subtract(const Duration(days: 2)), note: 'Xăng ô tô'),
  ];

  // Hàm lấy tất cả danh mục theo loại
  static List<CategoryItem> getCategories(TransactionType type) {
    return type == TransactionType.expense ? expenseCategories : incomeCategories;
  }
}
