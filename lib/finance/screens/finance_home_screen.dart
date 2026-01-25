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
  // Hàm tính tổng số dư
  double get _totalBalance => FinanceData.transactions.fold(0, (sum, item) {
    return sum + (item.category.type == TransactionType.income ? item.amount : -item.amount);
  });

  // Hàm tính tổng thu/chi tháng này
  double get _monthIncome => FinanceData.transactions
      .where((t) => t.category.type == TransactionType.income && t.date.month == DateTime.now().month)
      .fold(0, (sum, item) => sum + item.amount);

  double get _monthExpense => FinanceData.transactions
      .where((t) => t.category.type == TransactionType.expense && t.date.month == DateTime.now().month)
      .fold(0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7), // Màu nền xám nhẹ chuẩn App Tài chính
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tổng tài sản", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 12)),
            Text("${NumberFormat('#,###').format(_totalBalance)} đ", 
              style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline, color: Colors.black87),
            tooltip: "Xem báo cáo",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FinanceReportScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Thẻ Tóm tắt tình hình thu chi (Giống MISA)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Expanded(child: _buildSummaryItem("Thu nhập", _monthIncome, Colors.green)),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                Expanded(child: _buildSummaryItem("Chi tiêu", _monthExpense, Colors.red)),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                Expanded(child: _buildSummaryItem("Còn lại", _monthIncome - _monthExpense, Colors.black)),
              ],
            ),
          ),

          // 2. Danh sách giao dịch gần đây
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: FinanceData.transactions.length,
              itemBuilder: (context, index) {
                final tx = FinanceData.transactions[index];
                return GestureDetector(
                  onTap: () {
                    // Xử lý khi bấm vào giao dịch (Hiện chi tiết)
                    _showTransactionDetail(tx);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: tx.category.color.withOpacity(0.1),
                          child: Icon(tx.category.icon, color: tx.category.color, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx.category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(DateFormat('dd/MM/yyyy - HH:mm').format(tx.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              if (tx.note.isNotEmpty) 
                                Text(tx.note, style: const TextStyle(color: Colors.black54, fontSize: 13, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        Text(
                          "${tx.category.type == TransactionType.income ? '+' : '-'}${NumberFormat('#,###').format(tx.amount)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: tx.category.type == TransactionType.income ? Colors.green : Colors.red
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Nút Thêm Giao Dịch (To, Nổi bật)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen()));
          setState(() {}); // Cập nhật lại màn hình khi quay về
        },
        backgroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Ghi chép", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(NumberFormat.compact().format(value), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  void _showTransactionDetail(Transaction tx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 250,
        child: Column(
          children: [
            Container(width: 40, height: 4, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20)),
            Text("Chi tiết giao dịch", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Số tiền:"),
              Text("${NumberFormat('#,###').format(tx.amount)} đ", style: TextStyle(color: tx.category.color, fontWeight: FontWeight.bold, fontSize: 20)),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Hạng mục:"),
              Row(children: [Icon(tx.category.icon, size: 16), const SizedBox(width: 8), Text(tx.category.name)]),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Ghi chú:"),
              Text(tx.note.isEmpty ? "Không có" : tx.note),
            ]),
          ],
        ),
      ),
    );
  }
}
