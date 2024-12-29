import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:intl/intl.dart';

class HopDong {
  int id;
  int hopDongId;
  String tenHopDong;
  int nhanVienId;
  DateTime  ngayBatDau;
  DateTime ?ngayKetThuc;
  String? ghiChu;
  double luongCoBan;
  String trangThai;
    String? hoTen;  // Added
   // Added
  HopDong({
    required this.id,
    required this.hopDongId,
    required this.tenHopDong,
    required this.nhanVienId,
    required this.ngayBatDau,
    required this.luongCoBan,
    this.ghiChu,
 this.ngayKetThuc, // Added
    required this.trangThai, 
        this.hoTen,// Added
  });
  factory HopDong.fromJson(Map<String, dynamic> json) {
    return HopDong(
      id: json['id'] as int,
      hopDongId: json['hopDongId'] as int,
      nhanVienId: json['nhanVienId'] as int,
      luongCoBan:(json['luongCoBan'] as num).toDouble(), // Chuyển đổi thành double
      trangThai: json['trangThai'],
      ghiChu: json['ghiChu'] as String?,
      tenHopDong: json['tenHopDong'], // Added
     ngayKetThuc: json['ngayKetThuc'] != null ? DateTime.parse(json['ngayKetThuc']) : null,

      ngayBatDau: DateTime.parse(json['ngayBatDau']),
            hoTen: json['hoTen'] as String?, 
      // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hopDongId': hopDongId,
      'nhanVienId': nhanVienId,
      'luongCoBan': luongCoBan,
      'trangThai': trangThai,
      'ghiChu': ghiChu ?? '',
      'tenhopDong': tenHopDong, // Added
       'ngayBatDau': ngayBatDau.toIso8601String(), // Chuyển đổi DateTime sang chuỗi
    'ngayKetThuc': ngayKetThuc?.toIso8601String() ?? '', // Chuyển đổi DateTime sang chuỗi (nếu không null)
            'hoTen': hoTen,// Added
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

class HopDongService {
  final String baseUrl = 'http://192.168.239.219:5000/api/HopDongs';

  Future<List<HopDong>> getHopDongs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => HopDong.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load HopDongs');
    }
  }

Future<List<HopDong>> getHopDongsWithNames(
    List<NhanVien> nhanViens) async {
    final hopDongs = await getHopDongs();

    for (var hopDong in hopDongs) {

      final nhanVien = nhanViens.firstWhere(
        (n) => n.id == hopDong.nhanVienId,
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

      hopDong.hoTen = nhanVien.hoTen;
    }
    return hopDongs;
  }

  // Lấy một HopDong theo ID
  Future<HopDong> getHopDong(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return HopDong.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load HopDong');
    }
  }
Future<bool> checkIfNhanVienHasHopDong(int nhanVienId) async {
  final response = await http.get(Uri.parse('$baseUrl?nhanVienId=$nhanVienId'));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);

    // Kiểm tra hợp đồng có đúng nhân viên không
    return jsonResponse.any((hopDong) => hopDong['nhanVienId'] == nhanVienId);
  } else {
    throw Exception('Failed to load HopDongs');
  }
}

  // Thêm mới một danhgia
  Future<void> createHopDong(HopDong hopDong) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(hopDong.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create DanhGia');
    }
  }

  Future<void> updateHopDong(int id, HopDong hopDong) async {
    final url = Uri.parse('$baseUrl/${hopDong.id}');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'id': id,
      'hopDongId': hopDong.hopDongId,
      'tenHopDong': hopDong.tenHopDong,
      'luongCoBan': hopDong.luongCoBan,
      'nhanVienId': hopDong.nhanVienId,
      'ngayBatDau': hopDong.ngayBatDau,
      'ngayKetThuc': hopDong.ngayKetThuc,
      'trangThai': hopDong.trangThai, // Added
      'ghiChu': hopDong.ghiChu ?? '',
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

  Future<void> deleteHopDong(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );
      if (response.statusCode != 20) {
        throw Exception('Failed to delete HopDong');
      }
    } on Exception catch (e) {
      print('Error deleting HopDong: $e');
      // Handle the exception here, for example, show an error message to the user
    }
  }
}

class AddEditHopDongPage extends StatefulWidget {
  final HopDong? hopDong;

  AddEditHopDongPage({this.hopDong});

