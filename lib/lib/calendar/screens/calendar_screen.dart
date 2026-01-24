import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/kinh_dich_data.dart';
import '../utils/than_tai_logic.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Biến cho Xin Quẻ
  QueDich? _queHienTai;
  bool _dangGieoQue = false;

  // Biến cho Xin Số
  String _loaiXoSo = 'Mega 6/45';
  List<int> _ketQuaVietlott = [];
  String _ketQuaKienThiet = "?????";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // --- HÀM XỬ LÝ ---
  void _gieoQue() async {
    setState(() => _dangGieoQue = true);
    // Giả lập lắc ống xăm 2 giây
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _dangGieoQue = false;
      // Lấy ngẫu nhiên 1 quẻ từ kho dữ liệu
      _queHienTai = danhSachQue[Random().nextInt(danhSachQue.length)];
    });
  }

  void _cauThanTai() {
    setState(() {
      if (_loaiXoSo.contains('Mega') || _loaiXoSo.contains('Power')) {
        int limit = _loaiXoSo.contains('6/55') ? 55 : 45;
        _ketQuaVietlott = ThanTaiLogic.laySoVietlott(limit);
        _ketQuaKienThiet = ""; // Reset kien thiet
      } else {
        _ketQuaKienThiet = ThanTaiLogic.laySoKienThiet();
        _ketQuaVietlott = []; // Reset vietlott
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000), // Đỏ đô truyền thống
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('LỊCH VẠN NIÊN & PHONG THỦY', style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold, color: Colors.amber)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Lịch Ngày', icon: Icon(Icons.calendar_today)),
            Tab(text: 'Xin Quẻ', icon: Icon(Icons.auto_awesome)),
            Tab(text: 'Xin Số', icon: Icon(Icons.monetization_on)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLichNgay(),
          _buildXinQue(),
          _buildXinSo(),
        ],
      ),
    );
  }

  // 1. GIAO DIỆN LỊCH
  Widget _buildLichNgay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('THÁNG 1 - 2026', style: GoogleFonts.notoSerif(fontSize: 20, color: Colors.white)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Text('24', style: GoogleFonts.notoSerif(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.red)),
              Text('Thứ Bảy', style: GoogleFonts.notoSerif(fontSize: 20, color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Âm Lịch: 06/12 - Ất Tỵ', style: GoogleFonts.notoSerif(fontSize: 22, color: Colors.amberAccent)),
        const SizedBox(height: 10),
        Text('Giờ Hoàng Đạo: Tý, Sửu, Mão, Ngọ', style: GoogleFonts.notoSerif(color: Colors.white70)),
      ],
    );
  }

  // 2. GIAO DIỆN XIN QUẺ
  Widget _buildXinQue() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.yin_yang, size: 80, color: Colors.white54),
          const SizedBox(height: 20),
          if (_dangGieoQue)
            const Text('Đang lắc ống xăm...', style: TextStyle(color: Colors.white, fontSize: 18))
          else if (_queHienTai == null)
            const Text('Hãy tĩnh tâm và bấm Gieo Quẻ', style: TextStyle(color: Colors.white70, fontSize: 16)),
          
          const Spacer(),
          
          if (_queHienTai != null && !_dangGieoQue) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Text(_queHienTai!.ten, style: GoogleFonts.notoSerif(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red[900])),
                  Text(_queHienTai!.tuongQue, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  const Divider(color: Colors.black26),
                  Text(_queHienTai!.noiDung, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Lời bàn: ${_queHienTai!.loiBan}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          
          const Spacer(),
          ElevatedButton(
            onPressed: _gieoQue,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: Text(_queHienTai == null ? 'GIEO QUẺ NGAY' : 'XIN QUẺ KHÁC', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 3. GIAO DIỆN XIN SỐ THẦN TÀI
  Widget _buildXinSo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('CẦU TÀI LỘC - VẠN SỰ HANH THÔNG', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Chọn loại xổ số
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              value: _loaiXoSo,
              isExpanded: true,
              underline: const SizedBox(),
              items: ['Mega 6/45', 'Power 6/55', 'Miền Bắc', 'Miền Trung', 'Miền Nam'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => _loaiXoSo = val!),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Hiển thị kết quả
          if (_ketQuaVietlott.isNotEmpty)
            Wrap(
              spacing: 10,
              children: _ketQuaVietlott.map((so) => CircleAvatar(
                radius: 25,
                backgroundColor: Colors.red,
                child: Text('$so', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              )).toList(),
            ),
            
          if (_ketQuaKienThiet != "" && _ketQuaVietlott.isEmpty)
             Text(
               _ketQuaKienThiet, 
               style: GoogleFonts.courierPrime(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 5)
             ),

          const Spacer(),
          ElevatedButton.icon(
            onPressed: _cauThanTai,
            icon: const Icon(Icons.fingerprint, color: Colors.red),
            label: const Text('KHẤN NGUYỆN & LẤY SỐ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          ),
        ],
      ),
    );
  }
}
