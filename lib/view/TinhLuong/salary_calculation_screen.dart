import 'package:flutter/material.dart';

class SalaryCalculationScreen extends StatelessWidget {
  const SalaryCalculationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tính Lương'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin nhân viên
            Text(
              'Thông tin nhân viên',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Họ và Tên: Nguyễn Văn A', style: TextStyle(fontSize: 16)),
                    Text('Chức vụ: Nhân viên', style: TextStyle(fontSize: 16)),
                    Text('Phòng Ban: Phòng Kỹ Thuật', style: TextStyle(fontSize: 16)),
                    Text('Lương Cơ Bản: 5,000,000 VNĐ', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Thông tin tính lương
            Text(
              'Thông tin tính lương',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Số Ngày Làm: 22', style: TextStyle(fontSize: 16)),
                    Text('Số Giờ Tăng Ca: 10', style: TextStyle(fontSize: 16)),
                    Text('Tổng Lương: 7,000,000 VNĐ', style: TextStyle(fontSize: 16)), // Có thể tính toán sau
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nút tính lương
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện tính lương
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Tính Lương'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
