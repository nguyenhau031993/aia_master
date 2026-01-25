import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/finance_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _inputAmount = "0";
  TransactionType _type = TransactionType.expense;
  CategoryItem? _selectedCategory;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = FinanceData.expenseCategories[0]; // Mặc định chọn cái đầu
  }

  // Xử lý bàn phím số
  void _onKeyTap(String value) {
    setState(() {
      if (value == 'DEL') {
        _inputAmount = _inputAmount.length > 1 ? _inputAmount.substring(0, _inputAmount.length - 1) : "0";
      } else {
        if (_inputAmount == "0") _inputAmount = value;
        else if (_inputAmount.length < 15) _inputAmount += value;
      }
    });
  }

  // Lưu dữ liệu
  void _save() {
    double amount = double.tryParse(_inputAmount) ?? 0;
    if (amount <= 0) return;

    FinanceData.transactions.insert(0, Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      category: _selectedCategory!,
      date: DateTime.now(),
      note: _noteController.text,
    ));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypeBtn("CHI TIỀN", TransactionType.expense),
            const SizedBox(width: 10),
            _buildTypeBtn("THU TIỀN", TransactionType.income),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Hiển thị số tiền to
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Số tiền", style: TextStyle(color: Colors.grey)),
                Text(
                  "${NumberFormat('#,###').format(double.parse(_inputAmount))} đ",
                  style: GoogleFonts.manrope(fontSize: 40, fontWeight: FontWeight.bold, color: _type == TransactionType.expense ? Colors.red : Colors.green),
                ),
              ],
            ),
          ),
          
          // 2. Chọn danh mục & Ghi chú
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text("Chọn danh mục:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: FinanceData.getCategories(_type).map((cat) {
                    bool isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: isSelected ? cat.color.withOpacity(0.1) : Colors.grey[50],
                          border: isSelected ? Border.all(color: cat.color, width: 2) : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(cat.icon, color: cat.color),
                            const SizedBox(height: 4),
                            Text(cat.name, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: "Ghi chú (Ví dụ: Ăn trưa)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bàn phím số
          Column(children: [
            Row(children: ['7','8','9'].map(_buildKey).toList()),
            Row(children: ['4','5','6'].map(_buildKey).toList()),
            Row(children: ['1','2','3'].map(_buildKey).toList()),
            Row(children: ['000','0','DEL'].map(_buildKey).toList()),
          ]),
          
          // Nút Lưu
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                child: const Text("LƯU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeBtn(String text, TransactionType type) {
    bool isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() { 
        _type = type; 
        _selectedCategory = FinanceData.getCategories(type)[0];
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (type == TransactionType.expense ? Colors.red[50] : Colors.green[50]) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: TextStyle(
          color: isSelected ? (type == TransactionType.expense ? Colors.red : Colors.green) : Colors.grey,
          fontWeight: FontWeight.bold
        )),
      ),
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(value),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!)),
          child: value == 'DEL' ? const Icon(Icons.backspace_outlined) : Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
