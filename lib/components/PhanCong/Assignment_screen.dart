import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CongViec/Task.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:flutter_application_1/models/phancong_model.dart';
import 'package:flutter_application_1/service/chucvu_service.dart';
import 'package:flutter_application_1/models/chucvu_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    };
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

  static Future<List<CongViec>> fetchCongViec() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/CongViecs'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => CongViec.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ChucVu');
    }
  }
}

class ApiService {
  final String baseUrl = 'http://192.168.239.219:5000/api/PhanCongs';

  // Lấy danh sách PhanCong
  Future<List<PhanCong>> getPhanCongs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PhanCong.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load PhanCongs');
    }
  }

  // Lấy một PhanCong theo ID
  Future<PhanCong> getPhanCong(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return PhanCong.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load PhanCong');
    }
  }

  // Thêm mới một PhanCong
  Future<void> createPhanCong(PhanCong phanCong) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(phanCong.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create PhanCong');
    }
  }

  Future<void> updatePhanCong(int id, PhanCong phanCong) async {
    final url = Uri.parse('$baseUrl/${phanCong.id}');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'id': id,
      'phanCongId': phanCong.phanCongId,
      'congViecId': phanCong.congViecId,
      'tenCongViecPhanCong': phanCong.tenCongViecPhanCong,
      'nguoiDuocPhanCongId': phanCong.nguoiDuocPhanCongId,
      'nguoiPhanCongId': phanCong.nguoiPhanCongId,
      'ngayBatDau': phanCong.ngayBatDau?.toIso8601String(),
      'ngayHoanThanh': phanCong.ngayHoanThanh?.toIso8601String(),
      'trangThai': phanCong.trangThai,
      'ghiChu': phanCong.ghiChu ?? '',
    });
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update');
    }
  }

  Future<void> deletePhanCong(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );
      if (response.statusCode != 20) {
        throw Exception('Failed to delete PhanCong');
      }
    } on Exception catch (e) {
      print('Error deleting PhanCong: $e');
      // Handle the exception here, for example, show an error message to the user
    }
  }


}

class AddEditPhanCongDialog extends StatefulWidget {
  final PhanCong? phanCong;
  final Function(PhanCong) onSave;

  AddEditPhanCongDialog({this.phanCong, required this.onSave});

  @override
  _AddEditPhanCongDialogState createState() => _AddEditPhanCongDialogState();
}

class _AddEditPhanCongDialogState extends State<AddEditPhanCongDialog> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  int? phanCongId;
  int? congViecId;
  String? tenCongViecPhanCong;
  int? nguoiDuocPhanCongId;
  int? nguoiPhanCongId;
  DateTime? ngayBatDau;
  DateTime? ngayHoanThanh;
  String? trangThai;
  String? ghiChu;

  List<CongViec> congViecs = [];
  List<NhanVien> nhanViens = [];

      late Future<List<NhanVien>> _attendanceList;
  int? loggedInNhanVienID;
  @override
  void initState() {
    super.initState();

    if (widget.phanCong != null) {
      final phanCong = widget.phanCong!;
      phanCongId = phanCong.phanCongId;
      congViecId = phanCong.congViecId;
      tenCongViecPhanCong = phanCong.tenCongViecPhanCong;
      nguoiDuocPhanCongId = phanCong.nguoiDuocPhanCongId;
      nguoiPhanCongId = phanCong.nguoiPhanCongId;
      ngayBatDau = phanCong.ngayBatDau;
      ngayHoanThanh = phanCong.ngayHoanThanh;
      trangThai = phanCong.trangThai;
      ghiChu = phanCong.ghiChu;
    }
    _fetchDropdownData();
             _getLoggedInNhanVienID();
  }

  // void _fetchDropdownData() async {
  //   try {
  //     congViecs = await DropdownService.fetchCongViec();
  //     nhanViens = await DropdownService.fetchNhanVien();
  //     setState(() {});
  //   } catch (e) {
  //     print('Error fetching dropdown data: $e');
  //   }
  // }