  @override
  _AddEditDanhGiaPageState createState() => _AddEditDanhGiaPageState();
}

class _AddEditDanhGiaPageState extends State<AddEditHopDongPage> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  int? _hopDongId;
  List<NhanVien> _nhanViens = [];
  int? _selectedNhanVienId;
  double _luongCoBan = 0;
  String _ghiChu = '';
  DateTime _ngayBatDau = DateTime.now();
  DateTime?  _ngayKetThuc;
 String? _trangThai ;
 String? _tenHopDong;
  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    if (widget.hopDong != null) {
      // Pre-fill data for editing
      id = widget.hopDong!.id;
      _hopDongId = widget.hopDong!.hopDongId;
      _selectedNhanVienId = widget.hopDong!.nhanVienId;
      _luongCoBan = widget.hopDong!.luongCoBan;
      _ghiChu = widget.hopDong!.ghiChu ?? '';
      _ngayBatDau = widget.hopDong!.ngayBatDau;
      _ngayKetThuc = widget.hopDong!.ngayKetThuc;
      _tenHopDong = widget.hopDong!.tenHopDong;
      _trangThai = widget.hopDong!.trangThai; // Added
    }
  }

  Future<void> fetchDropdownData() async {
    _nhanViens = await DropdownService.fetchNhanVien();
    setState(() {});
  }

  Future<void> submitHopDong() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      final Map<String, dynamic> requestData = {
        'id': id,
        'hopDongId': _hopDongId,
        'luongCoBan': _luongCoBan,
        'nhanVienId': _selectedNhanVienId,
        'ghiChu': _ghiChu,
        'ngayBatDau': _ngayBatDau.toIso8601String(),
        'ngayKetThuc': _ngayKetThuc?.toIso8601String() ?? '',
        'trangThai': _trangThai,
        'tenHopDong': _tenHopDong,
      };

      // Kiểm tra trước khi tạo hợp đồng
      final hopDongService = HopDongService();
      bool hasContract = await hopDongService.checkIfNhanVienHasHopDong(_selectedNhanVienId!);
      if (hasContract) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nhân viên đã có hợp đồng.')));
        return;
      }

      if (widget.hopDong == null) {
        // Tạo hợp đồng mới
        await hopDongService.createHopDong(HopDong.fromJson(requestData));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm hợp đồng thành công!')),
        );
      } else {
        // Cập nhật hợp đồng hiện tại
        await hopDongService.updateHopDong(id, HopDong.fromJson(requestData));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật hợp đồng thành công!')),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hopDong == null ? 'Thêm Hợp Đồng' : 'Sửa Hợp Đồng'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green[100],
      body: _nhanViens.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _hopDongId != null ?  _hopDongId.toString(): '',
                      decoration: InputDecoration(labelText: 'Hợp Đồng ID', hintText: 'Nhập Id'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _hopDongId = int.tryParse(value!),
                    ),
                    TextFormField(
                initialValue: _tenHopDong,
                decoration:
                    InputDecoration(labelText: 'Tên hợp đồng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên hợp đồng.';
                  }
                  return null;
                },
                onSaved: (value) => _tenHopDong = value,
              ),
                    // DropdownButtonFormField<int>(
                    //   value: _selectedNhanVienId,
                    //   hint: Text('Chọn nhân viên'),
                    //   items: _nhanViens.map((nhanVien) {
                    //     return DropdownMenuItem<int>(
                    //       value: nhanVien.id,
                    //       child: Text(nhanVien.hoTen),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedNhanVienId = value;
                    //     });
                    //   },
                    //   validator: (value) =>
                    //       value == null ? 'Vui lòng chọn nhân viên' : null,
                    // ),
                     // Kiểm tra xem có phải chỉnh sửa hay không
                    widget.hopDong == null
                        ? DropdownButtonFormField<int>(
                            value: _selectedNhanVienId,
                            decoration: InputDecoration(labelText: 'Chọn Nhân Viên'),
                            onChanged: (value) {
                              setState(() {
                                _selectedNhanVienId = value;
                              });
                            },
                            items: _nhanViens.map((nv) {
                              return DropdownMenuItem<int>(
                                value: nv.id,
                                child: Text(nv.hoTen),
                              );
                            }).toList(),
                            validator: (value) => value == null ? 'Vui lòng chọn nhân viên' : null,
                          )
                        : TextFormField(
                            enabled: false, // Không cho phép chỉnh sửa
                            initialValue: _selectedNhanVienId != null
                                ? _nhanViens.firstWhere((nv) => nv.id == _selectedNhanVienId!).hoTen
                                : '',
                            decoration: InputDecoration(labelText: 'Nhân Viên'),
                          ),
                    TextFormField(
                      initialValue: _luongCoBan.toString(),
                      decoration: InputDecoration(labelText: 'Lương cơ bản'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập lương cơ bản';
                        }
                        final parsedValue = double.tryParse(value);
                        if (parsedValue == null) {
                          return 'Vui lòng nhập số hợp lệ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _luongCoBan = double.tryParse(value ?? '0') ?? 0;
                      },
                    ),
                    ListTile(
                title: Text(
                    'Ngày bắt đầu: ${_ngayBatDau != null ? _ngayBatDau.toLocal().toString().split(' ')[0] : 'Chọn ngày'}'),
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
                      _ngayBatDau = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                    'Ngày kết thúc: ${_ngayKetThuc != null ? _ngayKetThuc!.toLocal().toString().split(' ')[0] : 'Chọn ngày'}'),
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
                      _ngayKetThuc = pickedDate;
                    });
                  }
                },
              ),
                    TextFormField(
                      initialValue: _ghiChu,
                      decoration: InputDecoration(labelText: 'Ghi chú'),
                      onSaved: (value) {
                        _ghiChu = value ?? '';
                      },
                    ),
                     DropdownButton<String>(
                isExpanded: true,
                value: _trangThai,
                hint: Text('Chọn trạng thái'),
                items: ['Đã ký hợp đồng']
                    .map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _trangThai = value;
                  });
                },
              ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: submitHopDong,
                      child: Text(widget.hopDong == null ? 'Thêm' : 'Sửa'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class HopDongPage extends StatefulWidget {
  @override
  _HopDongPageState createState() => _HopDongPageState();
}

class _HopDongPageState extends State<HopDongPage> {
  late Future<List<HopDong>> _hopDongFuture;
  final HopDongService _hopDongService = HopDongService();

  @override
  void initState() {
    super.initState();
    _loadHopDongs();
  }
void _loadHopDongs() {
    setState(() {
      _hopDongFuture = _loadHopDong();
    });
  }
  Future<List<HopDong>> _loadHopDong() async {
    final nhanViens = await DropdownService.fetchNhanVien();
    return _hopDongService.getHopDongsWithNames(nhanViens);
  }

  Future<void> _deleteHopDong(int id) async {
    try {
      await _hopDongService.deleteHopDong(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa hợp đồng thành công')),
      );
      _loadHopDongs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa hợp đồng thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý hợp đồng'), backgroundColor: Colors.green,),
      backgroundColor: Colors.green[100],
      body: FutureBuilder<List<HopDong>>(
        future: _hopDongFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có hợp đồng nào'));
          }

          final hopDongs = snapshot.data!;

          return ListView.builder(
            itemCount: hopDongs.length,
            itemBuilder: (context, index) {
              final hopDong = hopDongs[index];
              
              return Card(
                child: ListTile(
                  title: Text('Lương: ${hopDong.luongCoBan}'),
                 subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên hợp đồng: ${hopDong.tenHopDong}'),
                      Text('Nhân vien: ${hopDong.hoTen ?? 'Không rõ'}'),
                      Text('Ghi chú: ${hopDong.ghiChu ?? 'Không có ghi chú'}'),
                      Text('Ngày bắt đầu: ${hopDong.ngayBatDau.toLocal().toString().split(' ')[0]}'),
                      Text('Ngày kết thúc: ${hopDong.ngayKetThuc?.toLocal().toString().split(' ')[0]?? 'Không rõ'}'),
                      Text('Trạng thái: ${hopDong.trangThai}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () async {
                      //     final result = await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             AddEditHopDongPage(hopDong: hopDong),
                      //       ),
                      //     );
                      //     if (result == true) _loadHopDong();
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(hopDong.id),
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
            MaterialPageRoute(builder: (context) => AddEditHopDongPage()),
          );
          if (result == true) {
            _loadHopDongs();
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa hợp đồng này không?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Xóa'),
            onPressed: () {
              Navigator.pop(context);
              _deleteHopDong(id);
            },
          ),
        ],
      ),
    );
  }
}