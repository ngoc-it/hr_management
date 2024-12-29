import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/components/Nhansu/add_human_resources.dart';
import 'package:flutter_application_1/models/chucvu_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/phongban_model.dart';
import 'package:flutter_application_1/service/chucvu_service.dart';
import 'package:image_picker/image_picker.dart';

//tạo model
// nhanvien.dart
class NhanVien {
  final int id;
  final String nhanVienID;
  final String hoTen;
  final DateTime ngaySinh;
  final String diaChi;
  final String sdt;
  final String? anh;
  final String email;
  final int phongBanId;
  final int chucVuId;
  final DateTime ngayVaoLam;
  final int trangThaiID;
  final String? gioiTinh;

  NhanVien({
    required this.id,
    required this.nhanVienID,
    required this.hoTen,
    required this.ngaySinh,
    required this.diaChi,
    required this.sdt,
    this.anh,
    required this.email,
    required this.phongBanId,
    required this.chucVuId,
    required this.ngayVaoLam,
    required this.trangThaiID,
    this.gioiTinh,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'],
      nhanVienID: json['nhanVienID'],
      hoTen: json['hoTen'],
      ngaySinh: DateTime.parse(json['ngaySinh']),
      diaChi: json['diaChi'],
      sdt: json['sdt'],
      anh: json['anh'],
      email: json['email'],
      phongBanId: json['phongBanId'],
      chucVuId: json['chucVuId'],
      ngayVaoLam: DateTime.parse(json['ngayVaoLam']),
      trangThaiID: json['trangThaiID'],
      gioiTinh: json['gioiTinh'],
    );
  }
  // Phương thức chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nhanVienID': nhanVienID,
      'hoTen': hoTen,
      'ngaySinh': ngaySinh.toIso8601String(), // Đảm bảo chuyển DateTime thành ISO 8601 string
      'diaChi': diaChi,
      'sdt': sdt,
      'anh': anh,
      'email': email,
      'phongBanId': phongBanId,
      'chucVuId': chucVuId,
      'ngayVaoLam': ngayVaoLam.toIso8601String(), // Chuyển DateTime thành ISO 8601 string
      'trangThaiID': trangThaiID,
      'gioiTinh': gioiTinh,
    'chucVu': {
      'id': chucVuId,
      'tenChucVu': '', // Cần được cập nhật với tên chức vụ thực tế
    },
    'phongBan': {
      'id': phongBanId,
      'tenPhongBan': '', // Cần được cập nhật với tên phòng ban thực tế
    }
    };
  }
}


//tạo dropdow để chọn 
class DropdownService {
  static Future<List<PhongBan>> fetchPhongBan() async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/PhongBans'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => PhongBan.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load PhongBan');
    }
  }

  static Future<List<ChucVu>> fetchChucVu() async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/ChucVus'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => ChucVu.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ChucVu');
    }
  }
}
class NhanVienController {
  final String baseUrl = 'http://192.168.239.219:5000/api/NhanViens';

  // Thêm nhân viên
  Future<void> addNhanVien(NhanVien nhanVien) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nhanVien.toJson()),
    );
    //if (response.statusCode != 201) {
    //  throw Exception('Failed to add NhanVien');
   // }
   if (response.statusCode != 201) {
  print('Error response: ${response.body}');
}

  }

