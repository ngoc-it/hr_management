import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListTinhLuongScreen extends StatefulWidget {
  @override
  _ListTinhLuongScreenState createState() => _ListTinhLuongScreenState();
}

class _ListTinhLuongScreenState extends State<ListTinhLuongScreen> {
  late Future<List<TinhLuong>> _attendanceList;
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

  Future<List<TinhLuong>> _fetchAttendanceByNhanVien(int nhanVienId) async {
  final url = Uri.parse('http://192.168.239.219:5000/api/TinhLuongs/NhanVien/$nhanVienId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => TinhLuong.fromJson(item)).toList();
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
        title: Text('Lương của tôi'),
        backgroundColor: Colors.redAccent,
      ),
      body: loggedInNhanVienID == null
        ? Center(child: CircularProgressIndicator())  // Hiển thị khi chưa lấy được NhanVienID
        : FutureBuilder<List<TinhLuong>>(
            future: _attendanceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi khi lấy dữ liệu'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu chấm công'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final attendance = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Ngày: ${DateFormat('dd/MM/yyyy').format(attendance.thangNam)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tên lương: ${attendance.tenTinhLuong}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Lương thực nhận: ${attendance.luongThucNhan.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Tháng năm: ${attendance.thangNam.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Nhân viên ID: ${attendance.nhanVienId}', style: TextStyle(fontSize: 16)),
            Text('Hợp đồng ID: ${attendance.hopDongId}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Thưởng: ${attendance.thuongIds.join(", ")}', style: TextStyle(fontSize: 16)),
            Text('Phạt: ${attendance.phatIds.join(", ")}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Số ngày công: ${attendance.soNgayCong}', style: TextStyle(fontSize: 16)),
            Text('Số ngày nghỉ có phép: ${attendance.soNgayNghiCoPhep}', style: TextStyle(fontSize: 16)),
            Text('Số ngày nghỉ không phép: ${attendance.soNgayNghiKhongPhep}', style: TextStyle(fontSize: 16)),
                            
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
