import 'package:flutter/material.dart';

enum TransactionType { expense, income }

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;
  CategoryItem({required this.id, required this.name, required this.icon, required this.color, required this.type});
}

class Transaction {
  final String id;
  final double amount;
  final CategoryItem category;
  final DateTime date;
  final String note;
  Transaction({required this.id, required this.amount, required this.category, required this.date, required this.note});
}

class FinanceData {
  static List<CategoryItem> categories = [
    CategoryItem(id: 'c1', name: 'Ăn uống', icon: Icons.fastfood, color: Colors.orange, type: TransactionType.expense),
    CategoryItem(id: 'c2', name: 'Di chuyển', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    CategoryItem(id: 'c3', name: 'Mua sắm', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    CategoryItem(id: 'c4', name: 'Lương', icon: Icons.attach_money, color: Colors.green, type: TransactionType.income),
    CategoryItem(id: 'c5', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.purple, type: TransactionType.income),
  ];

  static List<Transaction> transactions = [
    Transaction(id: 't1', amount: 15000000, category: categories[3], date: DateTime.now(), note: 'Lương tháng 1'),
    Transaction(id: 't2', amount: 50000, category: categories[0], date: DateTime.now(), note: 'Phở bò'),
  ];
  
  // Hàm trợ giúp lấy danh mục
  static List<CategoryItem> getCategories(TransactionType type) {
    return categories.where((c) => c.type == type).toList();
  }
}