Future<void> updateNhanVien(int id, NhanVien nhanVien) async {
  print('Updating NhanVien with ID: $id');
  final requestBody = jsonEncode(nhanVien.toJson());
  print('Request body: $requestBody');
  
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: requestBody,
  );
  
  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Failed to update NhanVien: ${response.statusCode}\nResponse: ${response.body}');
  }
}

    // Xóa nhân viên
  Future<void> deleteNhanVien(int id) async {
    
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete NhanVien');
    }
  }

  Future<bool> checkNhanVienID(String nhanVienID) async {
  final response = await http.get(Uri.parse('$baseUrl/CheckNhanVienID/$nhanVienID'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['exists'] as bool;
  } else {
    throw Exception('Failed to check NhanVienID');
  }
}


  // Lấy danh sách nhân viên
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load NhanViens');
    }
  }

  // Upload ảnh cho nhân viên
  Future<String> uploadImage(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/UploadImage'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var res = await request.send();
    if (res.statusCode == 200) {
      var responseData = await res.stream.bytesToString();
      var imageUrl = json.decode(responseData)['Url'];
      return imageUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  fetchPhongBan(int phongBanId) {}

  fetchChucVu(int chucVuId) {}
}

class NhanVienForm extends StatefulWidget {
  final NhanVien? nhanVien;
  NhanVienForm({Key? key, this.nhanVien}) : super(key: key);

  @override
  _NhanVienFormState createState() => _NhanVienFormState();
}

class _NhanVienFormState extends State<NhanVienForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nhanVienIDController, _hoTenController, _emailController, _diaChiController, _sdtController;
  DateTime? _ngaySinh, _ngayVaoLam;
  File? _imageFile;
  int? _phongBanId, _chucVuId;
  String? _gioiTinh;
  final NhanVienController _nhanVienController = NhanVienController();
  List<PhongBan> _phongBans = [];
  List<ChucVu> _chucVus = [];

  @override
  void initState() {
    super.initState();
    _nhanVienIDController = TextEditingController();
    _hoTenController = TextEditingController();
    _emailController = TextEditingController();
    _diaChiController = TextEditingController();
    _sdtController = TextEditingController();

    if (widget.nhanVien != null) {
      // Nếu chỉnh sửa nhân viên
      _nhanVienIDController.text = widget.nhanVien!.nhanVienID;
      _hoTenController.text = widget.nhanVien!.hoTen;
      _emailController.text = widget.nhanVien!.email;
      _diaChiController.text = widget.nhanVien!.diaChi;
      _sdtController.text = widget.nhanVien!.sdt;
      _ngaySinh = widget.nhanVien!.ngaySinh;
      _ngayVaoLam = widget.nhanVien!.ngayVaoLam;
      _phongBanId = widget.nhanVien!.phongBanId;
      _chucVuId = widget.nhanVien!.chucVuId;
      _gioiTinh = widget.nhanVien!.gioiTinh;
    }

    // Lấy danh sách phòng ban và chức vụ
    _loadData();
  }

  Future<void> _loadData() async {
    _phongBans = await DropdownService.fetchPhongBan();
    _chucVus = await DropdownService.fetchChucVu();
    setState(() {});
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {

      // Kiểm tra mã nhân viên có trùng không
      bool exists = await _nhanVienController.checkNhanVienID(_nhanVienIDController.text);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mã nhân viên đã tồn tại, vui lòng chọn mã khác!'), backgroundColor: Colors.red),
        );
        return; // Dừng xử lý nếu mã nhân viên đã tồn tại
      }
      // Tìm tên chức vụ và 
      //phòng ban dựa trên ID đã chọn
      String tenChucVu = _chucVus.firstWhere((cv) => cv.id == _chucVuId).tenChucVu;
      String tenPhongBan = _phongBans.firstWhere((pb) => pb.id == _phongBanId).tenPhongBan;

      NhanVien nhanVien = NhanVien(
        id: widget.nhanVien?.id ?? 0,
        nhanVienID: _nhanVienIDController.text,
        hoTen: _hoTenController.text,
        ngaySinh: _ngaySinh!,
        diaChi: _diaChiController.text,
        sdt: _sdtController.text,
        anh: _imageFile?.path,
        email: _emailController.text,
        phongBanId: _phongBanId!,
        chucVuId: _chucVuId!,
        ngayVaoLam: _ngayVaoLam!,
        trangThaiID: 1,
        gioiTinh: _gioiTinh,
      );

      // Cập nhật tên chức vụ và phòng ban
      var nhanVienJson = nhanVien.toJson();
      nhanVienJson['chucVu']['tenChucVu'] = tenChucVu;
      nhanVienJson['phongBan']['tenPhongBan'] = tenPhongBan;

      if (widget.nhanVien == null) {
        await _nhanVienController.addNhanVien(NhanVien.fromJson(nhanVienJson));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm nhân viên thành công!')),
        );
        Navigator.of(context).pop(NhanVien.fromJson(nhanVienJson));
      } else {
        await _nhanVienController.updateNhanVien(widget.nhanVien!.id, NhanVien.fromJson(nhanVienJson));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật nhân viên thành công!')),
        );
        Navigator.of(context).pop(NhanVien.fromJson(nhanVienJson));
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'Có lỗi xảy ra: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(backgroundColor: Colors.green.shade500, 
      title: Text(widget.nhanVien == null ? 'Thêm Nhân Viên' : 'Cập Nhật Nhân Viên')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
             TextFormField(
                controller: _nhanVienIDController,
                decoration: InputDecoration(labelText: 'Mã nhân viên'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập mã nhân viên' : null,
              ),
              TextFormField(
                controller: _hoTenController,
                decoration: InputDecoration(labelText: 'Họ và tên'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập họ và tên' : null,
              ),
              // TextFormField(
              //   controller: _emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              //   validator: (value) => value!.isEmpty ? 'Vui lòng nhập email' : null,
              // ),
              TextFormField(
  controller: _emailController,
  decoration: InputDecoration(labelText: 'Email'),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    // RegEx kiểm tra định dạng email
    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null; // Không có lỗi
  },
),

              TextFormField(
                controller: _diaChiController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              // TextFormField(
              //   controller: _sdtController,
              //   decoration: InputDecoration(labelText: 'Số điện thoại'),
              //   validator: (value) => value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
              // ),
              TextFormField(
  controller: _sdtController,
  decoration: InputDecoration(labelText: 'Số điện thoại'),
  keyboardType: TextInputType.phone, // Đặt loại bàn phím cho số điện thoại
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Kiểm tra số điện thoại có đúng định dạng 10 chữ số không
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Số điện thoại phải gồm 10 chữ số';
    }
    return null; // Không có lỗi
  },
),


              Row(
                children: [
                  Text('Ngày sinh: '),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _ngaySinh ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null && selectedDate != _ngaySinh) {
                        setState(() {
                          _ngaySinh = selectedDate;
                        });
                      }
                    },
                    child: Text(_ngaySinh == null ? 'Chọn ngày' : DateFormat('dd/MM/yyyy').format(_ngaySinh!)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Ngày vào làm: '),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _ngayVaoLam ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null && selectedDate != _ngayVaoLam) {
                        setState(() {
                          _ngayVaoLam = selectedDate;
                        });
                      }
                    },
                    child: Text(_ngayVaoLam == null ? 'Chọn ngày' : DateFormat('dd/MM/yyyy').format(_ngayVaoLam!)),
                  ),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _phongBanId,
                decoration: InputDecoration(labelText: 'Chọn phòng ban'),
                items: _phongBans.map((PhongBan phongBan) {
                  return DropdownMenuItem<int>(
                    value: phongBan.id,
                    child: Text(phongBan.tenPhongBan),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _phongBanId = value),
              ),
              DropdownButtonFormField<int>(
                value: _chucVuId,
                decoration: InputDecoration(labelText: 'Chọn chức vụ'),
                items: _chucVus.map((ChucVu chucVu) {
                  return DropdownMenuItem<int>(
                    value: chucVu.id,
                    child: Text(chucVu.tenChucVu),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _chucVuId = value),
              ),
              Row(
                children: [
                  Text('Giới tính: '),
                  Radio<String>(
                    value: 'Nam',
                    groupValue: _gioiTinh,
                    onChanged: (value) => setState(() => _gioiTinh = value),
                  ),
                  Text('Nam'),
                  Radio<String>(
                    value: 'Nữ',
                    groupValue: _gioiTinh,
                    onChanged: (value) => setState(() => _gioiTinh = value),
                  ),
                  Text('Nữ'),
                ],
              ),
              TextButton(
                onPressed: _pickImage,
                child: _imageFile == null
                    ? Text('Chọn ảnh')
                    : Image.file(_imageFile!, width: 100, height: 100),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.nhanVien == null ? 'Thêm Nhân Viên' : 'Cập Nhật Nhân Viên'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}