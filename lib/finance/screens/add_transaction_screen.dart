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
  String _input = "0";
  TransactionType _type = TransactionType.expense;
  CategoryItem? _cat;
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cat = FinanceData.categories[0];
  }

  void _tap(String v) => setState(() => v == 'DEL' ? (_input.length > 1 ? _input = _input.substring(0, _input.length - 1) : _input = "0") : (_input == "0" ? _input = v : _input += v));
  
  void _save() {
    if(_cat == null) return;
    FinanceData.transactions.insert(0, Transaction(id: DateTime.now().toString(), amount: double.parse(_input), category: _cat!, date: DateTime.now(), note: _note.text));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("GHI CHÉP", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(20), alignment: Alignment.centerRight, 
          child: Text("${NumberFormat('#,###').format(double.parse(_input))} đ", style: GoogleFonts.manrope(fontSize: 40, fontWeight: FontWeight.bold, color: _type == TransactionType.expense ? Colors.red : Colors.green))),
        
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _btn("CHI TIỀN", TransactionType.expense), const SizedBox(width: 10), _btn("THU TIỀN", TransactionType.income)
        ]),
        
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
           const Text("Danh mục:"),
           SizedBox(height: 80, child: ListView(scrollDirection: Axis.horizontal, children: FinanceData.getCategories(_type).map((c) => GestureDetector(
             onTap: ()=>setState(()=>_cat=c),
             child: Container(width: 80, margin: const EdgeInsets.only(right: 10), decoration: BoxDecoration(color: _cat==c ? c.color.withOpacity(0.2) : Colors.grey[100], borderRadius: BorderRadius.circular(10), border: _cat==c?Border.all(color: c.color):null), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(c.icon, color: c.color), Text(c.name, style: const TextStyle(fontSize: 10))]))
           )).toList())),
           const SizedBox(height: 10),
           TextField(controller: _note, decoration: const InputDecoration(hintText: "Ghi chú", prefixIcon: Icon(Icons.note))),
        ])),
        
        Column(children: [
          Row(children: ['7','8','9'].map(_k).toList()), Row(children: ['4','5','6'].map(_k).toList()), Row(children: ['1','2','3'].map(_k).toList()), Row(children: ['000','0','DEL'].map(_k).toList()),
        ]),
        Padding(padding: const EdgeInsets.all(10), child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)), child: const Text("LƯU", style: TextStyle(color: Colors.white)))))
      ]),
    );
  }
  Widget _k(String v) => Expanded(child: InkWell(onTap: ()=>_tap(v), child: Container(height: 60, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!)), child: v=='DEL'?const Icon(Icons.backspace):Text(v, style: const TextStyle(fontSize: 24)))));
  Widget _btn(String t, TransactionType type) => GestureDetector(onTap: ()=>setState(()=>_type=type), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _type==type?(type==TransactionType.income?Colors.green:Colors.red):Colors.grey[200], borderRadius: BorderRadius.circular(20)), child: Text(t, style: TextStyle(color: _type==type?Colors.white:Colors.black))));
}
