import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/account_screen.dart';
import 'package:flutter_application_1/assign_work.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  // Tạo PageController để điều khiển PageView
  PageController _pageController = PageController();
  int _selectedIndex = 0; // Chỉ số hiện tại của PageView

  // Hàm điều hướng khi nhấn vào icon
  void _onIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Điều hướng đến trang cụ thể
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                HomeScreen(), // Trang HomeScreen ở đây
                // Thêm các trang khác nếu có
                AssignWorkPage(),
                AccountScreen(),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _onIconTap(0), // Nhấn để mở HomeScreen
                        child: Icon(
                          AntDesign.home,
                          color: _selectedIndex == 0
                              ? Colors.blue // Màu khác khi được chọn
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onIconTap(1), // Nếu bạn có thêm các trang khác
                        child: Icon(
                          AntDesign.carryout,
                          color: _selectedIndex == 1
                              ? Colors.blue
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onIconTap(2),
                        child: Icon(
                          AntDesign.calendar,
                          color: _selectedIndex == 2
                              ? Colors.blue
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onIconTap(3),
                        child: Icon(
                          AntDesign.user,
                          color: _selectedIndex == 3
                              ? Colors.blue
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Giải phóng PageController khi không sử dụng
    super.dispose();
  }
}
