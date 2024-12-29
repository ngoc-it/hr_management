import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Tuyendung/create_vacancies.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:intl/intl.dart';

class RecruitmentManagement extends StatefulWidget {
  const RecruitmentManagement({super.key});

  @override
  State<RecruitmentManagement> createState() => _RecruitmentManagement();
}

class _RecruitmentManagement extends State<RecruitmentManagement> {
  String? selectedValue;
  String? selectedChildValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              SizedBox(height: 20),
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Filters and Data Table
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        hint: Text("Lọc theo"),
                        value: selectedValue,
                        items: [
                          DropdownMenuItem(
                            value: "TenNV",
                            child: Text("Họ tên"),
                          ),
                          DropdownMenuItem(
                            value: "Vitri",
                            child: Text("Vị trí"),
                          ),
                          DropdownMenuItem(
                            value: "Congviec",
                            child: Text("Công việc"),
                          ),
                          DropdownMenuItem(
                            value: "Kinhnghiem",
                            child: Text("Kinh nghiệm"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            selectedChildValue = null;
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      DropdownButton<String>(
                        hint: Text("Trạng thái"),
                        items: [
                          DropdownMenuItem(
                            value: "CH",
                            child: Text("Còn hạn"),
                          ),
                          DropdownMenuItem(
                            value: "HH",
                            child: Text("Hết hạn"),
                          ),
                        ],
                        onChanged: (value) {
                          // Logic xử lý khi chọn trạng thái
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Updated Data Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.grey.shade200,
                  ),
                  columns: [
                    DataColumn(label: Text("Họ tên")),
                    DataColumn(label: Text("Số điện thoại")),
                    DataColumn(label: Text("Vị trí làm việc")),
                    DataColumn(label: Text("Công việc")),
                    DataColumn(label: Text("Trạng thái")),
                    DataColumn(label: Text("Số năm kinh nghiệm")),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text("Dương Nhật Phi")),
                      DataCell(Text("0123456789")),
                      DataCell(Text("Quản lý")),
                      DataCell(Text("Phát triển kinh doanh")),
                      DataCell(Text("Còn hạn")),
                      DataCell(Text("5 năm")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Nguyễn Quách Mai Trang")),
                      DataCell(Text("0123456788")),
                      DataCell(Text("Nhân viên")),
                      DataCell(Text("Thiết kế đồ họa")),
                      DataCell(Text("Hết hạn")),
                      DataCell(Text("3 năm")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Nguyễn Hoài Ân")),
                      DataCell(Text("0123456787")),
                      DataCell(Text("Nhân viên")),
                      DataCell(Text("Hỗ trợ kỹ thuật")),
                      DataCell(Text("Còn hạn")),
                      DataCell(Text("2 năm")),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateVacanciesPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
