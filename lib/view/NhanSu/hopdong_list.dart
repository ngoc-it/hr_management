import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/HopDong/hopdong_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListHopDongScreen extends StatefulWidget {
  @override
  _ListHopDongScreenState createState() => _ListHopDongScreenState();
}

class _ListHopDongScreenState extends State<ListHopDongScreen> {
  late Future<List<HopDong>> _attendanceList;
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

  Future<List<HopDong>> _fetchAttendanceByNhanVien(int nhanVienId) async {
  final url = Uri.parse('http://192.168.239.219:5000/api/HopDongs/NhanVien/$nhanVienId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => HopDong.fromJson(item)).toList();
  } else {
    throw Exception('Không thể lấy dữ liệu hợp đồng');
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
        title: Text('Hợp đồng của tôi'),
      ),
      body: loggedInNhanVienID == null
        ? Center(child: CircularProgressIndicator())  // Hiển thị khi chưa lấy được NhanVienID
        : FutureBuilder<List<HopDong>>(
            future: _attendanceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi khi lấy dữ liệu'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu hợp đồng'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final attendance = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Tên hợp đồng: ${attendance.tenHopDong}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mã nhân viên: ${attendance.nhanVienId}'),
                      Text('Lương cơ bản: ${attendance.luongCoBan}'),
                      Text('Ghi chú: ${attendance.ghiChu ?? 'Không có ghi chú'}'),
                      Text('Ngày bắt đầu: ${attendance.ngayBatDau.toLocal().toString().split(' ')[0]}'),
                      Text('Ngày kết thúc: ${attendance.ngayKetThuc?.toLocal().toString().split(' ')[0]?? 'Không rõ'}'),
                      Text('Trạng thái: ${attendance.trangThai}'),
                            
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
