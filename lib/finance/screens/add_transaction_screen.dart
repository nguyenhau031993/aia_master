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
  CategoryItem _selectedCategory = FinanceData.categories[0];
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'DEL') {
        if (_inputAmount.length > 1) _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        else _inputAmount = "0";
      } else {
        if (_inputAmount == "0") _inputAmount = value;
        else if (_inputAmount.length < 15) _inputAmount += value;
      }
    });
  }

  void _save() {
    double amount = double.tryParse(_inputAmount) ?? 0;
    if (amount <= 0) return;

    FinanceData.transactions.insert(0, Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text,
    ));
    Navigator.pop(context); // Đóng màn hình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTab("Chi tiền", TransactionType.expense),
            const SizedBox(width: 12),
            _buildTab("Thu tiền", TransactionType.income),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Hiển thị số tiền
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Số tiền", style: TextStyle(color: Colors.grey)),
                Text(
                  "${NumberFormat('#,###').format(double.parse(_inputAmount))} đ",
                  style: GoogleFonts.manrope(
                    fontSize: 40, fontWeight: FontWeight.bold,
                    color: _type == TransactionType.expense ? Colors.red : Colors.green
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Form chọn (Danh mục, Ngày, Ghi chú)
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text("Danh mục", style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: FinanceData.categories.where((c) => c.type == _type).length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = FinanceData.categories.where((c) => c.type == _type).toList()[index];
                        final isSelected = cat.id == _selectedCategory.id;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? cat.color.withOpacity(0.1) : Colors.white,
                              border: Border.all(color: isSelected ? cat.color : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(cat.icon, color: cat.color),
                                const SizedBox(height: 4),
                                Text(cat.name, style: TextStyle(fontSize: 12, color: isSelected ? cat.color : Colors.black87)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Chọn ngày & Ghi chú
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                          onTap: () async {
                            final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                            if (date != null) setState(() => _selectedDate = date);
                          },
                        ),
                        const Divider(),
                        TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.edit_note, color: Colors.grey),
                            hintText: "Ghi chú...",
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bàn phím số & Nút Lưu
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(children: ['7', '8', '9'].map(_buildKey).toList()),
                Row(children: ['4', '5', '6'].map(_buildKey).toList()),
                Row(children: ['1', '2', '3'].map(_buildKey).toList()),
                Row(children: ['000', '0', 'DEL'].map(_buildKey).toList()),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: double.parse(_inputAmount) > 0 ? _save : null,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("LƯU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, TransactionType type) {
    bool isActive = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? (type == TransactionType.income ? Colors.green[50] : Colors.red[50]) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isActive ? (type == TransactionType.income ? Colors.green : Colors.red) : Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildKey(String label) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(label),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.1))),
          child: label == 'DEL' ? const Icon(Icons.backspace_outlined) : Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
