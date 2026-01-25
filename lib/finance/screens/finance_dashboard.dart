import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';
import 'add_transaction_screen.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  void _refresh() => setState(() {}); 

  @override
  Widget build(BuildContext context) {
    // Tính tổng số dư
    double balance = FinanceData.transactions.fold(0, (sum, t) => sum + (t.category.type == TransactionType.income ? t.amount : -t.amount));

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tiền mặt hiện có", style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey)),
            Text("${NumberFormat('#,###').format(balance)} đ", style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white, elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giao dịch gần đây", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Xem tất cả", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          Expanded(
            child: FinanceData.transactions.isEmpty
            ? const Center(child: Text("Chưa có giao dịch nào"))
            : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: FinanceData.transactions.length,
              separatorBuilder: (_,__) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = FinanceData.transactions[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: tx.category.color.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(tx.category.icon, color: tx.category.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(DateFormat('dd/MM HH:mm').format(tx.date) + (tx.note.isNotEmpty ? " • ${tx.note}" : ""), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        "${tx.category.type == TransactionType.income ? '+' : '-'}${NumberFormat('#,###').format(tx.amount)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16,
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("GHI CHÉP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen()));
          _refresh();
        },
      ),
    );
  }
}
