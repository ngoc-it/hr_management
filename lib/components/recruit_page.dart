import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:intl/intl.dart';

class RecruitPage extends StatefulWidget {
  const RecruitPage({super.key});

  @override
  State<RecruitPage> createState() => _RecruitPageState();
}

class _RecruitPageState extends State<RecruitPage> {
  // Dữ liệu giả cho bảng tuyển dụng
  List<Map<String, String>> recruitmentData = [
    {
      "Position": "Lập trình viên Flutter",
      "Department": "Phát triển phần mềm",
      "Location": "Hà Nội",
      "Status": "Đang tuyển"
    },
    {
      "Position": "Nhân viên Marketing",
      "Department": "Marketing",
      "Location": "TP HCM",
      "Status": "Đã đóng"
    },
    {
      "Position": "Chuyên viên nhân sự",
      "Department": "Nhân sự",
      "Location": "Đà Nẵng",
      "Status": "Đang tuyển"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hôm nay",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          // Hiển thị ngày hiện tại với định dạng ngày/tháng/năm
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            image: AssetImage("assets/user1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Nút chức năng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Chức năng thêm tin tuyển dụng
                      },
                      child: Text("Thêm tin tuyển dụng"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Chức năng xóa
                      },
                      child: Text("Xóa"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Chức năng cập nhật
                      },
                      child: Text("Cập nhật"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Chức năng tìm kiếm ứng viên
                      },
                      child: Text("Tìm kiếm ứng viên"),
                    ),
                  ],
                ),
              ),

              // Bảng dữ liệu tuyển dụng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Vị trí', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Phòng ban', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Địa điểm', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Hiển thị từng hàng dữ liệu
                    ...recruitmentData.map(
                      (job) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(job["Position"]!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(job["Department"]!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(job["Location"]!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(job["Status"]!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
