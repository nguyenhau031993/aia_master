import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';

// --- IMPORT CÁC MODULE (Sửa đường dẫn đúng theo cấu trúc folder trên) ---
import 'finance/screens/finance_dashboard.dart'; 
import 'calendar/screens/calendar_screen.dart';
import 'lottery/screens/lottery_screen.dart';    // Nhớ tạo folder lottery/screens
import 'football/screens/football_screen.dart';  // Nhớ tạo folder football/screens

void main() {
  // 1. Cấu hình Hệ thống (Full màn hình, Status Bar trong suốt)
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,        // Trong suốt
    statusBarIconBrightness: Brightness.dark,  // Icon màu đen
    systemNavigationBarColor: Colors.white,    // Thanh điều hướng dưới màu trắng
  ));
  
  // Khóa màn hình dọc (App tài chính không nên xoay ngang)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AiaMasterApp());
}

class AiaMasterApp extends StatelessWidget {
  const AiaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIA MASTER APP',
      debugShowCheckedModeBanner: false, // Tắt chữ Debug góc phải
      theme: AppTheme.lightTheme,        // Sử dụng bộ theme chuẩn
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // --- DANH SÁCH MÀN HÌNH (Theo thứ tự Tab) ---
  final List<Widget> _screens = [
    const FinanceDashboard(), // Tab 0: Tài chính
    const CalendarScreen(),   // Tab 1: Vạn Niên
    const LotteryScreen(),    // Tab 2: Xổ Số (Full tính năng)
    const FootballScreen(),   // Tab 3: Bóng Đá
    const Center(child: Text("Tài khoản VIP")), // Tab 4: Cá nhân
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KỸ THUẬT QUAN TRỌNG: IndexedStack
      // Giúp App KHÔNG bị load lại dữ liệu khi chuyển qua lại giữa các Tab
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // THANH ĐIỀU HƯỚNG DƯỚI (NAVIGATION BAR - MATERIAL 3)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 20, 
              offset: const Offset(0, -5)
            )
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Manrope', color: Color(0xFF0F172A));
              }
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Manrope', color: Colors.grey);
            }),
          ),
          child: NavigationBar(
            height: 70, // Chiều cao chuẩn thao tác ngón tay
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFF59E0B).withOpacity(0.15), // Màu Vàng Gold nhạt khi chọn
            
            destinations: const [
              // 1. Tài chính
              NavigationDestination(
                icon: Icon(Icons.pie_chart_outline), 
                selectedIcon: Icon(Icons.pie_chart, color: Color(0xFF0F172A)), 
                label: 'Tài chính'
              ),
              
              // 2. Vạn Niên
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined), 
                selectedIcon: Icon(Icons.calendar_month, color: Color(0xFF0F172A)), 
                label: 'Vạn Niên'
              ),
              
              // 3. Xổ Số
              NavigationDestination(
                icon: Icon(Icons.confirmation_number_outlined), 
                selectedIcon: Icon(Icons.confirmation_number, color: Colors.redAccent), 
                label: 'Xổ Số'
              ),
              
              // 4. Bóng Đá
              NavigationDestination(
                icon: Icon(Icons.sports_soccer_outlined), 
                selectedIcon: Icon(Icons.sports_soccer, color: Colors.green), 
                label: 'Bóng Đá'
              ),
              
              // 5. Cá nhân
              NavigationDestination(
                icon: Icon(Icons.person_outline), 
                selectedIcon: Icon(Icons.person, color: Colors.blue), 
                label: 'Cá nhân'
              ),
            ],
          ),
        ),
      ),
    );
  }
}
