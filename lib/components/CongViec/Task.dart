import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';




// Mô hình dữ liệu Công Việc
class CongViec {
  int id;
  int congViecId;
  String tenCongViec;
  int nguoiTaoId;
  String? moTa;
  String trangThai;
  DateTime ngayTao;
  DateTime? ngayHoanThanhDuKien;
  DateTime ngayHoanThanh;

  CongViec({
    required this.id,
    required this.congViecId,
    required this.tenCongViec,
    required this.nguoiTaoId,
    this.moTa,
    required this.trangThai,
    required this.ngayTao,
    required this.ngayHoanThanhDuKien,
    required this.ngayHoanThanh,
  });

  factory CongViec.fromJson(Map<String, dynamic> json) {
    return CongViec(
      id: json['id'] ?? 0,
      congViecId: json['congViecId'],
      tenCongViec: json['tenCongViec'],
      nguoiTaoId: json['nguoiTaoId'],
      moTa: json['moTa'],
      trangThai: json['trangThai'],
      ngayTao: DateTime.parse(json['ngayTao']),
      ngayHoanThanhDuKien: DateTime.parse(json['ngayHoanThanhDuKien']),
      ngayHoanThanh: DateTime.parse(json['ngayHoanThanh']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'congViecId': congViecId,
      'tenCongViec': tenCongViec,
      'nguoiTaoId': nguoiTaoId,
      'moTa': moTa,
      'trangThai': trangThai,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayHoanThanhDuKien': ngayHoanThanhDuKien?.toIso8601String(),
      'ngayHoanThanh': ngayHoanThanh.toIso8601String(),
      'nhanVien': {
        'id': nguoiTaoId,
        'hoTen': '',
      }
    };
  }
}

// Dịch vụ Công Việc để xử lý các yêu cầu API
class CongViecService {
  final String apiUrl =
      'http://192.168.239.219:5000/api/CongViecs'; // Thay URL của bạn

  Future<List<CongViec>> fetchCongViecs() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => CongViec.fromJson(job)).toList();
    } else {
      throw Exception('Không thể tải danh sách công việc');
    }
  }

  Future<CongViec> createCongViec(CongViec congViec) async {
    congViec.ngayTao = DateTime.now(); // Cập nhật ngày tạo tự động
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(congViec.toJson()),
    );
    if (response.statusCode == 201) {
      return CongViec.fromJson(json.decode(response.body));
    } else {
      print('Error response body: ${response.body}');
      throw Exception('Không thể thêm công việc');
    }
  }

  Future<void> updateCongViec(int id, CongViec congViec) async {
    final url = Uri.parse('$apiUrl/${congViec.id}');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'id': congViec.id,
      'congViecId': congViec.congViecId,
      'tenCongViec': congViec.tenCongViec,
      'nguoiTaoId': congViec.nguoiTaoId,
      'moTa': congViec.moTa,
      'trangThai': congViec.trangThai,
      'ngayTao': congViec.ngayTao.toIso8601String(),
      'ngayHoanThanhDuKien': congViec.ngayHoanThanhDuKien?.toIso8601String(),
      'ngayHoanThanh': congViec.ngayHoanThanh.toIso8601String(),
    });
    if (congViec.trangThai == 'Đã hoàn thành') {
      congViec.ngayHoanThanh =
          DateTime.now(); // Cập nhật ngày hoàn thành tự động
    }
    print('URL: $url'); // In URL để kiểm tra xem id có đúng không
    print('Body: $body'); // In ra dữ liệu JSON gửi lên để kiểm tra

    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update');
    }
  }

  Future<void> deleteCongViec(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Không thể xóa công việc');
    }
  }
}

// Màn hình hiển thị danh sách công việc


// Form dialog để thêm/chỉnh sửa công việc
class CongViecFormDialog extends StatefulWidget {
  final CongViec? congViec;

  CongViecFormDialog({this.congViec});

  @override
  _CongViecFormDialogState createState() => _CongViecFormDialogState();
}

class _CongViecFormDialogState extends State<CongViecFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tenCongViecController;
  int? selectedNguoiTaoId; // Thêm biến để lưu id người tạo
  late Future<List<NhanVien>> futureNhanViens; // Biến chứa dữ liệu nhân viênv
  late TextEditingController moTaController;
  late TextEditingController
      congViecIdController; // Thêm controller cho congViecId
  String trangThai = 'Chưa hoàn thành';
  DateTime ngayTao = DateTime.now();
  DateTime? ngayHoanThanhDuKien;
  DateTime ngayHoanThanh = DateTime.now().add(Duration(days: 7));
    late Future<List<NhanVien>> _attendanceList;
  int? loggedInNhanVienID;

  @override
  void initState() {
    super.initState();
     _getLoggedInNhanVienID();
    tenCongViecController =
        TextEditingController(text: widget.congViec?.tenCongViec ?? '');
    // nguoiTaoController =
    //     TextEditingController(text: widget.congViec?.nguoiTaoId ?? '');
    selectedNguoiTaoId = widget.congViec?.nguoiTaoId;
    futureNhanViens =
        NhanVienController().fetchNhanViens(); // Lấy danh sách nhân viên
    moTaController = TextEditingController(text: widget.congViec?.moTa ?? '');
    congViecIdController = TextEditingController(
        text: widget.congViec?.congViecId.toString() ??
            ''); // Cập nhật giá trị congViecId
    trangThai = widget.congViec?.trangThai ?? 'Chưa hoàn thành';
    ngayTao = DateTime.now(); // Cập nhật ngày tạo tự động
    ngayHoanThanhDuKien =
        widget.congViec?.ngayHoanThanhDuKien ?? DateTime.now();
    ngayHoanThanh = ngayHoanThanh = DateTime.now().add(Duration(days: 7));
  }
