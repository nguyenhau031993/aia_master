import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double totalExpense = FinanceData.transactions
        .where((t) => t.category.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Báo cáo tài chính", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cơ cấu chi tiêu", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Vẽ biểu đồ dạng thanh ngang (Progress Bar)
            ...FinanceData.categories.where((c) => c.type == TransactionType.expense).map((cat) {
              double sum = FinanceData.transactions.where((t) => t.category.id == cat.id).fold(0, (s, t) => s + t.amount);
              if (sum == 0) return const SizedBox.shrink();

              double percent = totalExpense > 0 ? sum / totalExpense : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(cat.icon, color: cat.color, size: 20),
                        const SizedBox(width: 8),
                        Text(cat.name),
                        const Spacer(),
                        Text("${(percent * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(NumberFormat.compact().format(sum), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey[100],
                        color: cat.color,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            if (totalExpense == 0) 
              const Center(child: Text("Chưa có dữ liệu chi tiêu", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}
