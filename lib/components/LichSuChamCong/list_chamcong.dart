import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/worker_details_screen.dart'; // Import ChamCong model
class NhanVien {
  final int id;
  final String nhanVienID;
  final String hoTen;
  final DateTime ngaySinh;
  final String diaChi;
  final String sdt;
  final String email;
  final int phongBanId;
  final int chucVuId;
  final DateTime ngayVaoLam;
  final int trangThaiID;

  NhanVien({
    required this.id,
    required this.nhanVienID,
    required this.hoTen,
    required this.ngaySinh,
    required this.diaChi,
    required this.sdt,
    required this.email,
    required this.phongBanId,
    required this.chucVuId,
    required this.ngayVaoLam,
    required this.trangThaiID,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'] as int,
      nhanVienID: json['nhanVienID'] as String,
      hoTen: json['hoTen'] as String,
      ngaySinh: DateTime.parse(json['ngaySinh'] as String),
      diaChi: json['diaChi'] as String,
      sdt: json['sdt'] as String,
      email: json['email'] as String,
      phongBanId: json['phongBanId'] as int,
      chucVuId: json['chucVuId'] as int,
      ngayVaoLam: DateTime.parse(json['ngayVaoLam'] as String),
      trangThaiID: json['trangThaiID'] as int,
    );
  }
}
class DropdownService {
  static Future<List<NhanVien>> fetchNhanVien() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/NhanViens'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load NhanVien ');
    }
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

class AttendanceListPage extends StatefulWidget {
  const AttendanceListPage({Key? key}) : super(key: key);

  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  late Future<List<ChamCong>> _attendanceList;
  String filterType = 'Day'; // Mặc định lọc theo ngày
  DateTime selectedDate = DateTime.now();
  int? selectedEmployeeId; // Biến lưu ID nhân viên được chọn
  List<NhanVien> _nhanViens = []; // Danh sách nhân viên

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    _attendanceList = fetchAttendanceData();
  }

  Future<void> fetchDropdownData() async {
    _nhanViens = await DropdownService.fetchNhanVien();
    setState(() {});
  }

  Future<List<ChamCong>> fetchAttendanceData() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.239.219:5000/api/ChamCongs"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChamCong.fromJson(json)).toList();
      } else {
        throw Exception('Không thể tải dữ liệu chấm công');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy dữ liệu chấm công: $e');
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "--:--";
    return DateFormat('HH:mm:ss dd/MM/yyyy').format(date);
  }

  List<ChamCong> filterAttendance(List<ChamCong> data) {
    List<ChamCong> filteredData = [];
    for (var attendance in data) {
      if (selectedEmployeeId != null && attendance.NhanVienID != selectedEmployeeId) {
        continue;
      }

      if (filterType == 'Day' && attendance.ngayChamCong.isAtSameMomentAs(selectedDate)) {
        filteredData.add(attendance);
      } else if (filterType == 'Month' && attendance.ngayChamCong.month == selectedDate.month && attendance.ngayChamCong.year == selectedDate.year) {
        filteredData.add(attendance);
      } else if (filterType == 'Year' && attendance.ngayChamCong.year == selectedDate.year) {
        filteredData.add(attendance);
      } else if (filterType == 'All') { // Hiển thị tất cả khi không lọc
        filteredData.add(attendance);
      }
    }
    return filteredData;
  }

  int calculateTotalAttendance(List<ChamCong> filteredData) {
    return filteredData.length;
  }

  double calculateTotalHoursWorked(List<ChamCong> filteredData) {
    double totalHours = 0;
    for (var attendance in filteredData) {
      if (attendance.checkInTime != null && attendance.checkOutTime != null) {
        totalHours += attendance.checkOutTime!.difference(attendance.checkInTime!).inHours.toDouble();
      }
    }
    return totalHours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách chấm công"), backgroundColor: const Color.fromARGB(255, 251, 122, 62)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 247, 196, 76), const Color.fromARGB(255, 254, 243, 93)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown để chọn kiểu lọc (Ngày, Tháng, Năm, Tất cả)
                 Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            value: filterType,
                            onChanged: (String? newValue) {
                              setState(() {
                          filterType = newValue!;
                        });
                      },
                      items: <String>['Day', 'Month', 'Year', 'All']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                                  children: [
                                    Text(value, style: TextStyle(color: Colors.black)),
                                    SizedBox(width: 8),
                                  ]
                          ),
                        );
                      }).toList(),
                    ),
                        ],
                ),
                
                // Nút chọn ngày
                
                
                // Dropdown để chọn nhân viên
                Expanded(
                  flex: 3, // Giảm chiều rộng của dropdown nhân viên
                  child: _nhanViens.isEmpty
                      ? CircularProgressIndicator()  // Hiển thị loading nếu danh sách chưa được tải
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: DropdownButtonFormField<int>(
                            value: selectedEmployeeId,
                            decoration: InputDecoration(labelText: 'Chọn Nhân Viên'),
                            onChanged: (value) {
                              setState(() {
                                selectedEmployeeId = value;
                              });
                            },
                            items: _nhanViens.map((nv) {
                              return DropdownMenuItem<int>(
                                value: nv.id,
                                child: Text(nv.hoTen),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
            ),
          ),
          
          // Dữ liệu chấm công
          FutureBuilder<List<ChamCong>>(
            future: _attendanceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Không có dữ liệu chấm công"));
              } else {
                List<ChamCong> filteredData = filterAttendance(snapshot.data!);
                int totalAttendance = calculateTotalAttendance(filteredData);
                double totalHoursWorked = calculateTotalHoursWorked(filteredData);

                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tổng số lần chấm công: $totalAttendance"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tổng số giờ làm việc: ${totalHoursWorked.toStringAsFixed(2)} giờ"),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final attendance = filteredData[index];
                            return Card(
                              margin: const EdgeInsets.all(10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(attendance.NhanVienID.toString()),
                                ),
                                title: Text("Ngày: ${DateFormat('dd/MM/yyyy').format(attendance.ngayChamCong)}"),
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
                                trailing: Icon(
                                  attendance.checkOutTime != null ? Icons.check_circle : Icons.access_time,
                                  color: attendance.checkOutTime != null ? Colors.green : Colors.orange,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      ),
    );

  }
}
