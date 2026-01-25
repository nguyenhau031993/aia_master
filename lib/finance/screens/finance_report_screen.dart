import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tính toán tổng
    double totalIncome = 0;
    double totalExpense = 0;
    for (var t in FinanceData.transactions) {
      if (t.category.type == TransactionType.income) totalIncome += t.amount;
      else totalExpense += t.amount;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Báo cáo tháng này", style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Tổng quan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem("Thu nhập", totalIncome, Colors.greenAccent),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildSummaryItem("Chi tiêu", totalExpense, Colors.redAccent),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildSummaryItem("Còn lại", totalIncome - totalExpense, Colors.amber),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. Biểu đồ chi tiêu (Giả lập bằng Progress Bar màu sắc)
            Align(alignment: Alignment.centerLeft, child: Text("Cơ cấu chi tiêu", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            
            // Lấy danh sách danh mục chi tiêu
            ...FinanceData.categories.where((c) => c.type == TransactionType.expense).map((cat) {
              // Tính tổng tiền cho danh mục này
              double sum = 0;
              for(var t in FinanceData.transactions) {
                if(t.category.id == cat.id) sum += t.amount;
              }
              if (sum == 0) return const SizedBox.shrink(); // Ẩn nếu ko có tiền

              double percent = totalExpense > 0 ? (sum / totalExpense) : 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: cat.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(cat.icon, color: cat.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text("${NumberFormat('#,###').format(sum)} đ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          NumberFormat.compact().format(value), 
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)
        ),
      ],
    );
  }
}
