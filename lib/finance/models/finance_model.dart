import 'package:flutter/material.dart';

// Loại giao dịch: Thu nhập hoặc Chi tiêu
enum TransactionType { income, expense }

// Model Danh mục (Ăn uống, Di chuyển...)
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
    required this.type
  });
}

// Model Giao dịch (Lưu từng khoản thu chi)
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

// --- DỮ LIỆU MẪU (Dùng tạm khi chưa có Database) ---
class FinanceData {
  static List<CategoryItem> categories = [
    CategoryItem(id: '1', name: 'Ăn uống', icon: Icons.restaurant, color: Colors.orange, type: TransactionType.expense),
    CategoryItem(id: '2', name: 'Di chuyển', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    CategoryItem(id: '3', name: 'Mua sắm', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    CategoryItem(id: '4', name: 'Hóa đơn', icon: Icons.receipt_long, color: Colors.red, type: TransactionType.expense),
    CategoryItem(id: '5', name: 'Lương', icon: Icons.attach_money, color: Colors.green, type: TransactionType.income),
    CategoryItem(id: '6', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.purple, type: TransactionType.income),
    CategoryItem(id: '7', name: 'Đầu tư', icon: Icons.trending_up, color: Colors.teal, type: TransactionType.income),
  ];

  static List<Transaction> transactions = [
    Transaction(id: 't1', amount: 5000000, category: categories[4], date: DateTime.now(), note: 'Lương tháng 1'),
    Transaction(id: 't2', amount: 50000, category: categories[0], date: DateTime.now(), note: 'Phở sáng'),
    Transaction(id: 't3', amount: 1200000, category: categories[3], date: DateTime.now().subtract(const Duration(days: 1)), note: 'Tiền điện'),
    Transaction(id: 't4', amount: 300000, category: categories[2], date: DateTime.now().subtract(const Duration(days: 2)), note: 'Mua áo'),
  ];
}
