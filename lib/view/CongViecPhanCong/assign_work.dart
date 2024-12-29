import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PhanCong/Assignment_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/components/DanhGia/evaluate_screen.dart';
class ApiService {
  // Lấy công việc của người được phân công
Future<List<PhanCong>> getPhanCongsByNguoiDuocPhanCongId(int userId) async {
  final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/PhanCongs/nguoiDuocPhanCong/$userId'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => PhanCong.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load PhanCongs');
  }
}
Future<double?> getEvaluationScoreByPhanCongId(int phanCongId) async {
  final response = await http.get(
    Uri.parse('http://192.168.239.219:5000/api/DanhGias/PhanCong/$phanCongId'),
    headers: {'accept': 'application/json'}, // Đảm bảo API nhận đúng header
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    print("Decoded JSON: $jsonResponse"); // Thêm log này để kiểm tra phản hồi JSON
    if (jsonResponse.isNotEmpty) {
      return (jsonResponse[0]['diemDanhGia'] as num).toDouble();
    }
    return null; // Không có đánh giá
  } else if (response.statusCode == 404) {
    return null; // Không có đánh giá
  } else {
    throw Exception('Failed to load evaluation score');
  }
}


}

class CongViecDuocPhanCongScreen extends StatefulWidget {
  @override
  _CongViecDuocPhanCongScreenState createState() =>
      _CongViecDuocPhanCongScreenState();
}

class _CongViecDuocPhanCongScreenState extends State<CongViecDuocPhanCongScreen> {
  List<PhanCong> phanCongs = [];
  bool isLoading = true;
  late int userId;

  // Các bộ lọc trạng thái và thời gian
  String selectedStatus = 'Tất cả';
  String selectedMonth = 'Tất cả';
  String selectedYear = 'Tất cả';

  List<String> statusOptions = ['Tất cả', 'Chưa bắt đầu', 'Đang thực hiện', 'Hoàn thành'];
  List<String> monthOptions = ['Tất cả', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  List<String> yearOptions = ['Tất cả', '2023', '2024', '2025','2026','2027','2028'];

  @override
  void initState() {
    super.initState();
    _getUserIdFromSharedPreferences();
  }

  // Lấy userId từ SharedPreferences
  _getUserIdFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('NhanVienID') ?? 0;  // Nếu không có ID người dùng, đặt là 0
    _fetchPhanCongs();
  }

