import 'package:flutter/material.dart';

// Lớp giao diện Chấm Công
class TimekeepingScreen extends StatelessWidget {
  const TimekeepingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho thông tin nhân viên
    final String hoTen = 'Nguyễn Văn A';
    final String chucVu = 'Nhân viên';
    final String phongBan = 'Phòng Kỹ Thuật';
    
    // Dữ liệu mẫu cho thời gian vào và ra
    final String gioVao = '08:00';
    final String viTriVao = 'Khu vực 1';
    final String gioRa = '17:30';
    final String viTriRa = 'Khu vực 2';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chấm Công'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
                    Text('Họ và Tên: $hoTen', style: TextStyle(fontSize: 16)),
                    Text('Chức vụ: $chucVu', style: TextStyle(fontSize: 16)),
                    Text('Phòng Ban: $phongBan', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Thời gian vào làm
            Text(
              'Thời gian vào làm',
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
                    Text('Giờ Vào: $gioVao', style: TextStyle(fontSize: 16)),
                    Text('Vị Trí: $viTriVao', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Thời gian ra làm
            Text(
              'Thời gian ra làm',
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
                    Text('Giờ Ra: $gioRa', style: TextStyle(fontSize: 16)),
                    Text('Vị Trí: $viTriRa', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nút chấm công
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện chấm công
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Chấm Công'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
