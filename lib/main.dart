import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';

// --- IMPORT CÁC MODULE TÍNH NĂNG ---
// (Đảm bảo đường dẫn file đúng như anh em mình đã tạo)
import 'finance/screens/finance_home_screen.dart'; // Module Tài chính (Mới)
import 'calendar/screens/calendar_screen.dart';    // Module Lịch
import 'lottery_screen.dart';                      // Module Xổ số (Ở thư mục gốc lib)
import 'football_screen.dart';                     // Module Bóng đá (Ở thư mục gốc lib)

void main() {
  // 1. Cấu hình Hệ thống (Status Bar trong suốt + Khóa màn hình dọc)
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,       // Thanh trạng thái trong suốt
    statusBarIconBrightness: Brightness.dark, // Icon màu đen (cho nền sáng)
  ));
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,             // Chỉ cho phép màn hình dọc
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AiaMasterApp());
}

class AiaMasterApp extends StatelessWidget {
  const AiaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIA FINANCE PRO',
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG góc phải
      theme: AppTheme.lightTheme,        // Sử dụng bộ theme chuẩn đã định nghĩa
      themeMode: ThemeMode.light,        // Mặc định giao diện Sáng
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

  // --- DANH SÁCH MÀN HÌNH ---
  final List<Widget> _screens = [
    const FinanceHomeScreen(), // Tab 0: Tài chính (Full tính năng)
    const CalendarScreen(),    // Tab 1: Lịch Vạn Niên
    const LotteryScreen(),     // Tab 2: Xổ số & Soi cầu AI
    const FootballScreen(),    // Tab 3: Bóng đá & Kèo nhà cái
    const Center(child: Text("Tài khoản (Đang cập nhật)")), // Tab 4: Cá nhân
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KỸ THUẬT QUAN TRỌNG: IndexedStack
      // Giúp giữ trạng thái màn hình khi chuyển Tab (Không bị load lại dữ liệu)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // THANH ĐIỀU HƯỚNG DƯỚI (NAVIGATION BAR - MATERIAL 3)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Manrope')
            ),
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
                selectedIcon: Icon(Icons.calendar_month, color: Color(0xFFF59E0B)), 
                label: 'Vạn Niên'
              ),
              
              // 3. Xổ Số (Dùng icon vé số)
              NavigationDestination(
                icon: Icon(Icons.confirmation_number_outlined), 
                selectedIcon: Icon(Icons.confirmation_number, color: Colors.redAccent), 
                label: 'Xổ Số'
              ),
              
              // 4. Bóng Đá (Dùng icon quả bóng)
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
