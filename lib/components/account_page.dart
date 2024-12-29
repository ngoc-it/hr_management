import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _HumanResourcesState();
}

class _HumanResourcesState extends State<AccountPage> {
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
                                            Icons.file_copy,
                                            size: 20,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Sao chép",
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "32 lần",
                                        style: TextStyle(
                                          color: Colors.amber,
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
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Xóa tất cả",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "12 lần",
                                        style: TextStyle(
                                          color: Colors.green,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: DropdownButton(
                                      hint: Text("Lọc theo"),
                                      items: [
                                        DropdownMenuItem(
                                          value: "ID",
                                          child: Text("ID"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Tên tài khoản",
                                          child: Text("Tên tài khoản"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Trạng thái",
                                          child: Text("Trạng thái"),
                                        ),
                                      ],
                                      onChanged: (value) {}),
                                ),
                              ],
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
                              DataColumn(label: Container(
                                width: 20,
                                child: Text("ID")),
                              ),
                              DataColumn(label: Container(
                                width: 140,
                                child: Text("Tên tài khoản")),
                              ),
                              DataColumn(label: Container(
                                width: 140,
                                child: Text("Email")),
                              ),
                              DataColumn(label: Container(
                                width: 140,
                                child: Text("Mật khẩu")),
                              ),
                             DataColumn(label: Container(
                                width: 142,
                                child: Text("Trạng thái tài khoản")),
                              ),
                              DataColumn(label: Container(
                                width: 70,
                                child: Text("Tính năng")),
                              ),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text("01")),
                                DataCell(
                                    Text("Alola")),
                                DataCell(Text("Alola@gmail.com")),
                                DataCell(Text("**********")),
                                DataCell(Text("Đang hoạt động")),
                                DataCell(
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa các biểu tượng
                                  children: [
                                    Icon(Icons.delete),
                                    Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("02")),
                                DataCell(
                                    Text("Alolu")),
                                DataCell(Text("Alolu@gmail.com")),
                                DataCell(Text("**********")),
                                DataCell(Text("Đang nghỉ")),
                                 DataCell(
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa các biểu tượng
                                  children: [
                                    Icon(Icons.delete),
                                    Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("03")),
                                DataCell(
                                    Text("Aloli")),
                                DataCell(Text("Aloli@gmail.com")),
                                DataCell(Text("**********")),
                                DataCell(Text("Ngừng hoạt động")),
                                 DataCell(
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa các biểu tượng
                                  children: [
                                    Icon(Icons.delete),
                                    Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("04")),
                                DataCell(
                                    Text("Alole")),
                                DataCell(Text("Alole@gmail.com")),
                                DataCell(Text("**********")),
                                DataCell(Text("Đang hoạt động")),
                                 DataCell(
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa các biểu tượng
                                  children: [
                                    Icon(Icons.delete),
                                    Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("05")),
                                DataCell(
                                    Text("Alolo")),
                                DataCell(Text("Alolo@gmail.com")),
                                DataCell(Text("**********")),
                                DataCell(Text("Đang hoạt động")),
                                 DataCell(
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa các biểu tượng
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
                onPressed: () {},
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
