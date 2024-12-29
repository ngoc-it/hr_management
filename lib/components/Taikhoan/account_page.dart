import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/models/chucvu_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/service/chucvu_service.dart';

class TaiKhoan {
  int id;
  String tenDangNhap;
  String matKhau;
  int nhanVienId;
  int chucVuId;
  String? trangThai;
  TaiKhoan({
    required this.id,
    required this.tenDangNhap,
    required this.matKhau,
    required this.nhanVienId,
    required this.chucVuId,
    this.trangThai,
  });
  factory TaiKhoan.fromJson(Map<String, dynamic> json) {
    return TaiKhoan(
      id: json['id'] as int,
      tenDangNhap: json['tenDangNhap'] as String,
      matKhau: json['matKhau'] as String,
      nhanVienId: json['nhanVienId'] as int,
      chucVuId: json['chucVuId'] as int,
      trangThai: json['trangThai'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
      'nhanVienId': nhanVienId,
      'chucVuId': chucVuId,
      'trangThai': trangThai,
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

  static Future<List<ChucVu>> fetchChucVu() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/ChucVus'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => ChucVu.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ChucVu');
    }
  }
}

class TaiKhoanService {
  final String baseUrl = 'http://192.168.239.219:5000/api/TaiKhoans';
  Future<List<TaiKhoan>> getTaiKhoans() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TaiKhoan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load TaiKhoan');
    }
  }

  // Lấy một TaiKhoan theo ID
  Future<TaiKhoan> getTaiKhoan(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TaiKhoan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load TaiKhoan');
    }
  }

  Future<void> createTaiKhoan(TaiKhoan taiKhoan) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(taiKhoan.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create TaiKhoan');
    }
  }

  Future<void> updateTaiKhoan(int id, TaiKhoan taiKhoan) async {
    final url = Uri.parse('$baseUrl/${taiKhoan.id}');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'id': id,
      'tenDangNhap': taiKhoan.tenDangNhap,
      'matKhau': taiKhoan.matKhau,
      'nhanVienId': taiKhoan.nhanVienId,
      'chucVuId': taiKhoan.chucVuId,
      'trangThai': taiKhoan.trangThai ?? '',
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

  Future<void> deleteTaiKhoan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );
      if (response.statusCode != 20) {
        throw Exception('Failed to delete TaiKhoan');
      }
    } on Exception catch (e) {
      print('Error deleting TaiKhoan: $e');
      // Handle the exception here, for example, show an error message to the user
    }
  }
  Future<bool> isNhanVienHasTaiKhoan(int nhanVienId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/check-nhanvien/$nhanVienId'),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    // Giả sử API trả về object với key "hasAccount"
    if (responseBody is Map<String, dynamic> && responseBody.containsKey('hasTaiKhoan')) {
      return responseBody['hasTaiKhoan'] == true; // Trả về true hoặc false
    }

    throw Exception('Invalid response structure for TaiKhoan check');
  } else {
    throw Exception('Failed to check TaiKhoan for NhanVien');
  }
}



}

class AddEditTaiKhoanPage extends StatefulWidget {
  final TaiKhoan? taiKhoan;
  AddEditTaiKhoanPage({this.taiKhoan});
  @override
  _AddEditTaiKhoanPageState createState() => _AddEditTaiKhoanPageState();
}

