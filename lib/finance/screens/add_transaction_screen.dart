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
  String _amountStr = '0'; // Số tiền đang nhập
  CategoryItem _selectedCategory = FinanceData.categories[0];
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  TransactionType _currentType = TransactionType.expense;

  // Xử lý nhập số từ bàn phím
  void _onKeyTap(String value) {
    setState(() {
      if (value == 'DEL') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else {
        if (_amountStr == '0') _amountStr = value;
        else if (_amountStr.length < 12) _amountStr += value;
      }
    });
  }

  void _saveTransaction() {
    // Logic lưu vào database (giả lập)
    final newTx = Transaction(
      id: DateTime.now().toString(),
      amount: double.parse(_amountStr),
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text,
    );
    FinanceData.transactions.insert(0, newTx); // Thêm vào đầu danh sách
    Navigator.pop(context, true); // Quay về và báo thành công
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypeBtn("Chi tiền", TransactionType.expense),
            const SizedBox(width: 10),
            _buildTypeBtn("Thu tiền", TransactionType.income),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Phần nhập số tiền
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Số tiền", style: GoogleFonts.manrope(color: Colors.grey)),
                Text(
                  "${NumberFormat('#,###').format(double.parse(_amountStr))} đ",
                  style: GoogleFonts.manrope(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold, 
                    color: _currentType == TransactionType.expense ? Colors.red : Colors.green
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Form chọn thông tin
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: ListView(
                children: [
                  // Chọn danh mục
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: FinanceData.categories.where((c) => c.type == _currentType).length,
                      itemBuilder: (context, index) {
                        final cat = FinanceData.categories.where((c) => c.type == _currentType).toList()[index];
                        final isSelected = cat.id == _selectedCategory.id;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? cat.color.withOpacity(0.2) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? cat.color : Colors.transparent),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(cat.icon, color: cat.color),
                                const SizedBox(height: 4),
                                Text(cat.name, style: TextStyle(fontSize: 12, color: isSelected ? cat.color : Colors.black87), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Chọn ngày & Ghi chú
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: Text(DateFormat('dd/MM/yyyy - EEEE').format(_selectedDate)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context, 
                              initialDate: _selectedDate, 
                              firstDate: DateTime(2020), 
                              lastDate: DateTime(2030)
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                        ),
                        const Divider(),
                        TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.edit_note, color: Colors.grey),
                            hintText: "Ghi chú (Ví dụ: Ăn trưa với đối tác)",
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

          // 3. Bàn phím số (Numpad)
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(children: [_buildKey('7'), _buildKey('8'), _buildKey('9')]),
                Row(children: [_buildKey('4'), _buildKey('5'), _buildKey('6')]),
                Row(children: [_buildKey('1'), _buildKey('2'), _buildKey('3')]),
                Row(children: [_buildKey('000'), _buildKey('0'), _buildKey('DEL')]),
                
                // Nút Lưu
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: double.parse(_amountStr) > 0 ? _saveTransaction : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("LƯU GIAO DỊCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeBtn(String label, TransactionType type) {
    final isSelected = _currentType == type;
    return GestureDetector(
      onTap: () => setState(() => _currentType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (type == TransactionType.expense ? Colors.red[100] : Colors.green[100]) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? (type == TransactionType.expense ? Colors.red : Colors.green) : Colors.grey,
          fontWeight: FontWeight.bold
        )),
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
          child: label == 'DEL' 
            ? const Icon(Icons.backspace_outlined, size: 20)
            : Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
