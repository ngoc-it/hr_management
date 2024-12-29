import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CongViec/Task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:flutter_application_1/components/PhanCong/Assignment_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

// Model PhanCong
class PhanCong {
  final int id;
  final int phanCongId;
  final int congViecId;
  final int nguoiDuocPhanCongId;
  final int nguoiPhanCongId;
  final String trangThai;
  final String tenCongViecPhanCong;

  PhanCong({
    required this.id,
    required this.phanCongId,
    required this.congViecId,
    required this.nguoiDuocPhanCongId,
    required this.nguoiPhanCongId,
    required this.trangThai,
    required this.tenCongViecPhanCong,
  });

  factory PhanCong.fromJson(Map<String, dynamic> json) {
    return PhanCong(
      id: json['id'] as int,
      phanCongId: json['phanCongId'] as int,
      congViecId: json['congViecId'] as int,
      nguoiDuocPhanCongId: json['nguoiDuocPhanCongId'] as int,
      nguoiPhanCongId: json['nguoiPhanCongId'] as int,
      trangThai: json['trangThai'] as String,
      tenCongViecPhanCong: json['tenCongViecPhanCong'] as String,
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

  static Future<List<PhanCong>> fetchPhanCong() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/PhanCongs'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => PhanCong.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load PhanCong');
    }
  }
}

class DanhGiaService {
  final String baseUrl = 'http://192.168.239.219:5000/api/DanhGias';

  Future<List<DanhGia>> getDanhGias() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DanhGia.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load DanhGias');
    }
  }

Future<List<DanhGia>> getDanhGiasWithNames(
      List<PhanCong> phanCongs, List<NhanVien> nhanViens) async {
    final danhGias = await getDanhGias();

    for (var danhGia in danhGias) {
      final phanCong = phanCongs.firstWhere(
        (p) => p.id == danhGia.phanCongId,
        orElse: () => PhanCong(
          id: 0,
          phanCongId: 0,
          congViecId: 0,
          nguoiDuocPhanCongId: 0,
          nguoiPhanCongId: 0,
          trangThai: 'Không rõ',
          tenCongViecPhanCong: 'Không rõ',
        ),
      );

      final nhanVien = nhanViens.firstWhere(
        (n) => n.id == danhGia.nguoiDanhGiaId,
        orElse: () => NhanVien(
          id: 0,
          nhanVienID: '',
          hoTen: 'Không rõ',
          ngaySinh: DateTime(1900, 1, 1),
          diaChi: '',
          sdt: '',
          email: '',
          phongBanId: 0,
          chucVuId: 0,
          ngayVaoLam: DateTime(1900, 1, 1),
          trangThaiID: 0,
        ),
      );

      danhGia.tenCongViecPhanCong = phanCong.tenCongViecPhanCong;
      danhGia.hoTen = nhanVien.hoTen;
    }
    return danhGias;
  }

  // Lấy một DanhGia theo ID
  Future<DanhGia> getDanhGia(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return DanhGia.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load DanhGia');
    }
  }

  Future<void> createDanhGia(DanhGia danhGia) async {
  // Lấy danh sách các đánh giá hiện tại
  final danhGias = await getDanhGias();

  // Kiểm tra phân công đã được đánh giá chưa
  final exists = danhGias.any((dg) => dg.phanCongId == danhGia.phanCongId);

  if (exists) {
    throw Exception('Phân công này đã được đánh giá. Không thể thêm đánh giá mới.');
  }

  // Nếu chưa được đánh giá, thực hiện thêm mới
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(danhGia.toJson()),
  );

  if (response.statusCode != 201) {
    throw Exception('Thêm mới đánh giá thất bại.');
  }
}


  Future<void> updateDanhGia(int id, DanhGia danhGia) async {
    final url = Uri.parse('$baseUrl/${danhGia.id}');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'id': id,
      'danhGiaId': danhGia.danhGiaId,
      'phanCongId': danhGia.phanCongId,
      'diemDanhGia': danhGia.dienDanhGia,
      'nguoiDanhGiaId': danhGia.nguoiDanhGiaId,
      'ghiChu': danhGia.ghiChu ?? '',
      'ngayDanhGiaId': danhGia.ngayDanhGia.toIso8601String()
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

  Future<void> deleteDanhGia(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );
      if (response.statusCode != 20) {
        throw Exception('Failed to delete PhanCong');
      }
    } on Exception catch (e) {
      print('Error deleting DanhGia: $e');
      // Handle the exception here, for example, show an error message to the user
    }
  }
}

class AddEditDanhGiaPage extends StatefulWidget {
  final DanhGia? danhGia;

  AddEditDanhGiaPage({this.danhGia});
  

  @override
  _AddEditDanhGiaPageState createState() => _AddEditDanhGiaPageState();
}

