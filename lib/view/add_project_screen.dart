import 'package:flutter/material.dart';

class AddProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Dự Án'),
        actions: [
          TextButton(
            onPressed: () {
              // Khi người dùng nhấn vào nút "Xong", hàm _saveProject sẽ được gọi
             // _saveProject(); // Gọi hàm lưu dự án
            },
            child: Text(
              'Xong', // Nội dung hiển thị trên nút
              style: TextStyle(
                color: Colors.white, // Màu chữ trắng để phù hợp với nền AppBar (thường tối màu)
                fontWeight: FontWeight.bold, // Đặt chữ "Xong" đậm hơn
              ),
            ),
          ),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên dự án *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên dự án',
              ),
            ),
            SizedBox(height: 16),
            // Các trường khác như Chi nhánh, Phòng ban, v.v.
            ListTile(
              title: Text('Phòng ban'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Hành động khi chọn phòng ban
              },
            ),
            Divider(),
            ListTile(
              title: Text('Chức vụ'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Hành động khi chọn chức vụ
              },
            ),
            Divider(),
             ListTile(
              title: Text('Nhân viên'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Hành động khi chọn nhân viên
                // Gọi API để lấy danh sách nhân viên
              },
            ),
            // Thêm các mục như Chức vụ, Nhân viên, v.v.
          ],
        ),
      ),
    );
  }
}
