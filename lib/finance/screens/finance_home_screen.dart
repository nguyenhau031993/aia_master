import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';
import 'add_transaction_screen.dart';
import 'finance_report_screen.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({super.key});

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> {
  
  // Hàm tính lại tổng tiền khi quay lại màn hình này
  void _refreshData() {
    setState(() {}); // Rebuild lại widget để cập nhật danh sách
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng số dư hiện tại
    double balance = 0;
    for (var t in FinanceData.transactions) {
      if (t.category.type == TransactionType.income) balance += t.amount;
      else balance -= t.amount;
    }

    // Nhóm giao dịch theo ngày
    Map<String, List<Transaction>> groupedTransactions = {};
    for (var t in FinanceData.transactions) {
      String dateKey = DateFormat('dd/MM/yyyy').format(t.date);
      if (groupedTransactions[dateKey] == null) groupedTransactions[dateKey] = [];
      groupedTransactions[dateKey]!.add(t);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tổng số dư", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 12)),
            Text("${NumberFormat('#,###').format(balance)} đ", style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart, color: Colors.orange),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FinanceReportScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedTransactions.keys.length,
        itemBuilder: (context, index) {
          String dateStr = groupedTransactions.keys.elementAt(index);
          List<Transaction> dayTxs = groupedTransactions[dateStr]!;
          
          // Tính tổng thu chi trong ngày
          double dayIncome = 0;
          double dayExpense = 0;
          for(var t in dayTxs) {
            if(t.category.type == TransactionType.income) dayIncome += t.amount;
            else dayExpense += t.amount;
          }

          return Column(
            children: [
              // Header Ngày
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    Text(
                      "${dayIncome > 0 ? '+' : ''}${NumberFormat.compact().format(dayIncome - dayExpense)}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // List Giao dịch trong ngày
              ...dayTxs.map((tx) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: tx.category.color.withOpacity(0.1),
                      child: Icon(tx.category.icon, color: tx.category.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          if(tx.note.isNotEmpty) Text(tx.note, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      "${tx.category.type == TransactionType.income ? '+' : '-'}${NumberFormat('#,###').format(tx.amount)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tx.category.type == TransactionType.income ? Colors.green : Colors.red
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F172A),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Mở màn hình Thêm và chờ kết quả
          final result = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddTransactionScreen())
          );
          if (result == true) _refreshData(); // Load lại list nếu có thêm mới
        },
      ),
    );
  }
}
