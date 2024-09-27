import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? selectedStartDate; // Biến để lưu trữ ngày bắt đầu đã chọn
  DateTime? selectedEndDate; // Biến để lưu trữ ngày kết thúc đã chọn
  final TextEditingController startDateController = TextEditingController(); // Controller cho TextField ngày bắt đầu
  final TextEditingController endDateController = TextEditingController(); // Controller cho TextField ngày kết thúc

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
        startDateController.text = "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}"; // Cập nhật giá trị cho TextField
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
        endDateController.text = "${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}"; // Cập nhật giá trị cho TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Công Việc'),
        actions: [
          MaterialButton(
            onPressed: () {
              // Khi người dùng nhấn vào nút xong
              // _saveProject();
            },
            child: Text(
              'Xong',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
              'Tên công việc*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên công việc',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ngày bắt đầu*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Thêm khoảng cách giữa nhãn và TextField
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController, // Sử dụng controller để hiển thị ngày đã chọn
                    readOnly: true, // Làm cho TextField không thể nhập
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn ngày bắt đầu',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today), // Biểu tượng lịch
                        onPressed: () => _selectStartDate(context), // Mở DatePicker khi nhấn vào biểu tượng
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
            SizedBox(height: 8), // Thêm khoảng cách giữa nhãn và TextField
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: endDateController, // Sử dụng controller để hiển thị ngày đã chọn
                    readOnly: true, // Làm cho TextField không thể nhập
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn ngày kết thúc',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today), // Biểu tượng lịch
                        onPressed: () => _selectEndDate(context), // Mở DatePicker khi nhấn vào biểu tượng
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Mô tả công việc*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              maxLines: null, // Cho phép TextField mở rộng theo nội dung
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mô tả công việc',
                alignLabelWithHint: true, // Đảm bảo hint nằm ở trên
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Điều chỉnh padding
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
