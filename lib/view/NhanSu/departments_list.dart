import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepartmentsList extends StatefulWidget {
  @override
  _DepartmentsListState createState() => _DepartmentsListState();
}

class _DepartmentsListState extends State<DepartmentsList> {
  late Future<List<Map<String, dynamic>>> departments;

  @override
  void initState() {
    super.initState();
    departments = fetchDepartments();
  }

  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/PhongBans'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Không thể tải dữ liệu phòng ban');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng ban'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: departments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có phòng ban.'));
          } else {
            List<Map<String, dynamic>> departments = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: departments.length,
              itemBuilder: (context, index) {
                String departmentName = departments[index]['tenPhongBan'] ?? 'Chưa có tên';
                int departmentId = departments[index]['id'] ?? 0;
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepartmentDetailScreen(
                          departmentName: departmentName,
                          departmentId: departmentId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apartment, size: 50, color: Colors.blue),
                          const SizedBox(height: 16),
                          Text(
                            departmentName,
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
              },
            );
          }
        },
      ),
    );
  }
}

class DepartmentDetailScreen extends StatefulWidget {
  final String departmentName;
  final int departmentId;

  DepartmentDetailScreen({required this.departmentName, required this.departmentId});

  @override
  _DepartmentDetailScreenState createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen> {
  late Future<List<Map<String, dynamic>>> employees;

  @override
  void initState() {
    super.initState();
    employees = fetchEmployees(widget.departmentId);
  }

  Future<List<Map<String, dynamic>>> fetchEmployees(int departmentId) async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/NhanViens?phongBanID=$departmentId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        // Truy xuất thông tin từ 'chucVu' và 'phongBan'
        String maNhanVien = item['nhanVienID'] ?? 'Chưa có mã';  // Lấy mã nhân viên
        String hoTen = item['hoTen'] ?? 'Tên không xác định';  // Lấy họ tên
        String chucVu = item['chucVu']['tenChucVu'] ?? 'Chưa có chức vụ';  // Lấy tên chức vụ từ trường 'chucVu'
        String phongBan = item['phongBan']['tenPhongBan'] ?? 'Chưa có phòng ban';  // Lấy tên phòng ban từ trường 'phongBan'

        return {
          'hoTen': hoTen,
          'maNhanVien': maNhanVien,
          'chucVu': chucVu,
          'phongBan': phongBan,
        };
      }).toList();
    } else {
      throw Exception('Không thể tải danh sách nhân viên');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ${widget.departmentName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Sử dụng FutureBuilder
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có nhân viên.'));
          } else {
            List<Map<String, dynamic>> employees = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  String employeeName = employees[index]['hoTen'];
                  String employeeId = employees[index]['maNhanVien'];
                  String employeePosition = employees[index]['chucVu'];
                  String employeeDepartment = employees[index]['phongBan'];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          '$employeeName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã nhân viên: $employeeId',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Chức vụ: $employeePosition',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Phòng ban: $employeeDepartment',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