// Lấy NhanVienID từ SharedPreferences
  Future<void> _getLoggedInNhanVienID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInNhanVienID = prefs.getInt('NhanVienID');
    });

    // Khi đã lấy được NhanVienID, thực hiện tải dữ liệu 
    if (loggedInNhanVienID != null) {
      _attendanceList = _fetchAttendanceByNhanVien(loggedInNhanVienID!);
    }
  }
  Future<List<NhanVien>> _fetchAttendanceByNhanVien(int nhanVienId) async {
  final url = Uri.parse('http://192.168.239.219:5000/api/NhanViens/NhanVien/$nhanVienId');
  final response = await http.get(url);

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => NhanVien.fromJson(item)).toList();
  } else {
    throw Exception('Không thể lấy dữ liệu nhân viên');
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.congViec == null ? 'Thêm Công Việc' : 'Chỉnh Sửa Công Việc'),
      content: SingleChildScrollView(  // Bọc Form trong SingleChildScrollView
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: congViecIdController,
              decoration: InputDecoration(labelText: 'Mã công việc'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Vui lòng nhập mã công việc'
                  : null,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: tenCongViecController,
              decoration: InputDecoration(labelText: 'Tên công việc'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Vui lòng nhập tên công việc'
                  : null,
            ),
            // TextFormField(
            //   controller: nguoiTaoController,
            //   decoration: InputDecoration(labelText: 'Người tạo'),
            //   validator: (value) => value == null || value.isEmpty
            //       ? 'Vui lòng nhập người tạo'
            //       : null,
            // ),
            FutureBuilder<List<NhanVien>>(
  future: futureNhanViens,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Lỗi tải dữ liệu');
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Text('Không có nhân viên');
    } else {
      // Lọc danh sách nhân viên để chỉ hiển thị nhân viên hiện tại
      List<NhanVien> nhanViens = snapshot.data!;
      List<NhanVien> filteredNhanViens = nhanViens
          .where((nhanVien) => nhanVien.id == loggedInNhanVienID)
          .toList();

      return DropdownButtonFormField<int>(
        value: selectedNguoiTaoId,
        onChanged: (value) {
          setState(() {
            selectedNguoiTaoId = value;
          });
        },
        decoration: InputDecoration(labelText: 'Người tạo'),
        items: filteredNhanViens.map((NhanVien nhanVien) {
          return DropdownMenuItem<int>(
            value: nhanVien.id,
            child: Text(nhanVien.hoTen),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Vui lòng chọn người tạo';
          }
          return null;
        },
      );
    }
  },
),

            TextFormField(
              controller: moTaController,
              decoration: InputDecoration(labelText: 'Mô tả'),
              maxLines: 3,
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày Dự Kiến Hoàn Thành',
              ),
              controller: TextEditingController(
                text: ngayHoanThanhDuKien != null
                    ? DateFormat('yyyy-MM-dd').format(ngayHoanThanhDuKien!)
                    : DateFormat('yyyy-MM-dd').format(
                        DateTime.now()), // Sử dụng ngày hiện tại khi null
              ),
              onTap: () async {
                DateTime initialDate = ngayHoanThanhDuKien ?? DateTime.now();
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    ngayHoanThanhDuKien = picked;
                  });
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: trangThai,
              decoration: InputDecoration(labelText: 'Trạng thái'),
              items: ['Chưa hoàn thành', 'Đã hoàn thành'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    trangThai = value;
                    if (trangThai == 'Đã hoàn thành') {
                      ngayHoanThanh = DateTime.now();
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final congViec = CongViec(
                id: widget.congViec?.id ??
                    0, // Nếu là chỉnh sửa, sử dụng ID cũ, nếu là thêm thì ID = 0
                congViecId: int.parse(congViecIdController
                    .text), // Lấy mã công việc từ trường nhập
                tenCongViec:
                    tenCongViecController.text, // Tên công việc từ trường nhập
                // nguoiTao: nguoiTaoController.text, // Người tạo từ trường nhập
                //  nguoiTaoId: selectedNguoiTaoId!,
                nguoiTaoId: selectedNguoiTaoId != null
                    ? int.parse(selectedNguoiTaoId.toString())
                    : 0,
                moTa: moTaController.text.isEmpty
                    ? null
                    : moTaController.text, // Mô tả, nếu không có thì để null
                trangThai: trangThai, // Trạng thái đã chọn
                ngayTao: ngayTao,
                ngayHoanThanhDuKien: ngayHoanThanhDuKien ?? DateTime.now(),
                ngayHoanThanh: ngayHoanThanh, // Ngày hoàn thành
              );

              // Nếu là thêm công việc mới
              if (widget.congViec == null) {
                Navigator.pop(context, congViec);
              } else {
                // Nếu là chỉnh sửa công việc đã có
                Navigator.pop(context, congViec);
              }
            }
          },
          child: Text('Lưu'),
        )
      ],
    );
  }
}
