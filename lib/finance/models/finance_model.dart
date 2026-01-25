import 'package:flutter/material.dart';

// Loại giao dịch
enum TransactionType { expense, income }

// Danh mục (Ví dụ: Ăn uống, Lương...)
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  CategoryItem({required this.id, required this.name, required this.icon, required this.color, required this.type});
}

// Giao dịch chi tiết
class Transaction {
  final String id;
  final double amount;
  final CategoryItem category;
  final DateTime date;
  final String note;

  Transaction({required this.id, required this.amount, required this.category, required this.date, required this.note});
}

// DỮ LIỆU MẪU (Giả lập Database)
class FinanceData {
  static List<CategoryItem> categories = [
    // Chi tiêu
    CategoryItem(id: 'c1', name: 'Ăn uống', icon: Icons.restaurant, color: Colors.orange, type: TransactionType.expense),
    CategoryItem(id: 'c2', name: 'Di chuyển', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    CategoryItem(id: 'c3', name: 'Mua sắm', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    CategoryItem(id: 'c4', name: 'Nhà cửa', icon: Icons.home, color: Colors.brown, type: TransactionType.expense),
    // Thu nhập
    CategoryItem(id: 'c5', name: 'Lương', icon: Icons.attach_money, color: Colors.green, type: TransactionType.income),
    CategoryItem(id: 'c6', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.purple, type: TransactionType.income),
    CategoryItem(id: 'c7', name: 'Đầu tư', icon: Icons.trending_up, color: Colors.teal, type: TransactionType.income),
  ];

  static List<Transaction> transactions = [
    Transaction(id: 't1', amount: 15000000, category: categories[4], date: DateTime.now(), note: 'Lương tháng 1'),
    Transaction(id: 't2', amount: 50000, category: categories[0], date: DateTime.now(), note: 'Phở sáng'),
    Transaction(id: 't3', amount: 500000, category: categories[2], date: DateTime.now().subtract(const Duration(days: 1)), note: 'Mua áo sơ mi'),
  ];
}
