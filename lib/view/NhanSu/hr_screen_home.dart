import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/NhanSu/departments_list.dart';
import 'package:flutter_application_1/view/NhanSu/personnel_mng_screen.dart';
import 'package:flutter_application_1/view/NhanSu/hopdong_list.dart';
class HRScreenHome extends StatelessWidget {
  const HRScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhân Sự'),
        backgroundColor: Colors.blueAccent, // Màu của AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Hai cột
          mainAxisSpacing: 16, // Khoảng cách giữa các hàng
          crossAxisSpacing: 16, // Khoảng cách giữa các cột
          children: [
            _buildOptionCard(
              context,
              "Phòng ban",
              Icons.apartment,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepartmentsList()), // Không cần const ở đây
                );
                // Điều hướng đến trang quản lý phòng ban
              },
            ),
            _buildOptionCard(
              context,
              "Nhân viên",
              Icons.person,
              Colors.green,
              () {
                // Điều hướng đến trang quản lý nhân viên
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListNhanVienScreen()), // Không cần const ở đây
                );
              },
            ),
            _buildOptionCard(
              context,
              "Hợp đồng",
              Icons.assignment,
              Colors.orange,
              () {
                // Điều hướng đến trang quản lý hợp đồng
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListHopDongScreen()), // Không cần const ở đây
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
