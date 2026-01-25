import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tính toán dữ liệu
    double totalIncome = 0;
    double totalExpense = 0;
    for (var t in FinanceData.transactions) {
      if (t.category.type == TransactionType.income) totalIncome += t.amount;
      else totalExpense += t.amount;
    }
    double balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Báo Cáo Tài Chính", style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Tổng quan Tình hình tài chính
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text("Lợi nhuận ròng (Tháng này)", style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 8),
                  Text("${NumberFormat('#,###').format(balance)} đ", style: TextStyle(color: balance >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white24, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("Tổng thu", style: TextStyle(color: Colors.white60)),
                        Text("+${NumberFormat.compact().format(totalIncome)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Text("Tổng chi", style: TextStyle(color: Colors.white60)),
                        Text("-${NumberFormat.compact().format(totalExpense)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                      ]),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 2. Biểu đồ chi tiêu (Dạng Thanh Progress Bar)
            Align(alignment: Alignment.centerLeft, child: Text("Phân tích chi tiêu", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            
            // Lấy danh sách các khoản chi
            if (totalExpense == 0)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Chưa có dữ liệu chi tiêu", style: TextStyle(color: Colors.grey))))
            else
              ...FinanceData.expenseCategories.map((cat) {
                // Tính tổng tiền của category này
                double sum = FinanceData.transactions.where((t) => t.category.id == cat.id).fold(0, (prev, element) => prev + element.amount);
                
                if (sum == 0) return const SizedBox.shrink(); // Ẩn nếu ko có tiền

                double percent = sum / totalExpense;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: cat.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(cat.icon, size: 18, color: cat.color)),
                          const SizedBox(width: 12),
                          Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text("${(percent*100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 8),
                          Text(NumberFormat('#,###').format(sum), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Vẽ thanh Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor: Colors.grey[100],
                          color: cat.color,
                        ),
                      )
                    ],
                  ),
                );
              }).toList()
          ],
        ),
      ),
    );
  }
}
