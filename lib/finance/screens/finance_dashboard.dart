import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asset_model.dart'; // Import file model vừa tạo

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  // Dữ liệu giả lập (Sau này sẽ lấy từ Database thật)
  List<AssetItem> assets = [
    AssetItem(id: '1', name: 'Tiền mặt & NH', type: 'cash', amount: 1, currentPrice: 150000000, icon: '💵'),
    AssetItem(id: '2', name: 'Vàng SJC', type: 'gold', amount: 5, currentPrice: 82500000, icon: '🌟'), // 5 Lượng
    AssetItem(id: '3', name: 'Bitcoin (BTC)', type: 'crypto', amount: 0.5, currentPrice: 1050000000, icon: '₿'),
    AssetItem(id: '4', name: 'Vinamilk (VNM)', type: 'stock', amount: 1000, currentPrice: 68000, icon: '📈'),
  ];

  double totalNetWorth = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
    _startRealtimeSimulation(); // Bắt đầu giả lập biến động giá
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Hàm tính tổng tài sản
  void _calculateTotal() {
    double total = 0;
    for (var item in assets) {
      total += item.totalValue;
    }
    setState(() {
      totalNetWorth = total;
    });
  }

  // Hàm giả lập giá chạy Real-time (Để anh thấy độ ngầu)
  void _startRealtimeSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // Random giá BTC và Chứng khoán biến động nhẹ
        final random = Random();
        // BTC biến động
        assets[2].currentPrice += (random.nextInt(2000000) - 1000000); 
        // VNM biến động
        assets[3].currentPrice += (random.nextInt(500) - 250);
        
        _calculateTotal();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Nền đen sang trọng
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('AIA FINANCE', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THẺ TỔNG TÀI SẢN (NET WORTH)
            _buildNetWorthCard(),

            const SizedBox(height: 24),

            // 2. CÁC NÚT CHỨC NĂNG NHANH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.add, 'Thu nhập', Colors.green),
                _buildActionButton(Icons.remove, 'Chi tiêu', Colors.red),
                _buildActionButton(Icons.swap_horiz, 'Chuyển', Colors.blue),
                _buildActionButton(Icons.pie_chart, 'Báo cáo', Colors.orange),
              ],
            ),

            const SizedBox(height: 24),

            // 3. DANH SÁCH TÀI SẢN (REAL-TIME)
            Text('Danh mục đầu tư (Live)', style: GoogleFonts.manrope(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 12),
            ...assets.map((e) => _buildAssetItem(e)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNetWorthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)]), // Xanh Finance
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tổng Tài Sản Ròng', style: GoogleFonts.manrope(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            '${_formatCurrency(totalNetWorth)} đ',
            style: GoogleFonts.manrope(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Text('+ 2.5% hôm nay', style: GoogleFonts.manrope(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.manrope(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildAssetItem(AssetItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Text(item.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${item.amount} ${item.type == 'stock' ? 'CP' : ''}', style: GoogleFonts.manrope(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${_formatCurrency(item.totalValue)} đ', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              // Hiệu ứng nhấp nháy giá nếu là tài sản đầu tư
              if (item.type != 'cash')
                Text('Live update', style: GoogleFonts.manrope(color: Colors.greenAccent, fontSize: 10, fontStyle: FontStyle.italic)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    // Định dạng tiền tệ đơn giản (VD: 1.000.000)
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
