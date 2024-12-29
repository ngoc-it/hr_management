import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/components/add_human_resources.dart';
import 'package:flutter_application_1/components/recruit_page.dart';
import 'package:intl/intl.dart';

class HumanResources extends StatefulWidget {
  const HumanResources({super.key});

  @override
  State<HumanResources> createState() => _HumanResourcesState();
}

class _HumanResourcesState extends State<HumanResources> {
  String? selectedValue;
  String? selectedChildValue;
  bool showSubOptions = false;
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
                      ])),
              Container(
                height: MediaQuery.of(context).size.height * 0.82,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.file_upload,
                                            size: 20,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Tải dữ liệu",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "6 bản",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.print,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "In dữ liệu",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "14 bản",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Danh sách tài khoản",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "132 tài khoản",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Container(
                              width: 170,
                              height: 40,
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
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hàng chứa bộ lọc đầu tiên và bộ lọc trạng thái
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Bộ lọc đầu tiên
                                DropdownButton<String>(
                                  hint: Text("Lọc theo"),
                                  value: selectedValue,
                                  items: [
                                    DropdownMenuItem(
                                      value: "MaNV",
                                      child: Text("Mã nhân viên"),
                                    ),
                                    DropdownMenuItem(
                                      value: "TenNV",
                                      child: Text("Tên nhân viên"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Phongban",
                                      child: Text("Phòng ban"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Chucvu",
                                      child: Text("Chức vụ"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                      selectedChildValue =
                                          null; // Reset selected child value
                                    });
                                  },
                                ),

                                // Khoảng cách giữa hai bộ lọc
                                SizedBox(width: 16),

                                // Bộ lọc trạng thái
                                DropdownButton<String>(
                                  hint: Text("Trạng thái"),
                                  items: [
                                    DropdownMenuItem(
                                      value: "DHD",
                                      child: Text("Đang hoạt động"),
                                    ),
                                    DropdownMenuItem(
                                      value: "KHD",
                                      child: Text("Không hoạt động"),
                                    ),
                                    DropdownMenuItem(
                                      value: "NV",
                                      child: Text("Nghỉ việc"),
                                    ),
                                    DropdownMenuItem(
                                      value: "CLV",
                                      child: Text("Chưa làm việc"),
                                    ),
                                    DropdownMenuItem(
                                      value: "All",
                                      child: Text("Tất cả"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    // Logic xử lý khi chọn trạng thái
                                  },
                                ),
                              ],
                            ),
                            if (selectedValue == "MaNV" ||
                                selectedValue == "TenNV")
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8), // Thêm khoảng cách trên
                                child: Container(
                                  width: 200, // Giới hạn chiều rộng ô nhập
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: selectedValue == "MaNV"
                                          ? "Nhập mã nhân viên"
                                          : "Nhập tên nhân viên",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            // Hiển thị danh sách lựa chọn con nếu đã chọn "Phongban"
                            if (selectedValue == "Phongban")
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8), // Thêm khoảng cách trên
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text("Nhân sự"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "NS"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Ai Ti"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "IT"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Ban thiết kế"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "TK"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Bán hàng"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "BH"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Marketing"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "MKT"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Kế toán"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "KT"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            if (selectedValue == "Chucvu")
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8), // Thêm khoảng cách trên
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text("Giám đốc"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "GĐ"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Quản lý"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "Quản lý"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Trưởng phòng"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "TP"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Nhân viên"),
                                      onTap: () {
                                        setState(() {
                                          selectedChildValue =
                                              "NV"; // Lưu giá trị đã chọn
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Cuộn theo chiều ngang
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.grey.shade200,
                            ),
                            columns: [
                              DataColumn(
                                label: Container(
                                    width: 100, child: Text("Mã nhân viên")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 200, child: Text("Tên nhân viên ")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 140, child: Text("Số điện thoại")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 140, child: Text("Trạng thái")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 140, child: Text("Chức vụ")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 142, child: Text("Phòng ban")),
                              ),
                              DataColumn(
                                label: Container(
                                    width: 70, child: Text("Tính năng")),
                              ),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text("001")),
                                DataCell(Text("Dương Nhật Phi")),
                                DataCell(Text("0123456789")),
                                DataCell(Text("Đang hoạt động")),
                                DataCell(Text("Quản lý")),
                                DataCell(Text("Ban quản lý")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Căn giữa các biểu tượng
                                    children: [
                                      Icon(Icons.delete),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("002")),
                                DataCell(Text("Nguyễn Quách Mai Trang")),
                                DataCell(Text("0123456788")),
                                DataCell(Text("Không hoạt động")),
                                DataCell(Text("Nhân viên")),
                                DataCell(Text("Ban thiết kế")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Căn giữa các biểu tượng
                                    children: [
                                      Icon(Icons.delete),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("003")),
                                DataCell(Text("Nguyễn Hoài Ân")),
                                DataCell(Text("0123456787")),
                                DataCell(Text("Nghỉ việc")),
                                DataCell(Text("Nhân viên")),
                                DataCell(Text("Ban IT")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Căn giữa các biểu tượng
                                    children: [
                                      Icon(Icons.delete),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("004")),
                                DataCell(Text("Trần Thanh Trạng")),
                                DataCell(Text("0123456786")),
                                DataCell(Text("Chưa làm việc")),
                                DataCell(Text("Nhân viên")),
                                DataCell(Text("Ban nhân sự")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Căn giữa các biểu tượng
                                    children: [
                                      Icon(Icons.delete),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("005")),
                                DataCell(Text("Lê Quang Minh")),
                                DataCell(Text("0123456785")),
                                DataCell(Text("Đang hoạt động")),
                                DataCell(Text("Nhân viên")),
                                DataCell(Text("Ban bán hàng")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Căn giữa các biểu tượng
                                    children: [
                                      Icon(Icons.delete),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddHumanResources();
                    },
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