  // Lấy danh sách công việc phân công
  _fetchPhanCongs() async {
    try {
      ApiService apiService = ApiService();
      List<PhanCong> fetchedPhanCongs = await apiService.getPhanCongsByNguoiDuocPhanCongId(userId);
      setState(() {
        phanCongs = fetchedPhanCongs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  // Lọc công việc dựa trên các bộ lọc
  List<PhanCong> _filterPhanCongs() {
    return phanCongs.where((phanCong) {
      // Lọc theo trạng thái
      bool statusMatch = (selectedStatus == 'Tất cả') || (phanCong.trangThai == selectedStatus);

      // Lọc theo tháng
      bool monthMatch = (selectedMonth == 'Tất cả') || (DateFormat('MM').format(phanCong.ngayBatDau!) == selectedMonth);

      // Lọc theo năm
      bool yearMatch = (selectedYear == 'Tất cả') || (DateFormat('yyyy').format(phanCong.ngayBatDau!) == selectedYear);

      return statusMatch && monthMatch && yearMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<PhanCong> filteredPhanCongs = _filterPhanCongs();

    return Scaffold(
      appBar: AppBar(
        title: Text("Công việc của tôi"),
        actions: [
          // Dropdowns for filtering by status, month, and year
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
            itemBuilder: (context) {
              return statusOptions.map((String status) {
                return PopupMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
        backgroundColor: Colors.pinkAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Dropdown for month filter
                    DropdownButton<String>(
                      value: selectedMonth,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                      },
                      items: monthOptions.map((String month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text('Tháng: $month'),
                        );
                      }).toList(),
                    ),
                    // Dropdown for year filter
                    DropdownButton<String>(
                      value: selectedYear,
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                      items: yearOptions.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text('Năm: $year'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Hiển thị danh sách công việc đã lọc
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPhanCongs.length,
                    itemBuilder: (context, index) {
                      final phanCong = filteredPhanCongs[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(phanCong.tenCongViecPhanCong),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ngày bắt đầu: ${DateFormat('yyyy-MM-dd').format(phanCong.ngayBatDau!)}'),
                              Text('Ngày hoàn thành: ${DateFormat('yyyy-MM-dd').format(phanCong.ngayHoanThanh!)}'),
                              Text('Trạng thái: ${phanCong.trangThai}'),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Khi người dùng nhấn vào công việc, bạn có thể đưa họ đến trang chi tiết công việc
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(phanCong: phanCong),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TaskDetailScreen extends StatefulWidget {
  final PhanCong phanCong;

  TaskDetailScreen({required this.phanCong});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  double? evaluationScore;

  @override
  void initState() {
    super.initState();
_fetchEvaluationScore() ;
  }

  void _fetchEvaluationScore() async {
  try {
    ApiService apiService = ApiService();
    double? score = await apiService.getEvaluationScoreByPhanCongId(widget.phanCong.id);
    print("Fetched evaluation score: $score"); // Kiểm tra giá trị trả về
    print("Calling API for phanCongId: ${widget.phanCong.phanCongId}");
    print("API URL: http://192.168.239.219:5000/api/DanhGias/PhanCong/${widget.phanCong.id}");

    setState(() {
      evaluationScore = score;
    });
  } catch (e) {
    print("Error fetching evaluation score: $e");
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phanCong.tenCongViecPhanCong),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên công việc: ${widget.phanCong.tenCongViecPhanCong}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Ngày bắt đầu: ${DateFormat('yyyy-MM-dd').format(widget.phanCong.ngayBatDau!)}'),
            SizedBox(height: 10),
            Text('Ngày hoàn thành: ${DateFormat('yyyy-MM-dd').format(widget.phanCong.ngayHoanThanh!)}'),
            SizedBox(height: 10),
            Text('Người phân công: ${widget.phanCong.nguoiPhanCongId}'),
            SizedBox(height: 10),
            Text('Trạng thái: ${widget.phanCong.trangThai}'),
            SizedBox(height: 10),
            Text('Ghi chú: ${widget.phanCong.ghiChu ?? 'Không có ghi chú'}'),
            SizedBox(height: 10),
            // Display evaluation score if available
            evaluationScore != null
    ? Text(
        'Điểm đánh giá: ${evaluationScore!.toStringAsFixed(1)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )
    : Text(
        'Chưa được đánh giá',
        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      ),

          ],
        ),
      ),
    );
  }
}

class DanhGia {
  int id;
  int danhGiaId;
  int phanCongId;
  double dienDanhGia;
  int nguoiDanhGiaId;
  String? ghiChu;
  String? tenCongViecPhanCong; // Added
  String? hoTen;
   DateTime ngayDanhGia; // Parse this from a string if necessary // Added
  DanhGia({
    required this.ngayDanhGia,
    required this.id,
    required this.danhGiaId,
    required this.phanCongId,
    required this.dienDanhGia,
    required this.nguoiDanhGiaId,
    required this.ghiChu,
    this.tenCongViecPhanCong, // Added
    this.hoTen, // Added
  });
  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      ngayDanhGia: json['ngayDanhGia'] != null && json['ngayDanhGia'].isNotEmpty
    ? DateTime.parse(json['ngayDanhGia'])
    : DateTime.now(),

      id: json['id'] as int,
      danhGiaId: json['danhGiaId'] as int,
      phanCongId: json['phanCongId'] as int,
      dienDanhGia:(json['diemDanhGia'] as num).toDouble(), // Chuyển đổi thành double
      nguoiDanhGiaId: json['nguoiDanhGiaId'] as int,
      ghiChu: json['ghiChu'] as String?,
      tenCongViecPhanCong: json['tenCongViecPhanCong'] as String?, // Added
      hoTen: json['hoTen'] as String?, // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'danhGiaId': danhGiaId,
      'phanCongId': phanCongId,
      'diemDanhGia': dienDanhGia,
      'nguoiDanhGiaId': nguoiDanhGiaId,
      'ghiChu': ghiChu ?? '',
      'tenCongViecPhanCong': tenCongViecPhanCong, // Added
      'hoTen': hoTen, // Added
      'ngayDanhGia': ngayDanhGia.toIso8601String()
    };
  }
}

class PhanCong {
  int id;
  int phanCongId;
  int congViecId;
  String tenCongViecPhanCong;
  int nguoiDuocPhanCongId;
  int nguoiPhanCongId;
  DateTime? ngayBatDau;
  DateTime? ngayHoanThanh;
  String trangThai;
  String? ghiChu;
       double? evaluationScore;

  PhanCong({
    required this.id,
    required this.phanCongId,
    required this.congViecId,
    required this.tenCongViecPhanCong,
    required this.nguoiDuocPhanCongId,
    required this.nguoiPhanCongId,
    this.ngayBatDau,
    this.ngayHoanThanh,
    required this.trangThai,
    this.ghiChu,
    this.evaluationScore,
  });

  factory PhanCong.fromJson(Map<String, dynamic> json) {
    return PhanCong(
      id: json['id'] ?? 0,
      phanCongId: json['phanCongId'],
      congViecId: json['congViecId'],
      tenCongViecPhanCong: json['tenCongViecPhanCong'],
      nguoiDuocPhanCongId: json['nguoiDuocPhanCongId'],
      nguoiPhanCongId: json['nguoiPhanCongId'],
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayHoanThanh: DateTime.parse(json['ngayHoanThanh']),
      trangThai: json['trangThai'],
      ghiChu: json['ghiChu'],
       evaluationScore: json['evaluationScore']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phanCongId': phanCongId,
      'congViecId': congViecId,
      'tenCongViecPhanCong': tenCongViecPhanCong,
      'nguoiDuocPhanCongId': nguoiDuocPhanCongId,
      'nguoiPhanCongId': nguoiPhanCongId,
      'ngayBatDau': ngayBatDau?.toIso8601String(),
      'ngayHoanThanh': ngayHoanThanh?.toIso8601String(),
      'trangThai': trangThai,
      'ghiChu': ghiChu ?? '',
      'evaluationScore': evaluationScore,
    };
  }
}