class _AddEditTaiKhoanPageState extends State<AddEditTaiKhoanPage> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String? _tenDangNhap;
  String? _matKhau;
  List<NhanVien> _nhanViens = [];
  List<ChucVu> _chucVus = [];
  int? _selectedNhanVienId;
  int? _selectedChucVuId;
  String _trangThai = '';
  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    if (widget.taiKhoan != null) {
      id = widget.taiKhoan!.id;
      _tenDangNhap = widget.taiKhoan!.tenDangNhap;
      _matKhau = widget.taiKhoan!.matKhau;
      _selectedNhanVienId = widget.taiKhoan!.nhanVienId;
      _selectedChucVuId = widget.taiKhoan!.chucVuId;
      _trangThai = widget.taiKhoan?.trangThai ?? '';
    }
  }

  Future<void> fetchDropdownData() async {
    _nhanViens = await DropdownService.fetchNhanVien();
    _chucVus = await DropdownService.fetchChucVu();
    setState(() {});
  }

  // Future<void> submitTaiKhoan() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     // Kiểm tra nhân viên đã có tài khoản chưa
  //   if (widget.taiKhoan == null) { // Chỉ kiểm tra khi thêm mới
  //     final taiKhoanService = TaiKhoanService();
  //     final hasTaiKhoan = await taiKhoanService.isNhanVienHasTaiKhoan(_selectedNhanVienId!);

  //     if (hasTaiKhoan) {
  //       // Hiển thị thông báo nếu nhân viên đã có tài khoản
  //       showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: Text('Lỗi'),
  //           content: Text('Nhân viên này đã có tài khoản.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(ctx),
  //               child: Text('Đóng'),
  //             ),
  //           ],
  //         ),
  //       );
  //       return;
  //     }
  //   }
  //     final Map<String, dynamic> requestData = {
  //       'id': id,
  //       'tenDangNhap': _tenDangNhap,
  //       'matKhau': _matKhau,
  //       'nhanVienId': _selectedNhanVienId,
  //       'chucVuId': _selectedChucVuId,
  //       'trangThai': _trangThai,
  //     };
  //     if (widget.taiKhoan == null) {
  //       final response = await http.post(
  //         Uri.parse('http://192.168.239.219:5000/api/TaiKhoans'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(requestData),
  //       );
  //       if (response.statusCode == 201) {
  //         Navigator.pop(context, true);
  //       } else {
  //         throw Exception('Failed to add TaiKhoan');
  //       }
  //     } else {
  //       // Edit existing DanhGia
  //       final response = await http.put(
  //         Uri.parse(
  //             'http://192.168.239.219:5000/api/TaiKhoans/${widget.taiKhoan!.id}'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(requestData),
  //       );

  //       if (response.statusCode == 204) {
  //         Navigator.pop(context, true);
  //       } else {
  //         throw Exception('Failed to update TaiKhoan');
  //       }
  //     }
  //   }
  // }
  Future<void> submitTaiKhoan() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    // Kiểm tra nhân viên đã có tài khoản chưa
    if (widget.taiKhoan == null) { // Chỉ kiểm tra khi thêm mới
      final taiKhoanService = TaiKhoanService();
      final hasTaiKhoan = await taiKhoanService.isNhanVienHasTaiKhoan(_selectedNhanVienId!);

      if (hasTaiKhoan) {
        // Hiển thị thông báo nếu nhân viên đã có tài khoản
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Lỗi'),
            content: Text('Nhân viên này đã có tài khoản.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Đóng'),
              ),
            ],
          ),
        );
        return;
      }
    }

    // Xử lý thêm mới hoặc chỉnh sửa
    final Map<String, dynamic> requestData = {
      'id': id,
      'tenDangNhap': _tenDangNhap,
      'matKhau': _matKhau,
      'nhanVienId': _selectedNhanVienId,
      'chucVuId': _selectedChucVuId,
      'trangThai': _trangThai,
    };

    try {
      if (widget.taiKhoan == null) {
        await http.post(
          Uri.parse('http://192.168.239.219:5000/api/TaiKhoans'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestData),
        );
      } else {
        await http.put(
          Uri.parse('http://192.168.239.219:5000/api/TaiKhoans/${widget.taiKhoan!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestData),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      // Hiển thị lỗi nếu không thành công
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Đã xảy ra lỗi khi lưu tài khoản.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.taiKhoan == null ? 'Thêm Tài Khoản' : 'Sửa Tài Khoản'),
            backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[100],
      body: _nhanViens.isEmpty || _chucVus.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
//                  TextFormField(
//                       initialValue: _tenDangNhap,
//                       decoration: InputDecoration(labelText: 'Tên đăng nhập'),
//                       onSaved: (value) => _tenDangNhap = value,
//                       validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
//                     ),
//                     TextFormField(
//                       initialValue: _matKhau,
//                       decoration: InputDecoration(labelText: 'Mật khẩu'),
//                       onSaved: (value) => _matKhau = value,
//                       validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
//                     ),

//                    DropdownButtonFormField<int>(
//   value: _selectedNhanVienId,
//   items: _nhanViens
//       .map((nhanVien) => DropdownMenuItem<int>(
//             value: nhanVien.id,
//             child: Text(nhanVien.hoTen),
//           ))
//       .toList(),
//   onChanged: (value) {
//     setState(() {
//       _selectedNhanVienId = value;
//       // Lấy chức vụ từ nhân viên đã chọn
//       var nhanVien = _nhanViens.firstWhere((nv) => nv.id == value);
//       _selectedChucVuId = nhanVien.chucVuId;
//     });
//   },
//   decoration: InputDecoration(labelText: 'Nhân viên'),
// ),

// // Hiển thị chức vụ (Read-only)
// TextFormField(
//   initialValue: _selectedChucVuId != null
//       ? _chucVus.firstWhere((cv) => cv.id == _selectedChucVuId).tenChucVu
//       : '',
//   decoration: InputDecoration(
//     labelText: 'Chức vụ',
//     hintText: 'Chức vụ của nhân viên',
//   ),
//   enabled: false,  // Không cho phép thay đổi
// ),
                    // Tên đăng nhập: không cho sửa khi chỉnh sửa tài khoản
                    TextFormField(
                      initialValue: _tenDangNhap,
                      decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                      enabled:
                          widget.taiKhoan == null, // chỉ cho sửa khi tạo mới
                      onSaved: (value) => _tenDangNhap = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
                    ),
                    // Mật khẩu: không cho sửa khi chỉnh sửa tài khoản
                    TextFormField(
                      initialValue: _matKhau,
                      decoration: InputDecoration(labelText: 'Mật khẩu'),
                      enabled:
                          widget.taiKhoan == null, // chỉ cho sửa khi tạo mới
                      onSaved: (value) => _matKhau = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                      obscureText: true,
                    ),
                    // Không cho phép thay đổi nhân viên khi sửa tài khoản
                    DropdownButtonFormField<int>(
                      value: _selectedNhanVienId,
                      items: _nhanViens
                          .map((nhanVien) => DropdownMenuItem<int>(
                                value: nhanVien.id,
                                child: Text(nhanVien.hoTen),
                              ))
                          .toList(),
                      onChanged: widget.taiKhoan ==
                              null // chỉ cho phép chọn khi thêm mới
                          ? (value) {
                              setState(() {
                                _selectedNhanVienId = value;
                                // Lấy chức vụ từ nhân viên đã chọn
                                var nhanVien = _nhanViens
                                    .firstWhere((nv) => nv.id == value);
                                _selectedChucVuId = nhanVien.chucVuId;
                              });
                            }
                          : null, // Khi sửa, không cho thay đổi
                      decoration: InputDecoration(labelText: 'Nhân viên'),
                    ),

                    // Chức vụ: read-only
                    TextFormField(
                      initialValue: _selectedChucVuId != null
                          ? _chucVus
                              .firstWhere((cv) => cv.id == _selectedChucVuId)
                              .tenChucVu
                          : '',
                      decoration: InputDecoration(
                        labelText: 'Chức vụ',
                        hintText: 'Chức vụ của nhân viên',
                      ),
                      enabled: false, // Không cho phép thay đổi
                    ),

                    // TextFormField(
                    //   initialValue: _trangThai,
                    //   decoration: InputDecoration(labelText: 'Trạng thái'),
                    //   onSaved: (value) {
                    //     _trangThai = value ?? '';
                    //   },
                    // ),
                    DropdownButtonFormField<String>(
                      value: _trangThai.isNotEmpty
                          ? _trangThai
                          : null, // Giá trị mặc định
                      decoration: InputDecoration(
                        labelText: 'Trạng thái',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Đang hoạt động',
                          child: Text('Đang hoạt động'),
                        ),
                        DropdownMenuItem(
                          value: 'Dừng hoạt động',
                          child: Text('Dừng hoạt động'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _trangThai = value ?? '';
                        });
                      },
                      onSaved: (value) {
                        _trangThai = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn trạng thái';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: submitTaiKhoan,
                      child: Text(widget.taiKhoan == null ? 'Thêm' : 'Sửa'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class TaiKhoanPage extends StatefulWidget {
  @override
  _TaiKhoanPageState createState() => _TaiKhoanPageState();
}

class _TaiKhoanPageState extends State<TaiKhoanPage> {
  late Future<List<TaiKhoan>> _taiKhoanFuture;
  final TaiKhoanService _taiKhoanService = TaiKhoanService();
  late List<NhanVien> _nhanViens = [];

  @override
  void initState() {
    super.initState();
    _loadTaiKhoan();
    _fetchNhanViens();
  }

  void _loadTaiKhoan() {
    setState(() {
      _taiKhoanFuture = _taiKhoanService.getTaiKhoans();
    });
  }

  Future<void> _fetchNhanViens() async {
    try {
      _nhanViens = await DropdownService.fetchNhanVien();
      setState(() {});
    } catch (e) {
      print('Lỗi khi tải danh sách nhân viên: $e');
    }
  }

  Future<void> _deleteTaiKhoan(int id) async {
    try {
      await _taiKhoanService.deleteTaiKhoan(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa tài khoản thành công')),
      );
      _loadTaiKhoan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa tài khoản thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý tài khoản'),backgroundColor: Colors.purple,),
      backgroundColor: Colors.purple[100],
      body: FutureBuilder<List<TaiKhoan>>(
        future: _taiKhoanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có tài khoản nào'));
          }

          final taiKhoans = snapshot.data!;

          return ListView.builder(
            itemCount: taiKhoans.length,
            itemBuilder: (context, index) {
              final taiKhoan = taiKhoans[index];
              return Card(
                child: ListTile(
                  title:  
                  Text(
                        'Nhân viên: ${_nhanViens.firstWhere(
                              (nv) => nv.id == taiKhoan.nhanVienId,
                              orElse: () => NhanVien(
                                id: 0,
                                hoTen: 'Không xác định',
                                nhanVienID: '',
                                ngaySinh: DateTime.now(),
                                diaChi: '',
                                sdt: '',
                                email: '',
                                phongBanId: 0,
                                chucVuId: 0,
                                ngayVaoLam: DateTime.now(),
                                trangThaiID: 0,
                              ),
                            ).hoTen}',
                      ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Tên tài khoản: ${taiKhoan.tenDangNhap}'),
                      Text('Trạng thái: ${taiKhoan.trangThai ?? 'Không có ghi chú'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditTaiKhoanPage(taiKhoan: taiKhoan),
                            ),
                          );
                          if (result == true) _loadTaiKhoan();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(taiKhoan.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaiKhoanPage()),
          );
          if (result == true) _loadTaiKhoan();
        },
      ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa tài khoản này không?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Xóa'),
            onPressed: () {
              Navigator.pop(context);
              _deleteTaiKhoan(id);
            },
          ),
        ],
      ),
    );
  }
}
