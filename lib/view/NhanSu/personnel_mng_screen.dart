import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/NhanSu/human_resources.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListNhanVienScreen extends StatefulWidget {
  @override
  _ListNhanVienScreenState createState() => _ListNhanVienScreenState();
}

class _ListNhanVienScreenState extends State<ListNhanVienScreen> {
  late Future<List<NhanVien>> _attendanceList;
  int? loggedInNhanVienID;

  @override
  void initState() {
    super.initState();
    _getLoggedInNhanVienID();  // Lấy NhanVienID của người dùng đăng nhập
  }

  // Lấy NhanVienID từ SharedPreferences
  Future<void> _getLoggedInNhanVienID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInNhanVienID = prefs.getInt('NhanVienID');
    });

    // Khi đã lấy được NhanVienID, thực hiện tải dữ liệu chấm công
    if (loggedInNhanVienID != null) {
      _attendanceList = _fetchAttendanceByNhanVien(loggedInNhanVienID!);
    }
  }

  Future<List<NhanVien>> _fetchAttendanceByNhanVien(int nhanVienId) async {
  final url = Uri.parse('http://192.168.239.219:5000/api/NhanViens/NhanVien/$nhanVienId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => NhanVien.fromJson(item)).toList();
  } else {
    throw Exception('Không thể lấy dữ liệu chấm công');
  }
}



  // Hàm hỗ trợ để định dạng ngày
  String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd/MM/yyyy HH:mm').format(date) : '--';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin của tôi'),
      ),
      body: loggedInNhanVienID == null
        ? Center(child: CircularProgressIndicator())  // Hiển thị khi chưa lấy được NhanVienID
        : FutureBuilder<List<NhanVien>>(
            future: _attendanceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi khi lấy dữ liệu'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu nhân viên'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final attendance = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Mã nhân viên: ${attendance.nhanVienID}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Text('Tên nhân viên: ${attendance.hoTen}') ,
                      Text('Địa chỉ: ${attendance.diaChi}'),
                      Text('Ngày sinh: ${attendance.ngaySinh.toLocal().toString().split(' ')[0]}'),
                      Text('Chức vụ: ${attendance.chucVuId}'),
                      Text('Số điện thoại: ${attendance.sdt}'),
                      Text('Email: ${attendance.email}'),
                      Text('Phòng ban: ${(attendance.phongBanId)}'),
                      Text('Ngày vào làm: ${attendance.ngayVaoLam.toLocal().toString().split(' ')[0]}'),
                      Text('Trạng thái: ${attendance.trangThaiID}'),
                      Text('Giới tính: ${attendance.gioiTinh}'),
                          ],
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
