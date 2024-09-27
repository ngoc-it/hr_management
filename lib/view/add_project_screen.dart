import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(), // Ngày khởi tạo là ngày hiện tại hoặc ngày đã chọn
      firstDate: DateTime(2000), // Ngày bắt đầu có thể chọn
      lastDate: DateTime(2101), // Ngày kết thúc có thể chọn
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked; // Cập nhật ngày đã chọn
        startDateController.text =
            "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}"; // Cập nhật giá trị cho TextField
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(), // Ngày khởi tạo là ngày hiện tại hoặc ngày đã chọn
      firstDate: selectedStartDate ?? DateTime(2000), // Ngày bắt đầu có thể chọn không nhỏ hơn ngày bắt đầu
      lastDate: DateTime(2101), // Ngày kết thúc có thể chọn
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked; // Cập nhật ngày đã chọn
        endDateController.text =
            "${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}"; // Cập nhật giá trị cho TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Dự Án'),
        actions: [
          MaterialButton(
            onPressed: () {
              // Khi người dùng nhấn vào nút "Xong", hàm _saveProject sẽ được gọi
              // _saveProject(); // Gọi hàm lưu dự án
            },
            child: Text(
              'Xong', // Nội dung hiển thị trên nút
              style: TextStyle(
                color: const Color.fromARGB(255, 41, 0, 189), // Màu chữ
                fontWeight: FontWeight.bold, // Chữ đậm
                fontSize: 20, // Tăng kích thước chữ lên 20
              ),
            ),
          ),
        ],
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
            SizedBox(height: 10),
            Text(
              'Ngày bắt đầu*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn ngày bắt đầu',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectStartDate(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Ngày kết thúc*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn ngày kết thúc',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectEndDate(context),
                      ),
                    ),
                  ),
                ),
              ],
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
