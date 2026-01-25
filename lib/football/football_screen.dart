import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FootballScreen extends StatelessWidget {
  const FootballScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: Text("LỊCH THI ĐẤU", style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _match("Man City", "Arsenal", "2 - 1", "LIVE 78'", Colors.red),
        const SizedBox(height: 12),
        _match("Real Madrid", "Barca", "vs", "22:00", Colors.blue),
        const SizedBox(height: 12),
        _match("Việt Nam", "Thái Lan", "vs", "19:30", Colors.amber),
      ]),
    );
  }
  Widget _match(String h, String a, String s, String t, Color c) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Column(children: [const Icon(Icons.flag, color: Colors.white), Text(h, style: const TextStyle(color: Colors.white))]),
    Column(children: [Text(s, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(t, style: TextStyle(color: c, fontWeight: FontWeight.bold))]),
    Column(children: [const Icon(Icons.flag_circle, color: Colors.white), Text(a, style: const TextStyle(color: Colors.white))]),
  ]));
}