void _fetchDropdownData() async {
  try {
    congViecs = await DropdownService.fetchCongViec();
    nhanViens = await DropdownService.fetchNhanVien();

    // Lọc danh sách nhân viên
    nhanViens = nhanViens.where((nv) {
      // Giữ lại nhân viên hiện đang đăng nhập hoặc nhân viên không phải Admin/Giám đốc
      return nv.id == loggedInNhanVienID || 
             (nv.chucVuId != 1 && nv.chucVuId != 2);
    }).toList();

    setState(() {});
  } catch (e) {
    print('Error fetching dropdown data: $e');
  }
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
          widget.phanCong == null ? 'Thêm phân công mới' : 'Sửa phân công'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: phanCongId?.toString(),
                decoration: InputDecoration(labelText: 'Phân Công ID'),
                keyboardType: TextInputType.number,
                onSaved: (value) => phanCongId = int.tryParse(value!),
              ),
              TextFormField(
                initialValue: tenCongViecPhanCong,
                decoration:
                    InputDecoration(labelText: 'Tên việc được phân công'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công việc.';
                  }
                  return null;
                },
                onSaved: (value) => tenCongViecPhanCong = value,
              ),
             DropdownButtonFormField<int>(
  value: congViecId,
  items: congViecs
      .map((cv) => DropdownMenuItem(
            value: cv.id,
            child: Text(
              cv.tenCongViec,
              softWrap: true, 
              maxLines: 2, // Cho phép xuống dòng
            ),
          ))
      .toList(),
  onChanged: (value) => congViecId = value,
  decoration: InputDecoration(labelText: 'Công việc'),
),

              DropdownButtonFormField<int>(
                value: nguoiDuocPhanCongId,
                items: nhanViens
                    .map((nv) => DropdownMenuItem(
                          value: nv.id,
                          child: Text(nv.hoTen),
                        ))
                    .toList(),
                onChanged: (value) => nguoiDuocPhanCongId = value,
                decoration: InputDecoration(labelText: 'Người được phân công'),
              ),
              DropdownButtonFormField<int>(
  value: nguoiPhanCongId,
  items: nhanViens
      .where((nv) => nv.id == loggedInNhanVienID) // Filter to show only the logged-in employee
      .map((nv) => DropdownMenuItem(
            value: nv.id,
            child: Text(nv.hoTen),
          ))
      .toList(),
  onChanged: (value) {
    setState(() {
      nguoiPhanCongId = value ?? nguoiPhanCongId; // Keep the old value if null
    });
  },
  decoration: InputDecoration(labelText: 'Người phân công'),
),

              ListTile(
                title: Text(
                    'Ngày bắt đầu: ${ngayBatDau != null ? ngayBatDau!.toLocal().toString().split(' ')[0] : 'Chọn ngày'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      ngayBatDau = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                    'Ngày hoàn thành: ${ngayHoanThanh != null ? ngayHoanThanh!.toLocal().toString().split(' ')[0] : 'Chọn ngày'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      ngayHoanThanh = pickedDate;
                    });
                  }
                },
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: trangThai,
                hint: Text('Chọn trạng thái'),
                items: ['Chưa bắt đầu', 'Đang thực hiện', 'Hoàn thành']
                    .map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    trangThai = value;
                  });
                },
              ),
              TextFormField(
                initialValue: ghiChu,
                decoration: InputDecoration(labelText: 'Ghi chú'),
                onSaved: (value) => ghiChu = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newPhanCong = PhanCong(
                id: widget.phanCong?.id ?? 0,
                phanCongId: phanCongId ?? 0,
                congViecId: congViecId!,
                tenCongViecPhanCong: tenCongViecPhanCong!,
                nguoiDuocPhanCongId: nguoiDuocPhanCongId!,
                nguoiPhanCongId: nguoiPhanCongId!,
                ngayBatDau: ngayBatDau,
                ngayHoanThanh: ngayHoanThanh,
                trangThai: trangThai!,
                ghiChu: ghiChu,
              );
              widget.onSave(newPhanCong);
              Navigator.of(context).pop();
            }
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }
}