class _AddEditDanhGiaPageState extends State<AddEditDanhGiaPage> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  int? _danhGiaId;
  List<NhanVien> _nhanViens = [];
  List<PhanCong> _phanCongs = [];
  int? _selectedNhanVienId;
  int? _selectedPhanCongId;
  double _diemDanhGia = 0;
  String _ghiChu = '';
  DateTime _ngayDanhGia = DateTime.now();
    late Future<List<NhanVien>> _attendanceList;
  int? loggedInNhanVienID;

  @override
  void initState() {
    super.initState();
         _getLoggedInNhanVienID();
    fetchDropdownData();
    if (widget.danhGia != null) {
      // Pre-fill data for editing
      id = widget.danhGia!.id;
      _danhGiaId = widget.danhGia!.danhGiaId;
      _selectedNhanVienId = widget.danhGia!.nguoiDanhGiaId;
      _selectedPhanCongId = widget.danhGia!.phanCongId;
      _diemDanhGia = widget.danhGia!.dienDanhGia;
      _ghiChu = widget.danhGia!.ghiChu ?? '';
      _ngayDanhGia = DateTime.now();
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
  Future<void> fetchDropdownData() async {
    _nhanViens = await DropdownService.fetchNhanVien();
    _phanCongs = await DropdownService.fetchPhanCong();
    setState(() {});
  }


  Future<void> submitDanhGia() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final Map<String, dynamic> requestData = {
      'id': id,
      'danhGiaId': _danhGiaId,
      'phanCongId': _selectedPhanCongId,
      'diemDanhGia': _diemDanhGia,
      'nguoiDanhGiaId': _selectedNhanVienId,
      'ghiChu': _ghiChu,
      'ngayDanhGiaId': _ngayDanhGia.toIso8601String(),
    };

    final danhGias = await DanhGiaService().getDanhGias();

    // Kiểm tra nếu phân công đã được đánh giá
    final isAlreadyEvaluated = danhGias.any(
      (dg) => dg.phanCongId == _selectedPhanCongId && dg.id != id,
    );

    if (isAlreadyEvaluated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phân công này đã được đánh giá.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.danhGia == null) {
      // Thêm mới
      final response = await http.post(
        Uri.parse('http://192.168.239.219:5000/api/DanhGias'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to add DanhGia');
      }
    } else {
      // Chỉnh sửa
      final response = await http.put(
        Uri.parse('http://192.168.239.219:5000/api/DanhGias/${widget.danhGia!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 204) {
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to update DanhGia');
      }
    }
  }
}





 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.danhGia == null ? 'Thêm Đánh Giá' : 'Sửa Đánh Giá'),
      backgroundColor: const Color(0xFF0277BD),
      centerTitle: true,
      elevation: 4,
    ),
    body: _nhanViens.isEmpty || _phanCongs.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông Tin Đánh Giá',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF01579B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: _danhGiaId != null ? _danhGiaId.toString() : '',
                    decoration: InputDecoration(
                      labelText: 'Đánh Giá ID',
                      hintText: 'Nhập ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.assignment, color: const Color(0xFF0288D1)),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _danhGiaId = int.tryParse(value!),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Vui lòng nhập ID' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: _selectedPhanCongId,
                    decoration: InputDecoration(
                      labelText: 'Chọn Phân Công',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _phanCongs.map((phanCong) {
                      return DropdownMenuItem<int>(
                        value: phanCong.id,
                        child: Text(phanCong.tenCongViecPhanCong),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPhanCongId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Vui lòng chọn phân công' : null,
                  ),
                  const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                value: loggedInNhanVienID,
                decoration: InputDecoration(labelText: 'Người đánh giá'),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedNhanVienId = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: loggedInNhanVienID,
                    child: Text(_nhanViens
                        .firstWhere((nv) => nv.id == loggedInNhanVienID)
                        .hoTen),
                  ),
                ],
                disabledHint: Text(
                  _nhanViens
                      .firstWhere((nv) => nv.id == loggedInNhanVienID)
                      .hoTen,
                ),
                onSaved: (value) {
                  _selectedNhanVienId = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn người đánh giá';
                  }
                  return null;
                },
              ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _diemDanhGia != 0 ? _diemDanhGia.toString() : '',
                    decoration: InputDecoration(
                      labelText: 'Điểm Đánh Giá',
                      hintText: 'Nhập điểm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.score, color: const Color(0xFF0288D1)),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _diemDanhGia = double.tryParse(value!) ?? 0,
                    validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Vui lòng nhập điểm'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _ghiChu,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Ghi Chú',
                      hintText: 'Nhập ghi chú (nếu có)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.note, color: const Color(0xFF0288D1)),
                    ),
                    onSaved: (value) => _ghiChu = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: submitDanhGia,
                    icon: Icon(Icons.save),
                    label: Text('Lưu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 237, 246, 252),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}
}