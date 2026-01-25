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
  String _amountStr = "0"; // Lưu chuỗi số tiền đang nhập
  TransactionType _currentType = TransactionType.expense; // Mặc định là Chi
  late CategoryItem _selectedCategory; // Danh mục đang chọn
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mặc định chọn cái đầu tiên của danh sách Chi
    _selectedCategory = FinanceData.expenseCategories[0];
  }

  // Logic xử lý khi bấm bàn phím số
  void _onKeyTap(String value) {
    setState(() {
      if (value == 'DEL') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = "0";
        }
      } else if (value == 'OK') {
        _saveTransaction();
      } else {
        if (_amountStr == "0") {
          _amountStr = value;
        } else if (_amountStr.length < 15) { // Giới hạn độ dài tránh tràn màn hình
          _amountStr += value;
        }
      }
    });
  }

  // Logic lưu giao dịch
  void _saveTransaction() {
    double amount = double.tryParse(_amountStr) ?? 0;
    if (amount <= 0) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập số tiền lớn hơn 0")));
       return;
    }

    final newTx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID duy nhất theo thời gian
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text,
    );

    FinanceData.transactions.insert(0, newTx); // Thêm vào đầu danh sách
    Navigator.pop(context, true); // Đóng màn hình và trả về kết quả true
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = _currentType == TransactionType.expense ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // Nút chuyển đổi THU / CHI ở giữa
        title: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSwitchBtn("CHI TIỀN", TransactionType.expense),
              _buildSwitchBtn("THU TIỀN", TransactionType.income),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Phần hiển thị số tiền và Danh mục đang chọn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    color: activeColor
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(_selectedCategory.icon, size: 20, color: _selectedCategory.color),
                    const SizedBox(width: 8),
                    Text(_selectedCategory.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                )
              ],
            ),
          ),
          
          const Divider(),

          // 2. Phần chọn chi tiết (Cuộn được)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Chọn ngày
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if(picked != null) setState(() => _selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(DateFormat('dd/MM/yyyy - EEEE').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Ô nhập Ghi chú
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.note, color: Colors.grey),
                    hintText: "Ghi chú (Ví dụ: Ăn tối cùng đối tác)",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Lưới chọn Danh mục (Grid)
                Text("Chọn danh mục", style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1.0, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: FinanceData.getCategories(_currentType).length,
                  itemBuilder: (context, index) {
                    final cat = FinanceData.getCategories(_currentType)[index];
                    final isSelected = cat.id == _selectedCategory.id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? cat.color.withOpacity(0.2) : Colors.grey[50],
                          border: isSelected ? Border.all(color: cat.color, width: 2) : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(cat.icon, color: cat.color),
                            const SizedBox(height: 4),
                            Text(cat.name, style: TextStyle(fontSize: 10, color: Colors.black87), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Bàn phím số (Numpad Custom)
          Container(
            color: Colors.grey[50],
            child: Column(
              children: [
                Row(children: [_buildKey('7'), _buildKey('8'), _buildKey('9')]),
                Row(children: [_buildKey('4'), _buildKey('5'), _buildKey('6')]),
                Row(children: [_buildKey('1'), _buildKey('2'), _buildKey('3')]),
                Row(children: [_buildKey('000'), _buildKey('0'), _buildKey('DEL')]),
                // Nút Lưu to
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: () => _onKeyTap('OK'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("LƯU GIAO DỊCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

  // Widget nút chuyển loại Thu/Chi
  Widget _buildSwitchBtn(String label, TransactionType type) {
    bool isSelected = _currentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentType = type;
          // Reset danh mục về cái đầu tiên của loại mới để tránh lỗi
          _selectedCategory = FinanceData.getCategories(type)[0];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? (type == TransactionType.expense ? Colors.red : Colors.green) : Colors.grey,
          ),
        ),
      ),
    );
  }

  // Widget phím số
  Widget _buildKey(String label) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(label),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!)),
          child: label == 'DEL' 
            ? const Icon(Icons.backspace_outlined) 
            : Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
