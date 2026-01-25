import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LotteryScreen extends StatelessWidget {
  const LotteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF111827),
        appBar: AppBar(
          title: Text('KẾT QUẢ XỔ SỐ', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent, elevation: 0,
          bottom: const TabBar(indicatorColor: Colors.red, labelColor: Colors.red, unselectedLabelColor: Colors.white60, tabs: [Tab(text: "3 MIỀN"), Tab(text: "VIETLOTT"), Tab(text: "SOI CẦU")]),
        ),
        body: TabBarView(children: [
          ListView(padding: const EdgeInsets.all(16), children: [
            _card("MIỀN BẮC (18:30)", "ĐB: 82910", "Giải Nhất: 82711", Colors.red),
            const SizedBox(height: 10),
            _card("MIỀN NAM (16:15)", "ĐB: 928372", "Giải Nhất: 128371", Colors.blue),
          ]),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Jackpot 1", style: TextStyle(color: Colors.white70)),
            const Text("128 TỶ", style: TextStyle(color: Colors.amber, fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [05,12,28,33,41,45].map((e)=>Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text("$e", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))).toList())
          ])),
          const Center(child: Text("AI Đang phân tích cầu lô...", style: TextStyle(color: Colors.greenAccent))),
        ]),
      ),
    );
  }

  Widget _card(String title, String db, String g1, Color c) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Divider(color: Colors.white10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(db, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 18)), Text(g1, style: const TextStyle(color: Colors.white70))])]));
}
