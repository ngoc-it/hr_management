import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListChamCongScreen extends StatefulWidget {
  @override
  _ListChamCongScreenState createState() => _ListChamCongScreenState();
}

class _ListChamCongScreenState extends State<ListChamCongScreen> {
  late Future<List<ChamCong>> _attendanceList;
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

  Future<List<ChamCong>> _fetchAttendanceByNhanVien(int nhanVienId) async {
  final url = Uri.parse('http://192.168.239.219:5000/api/ChamCongs/NhanVien/$nhanVienId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => ChamCong.fromJson(item)).toList();
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
        title: Text('Chấm Công'),
        backgroundColor: Colors.greenAccent,
      ),
      body: loggedInNhanVienID == null
        ? Center(child: CircularProgressIndicator())  // Hiển thị khi chưa lấy được NhanVienID
        : FutureBuilder<List<ChamCong>>(
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
                        title: Text('Ngày: ${DateFormat('dd/MM/yyyy').format(attendance.ngayChamCong)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nhân viên Id: ${attendance.NhanVienID}"),
                            Text("Check-in: ${formatDate(attendance.checkInTime)}"),
                            Text("Check-out: ${formatDate(attendance.checkOutTime)}"),
                            if (attendance.ViTriCheckIn != null)
                              Text("Vị trí Check-in: ${attendance.ViTriCheckIn}"),
                            if (attendance.ViTriCheckOut != null)
                              Text("Vị trí Check-out: ${attendance.ViTriCheckOut}"),
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


class ChamCong {
  int id;
  int NhanVienID;
  DateTime ngayChamCong;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String? ViTriCheckIn;
  String? ViTriCheckOut;

  ChamCong({
    required this.id,
    required this.NhanVienID,
    required this.ngayChamCong,
    this.checkInTime,
    this.checkOutTime,
    this.ViTriCheckIn,
    this.ViTriCheckOut,
  });

  factory ChamCong.fromJson(Map<String, dynamic> json) {
    return ChamCong(
      id: json['id'],
      NhanVienID: json['nhanVienID'] ?? 0,
      ngayChamCong: DateTime.parse(json['ngayChamCong']),
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      ViTriCheckIn: json['viTriCheckIn'],
      ViTriCheckOut: json['viTriCheckOut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "NhanVienID": NhanVienID,
      "ngayChamCong": ngayChamCong.toIso8601String(),
      "checkInTime": checkInTime?.toIso8601String(),
      "checkOutTime": checkOutTime?.toIso8601String(),
      "ViTriCheckIn": ViTriCheckIn,
      "ViTriCheckOut": ViTriCheckOut,
    };
  }
}
