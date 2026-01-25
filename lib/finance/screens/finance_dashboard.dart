import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';
import 'add_transaction_screen.dart';
import 'finance_report_screen.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  // Hàm refresh để build lại màn hình khi dữ liệu thay đổi
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Tính tổng số dư hiện tại
    double totalBalance = FinanceData.transactions.fold(0, (sum, t) {
      return sum + (t.category.type == TransactionType.income ? t.amount : -t.amount);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tổng tài sản", style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey)),
            Text("${NumberFormat('#,###').format(totalBalance)} đ", style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FinanceReportScreen())),
            icon: const Icon(Icons.pie_chart, color: Colors.orange),
            tooltip: "Xem báo cáo",
          )
        ],
      ),
      body: Column(
        children: [
          // Header danh sách
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giao dịch gần đây", style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Xem tất cả", style: GoogleFonts.manrope(color: Colors.blue, fontSize: 14)),
              ],
            ),
          ),
          
          // List Giao Dịch
          Expanded(
            child: FinanceData.transactions.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long, size: 60, color: Colors.grey[300]), const Text("Chưa có giao dịch nào")]))
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: FinanceData.transactions.length,
              itemBuilder: (context, index) {
                final tx = FinanceData.transactions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      // Icon danh mục
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: tx.category.color.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(tx.category.icon, color: tx.category.color, size: 20),
                      ),
                      const SizedBox(width: 16),
                      // Tên và Ghi chú
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              "${DateFormat('dd/MM').format(tx.date)} ${tx.note.isNotEmpty ? '• ${tx.note}' : ''}",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Số tiền
                      Text(
                        "${tx.category.type == TransactionType.income ? '+' : '-'}${NumberFormat('#,###').format(tx.amount)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: tx.category.type == TransactionType.income ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Nút Floating Button To Đùng
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("GHI CHÉP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
          if (result == true) _refresh(); // Cập nhật lại list nếu có thêm mới
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
