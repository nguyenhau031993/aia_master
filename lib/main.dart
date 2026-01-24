import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
// Import các màn hình (Anh nhớ sửa đường dẫn nếu báo lỗi)
import 'finance/screens/finance_dashboard.dart'; 
import 'calendar/screens/calendar_screen.dart';
// import 'social/social_screen.dart'; // (Sẽ làm sau)

void main() {
  // Đặt chế độ trong suốt cho thanh trạng thái (Status Bar) nhìn cho sang
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const AiaMasterApp());
}

class AiaMasterApp extends StatelessWidget {
  const AiaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIA MASTER',
      debugShowCheckedModeBanner: false, // Tắt chữ Debug góc phải
      theme: AppTheme.lightTheme, // Áp dụng bộ diện thương hiệu
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
  
  // Danh sách các màn hình chính
  final List<Widget> _screens = [
    const FinanceDashboard(), // Màn 1: Tài chính (MISA Style)
    const CalendarScreen(),   // Màn 2: Lịch Vạn Niên
    const Center(child: Text("Cộng đồng - Sắp ra mắt")), // Màn 3: Vote (Polymarket)
    const Center(child: Text("Tài khoản VIP")), // Màn 4: Cá nhân
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Giữ trạng thái màn hình khi chuyển tab (Không bị load lại)
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)], // Đổ bóng nhẹ
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: Colors.white,
          indicatorColor: AppColors.accent.withOpacity(0.2), // Màu nền khi chọn
          destinations: const [
            NavigationDestination(icon: Icon(Icons.pie_chart_outline), selectedIcon: Icon(Icons.pie_chart), label: 'Tài chính'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Vạn Niên'),
            NavigationDestination(icon: Icon(Icons.poll_outlined), selectedIcon: Icon(Icons.poll), label: 'Thị trường'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Tài khoản'),
          ],
        ),
      ),
      // Nút Action Nổi (Floating Action Button) ở giữa để thao tác nhanh (Chuẩn Fintech)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mở nhanh tính năng Ghi chép hoặc Trade
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Nằm giữa thanh điều hướng
    );
  }
}
