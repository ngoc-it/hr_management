import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for DateFormat

class PhongBan {
  int id;
  int phongBanID;
  String tenPhongBan;

  PhongBan({required this.id, required this.phongBanID, required this.tenPhongBan});

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    return PhongBan(
      id: json['id'] ?? 0,
      phongBanID: json['phongBanID'],
      tenPhongBan: json['tenPhongBan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phongBanID': phongBanID,
      'tenPhongBan': tenPhongBan,
    };
  }
}

class PhongBanService {
  final String apiUrl = 'http://192.168.239.219:5000/api/PhongBans';

  Future<List<PhongBan>> fetchPhongBan() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PhongBan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<PhongBan> addPhongBan(PhongBan phongBan) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phongBan.toJson()),
    );
    if (response.statusCode == 201) {
      return PhongBan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add department');
    }
  }

  Future<void> updatePhongBan(PhongBan phongBan) async {
    final url = Uri.parse('$apiUrl/${phongBan.id}');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'id': phongBan.id,
      'phongBanID': phongBan.phongBanID,
      'tenPhongBan': phongBan.tenPhongBan,
    });

    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update department');
    }
  }

  Future<void> deletePhongBan(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete department');
    }
  }
  Future<bool> isPhongBanIDExist(int phongBanID) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<PhongBan> phongBans = jsonList.map((json) => PhongBan.fromJson(json)).toList();
      // Check if phongBanID already exists
      return phongBans.any((phongBan) => phongBan.phongBanID == phongBanID);
    } else {
      throw Exception('Failed to load departments');
    }
  }
  Future<bool> isPhongBanNameExist(String tenPhongBan) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<PhongBan> phongBans = jsonList.map((json) => PhongBan.fromJson(json)).toList();
      // Check if the department name already exists
      return phongBans.any((phongBan) => phongBan.tenPhongBan == tenPhongBan);
    } else {
      throw Exception('Failed to load departments');
    }
  }
}

class PhongBanManager extends StatefulWidget {
  @override
  _PhongBanManagerState createState() => _PhongBanManagerState();
}

class _PhongBanManagerState extends State<PhongBanManager> {
  late Future<List<PhongBan>> futurePhongBan;
  final PhongBanService _phongBanService = PhongBanService();
  final _formKey = GlobalKey<FormState>();
  late String tenPhongBan;
  late int phongBanID;
  PhongBan? selectedPhongBan;

  int currentPage = 0;
  int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    futurePhongBan = _phongBanService.fetchPhongBan();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepOrange, // Thêm màu cam đậm cho AppBar
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(); // Quay lại trang trước
        },
      ),
      title: Text('Danh sách phòng ban'), // Thêm tiêu đề "Danh sách phòng ban"
    ),
    body: SafeArea(
      child: FutureBuilder<List<PhongBan>>(
        future: futurePhongBan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phòng ban nào.'));
          }

          final data = snapshot.data!;
          final totalPages = (data.length / itemsPerPage).ceil();
          final startIndex = currentPage * itemsPerPage;
          final endIndex = (startIndex + itemsPerPage > data.length)
              ? data.length
              : startIndex + itemsPerPage;
          final paginatedData = data.sublist(startIndex, endIndex);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Hiển thị 4 card mỗi hàng 2 cột
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: paginatedData.length,
                  itemBuilder: (context, index) {
                    final phongBan = paginatedData[index];
                    return Card(
                      elevation: 5, // Hiệu ứng nổi nhẹ
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã: ${phongBan.phongBanID}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text('Tên: ${phongBan.tenPhongBan}'),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    selectedPhongBan = phongBan;
                                    _showFormDialog();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(phongBan.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: currentPage > 0
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                        : null,
                  ),
                  Text('Trang ${currentPage + 1} / $totalPages'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages - 1
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue, // Thêm màu sắc cho nút FAB
      onPressed: _showFormDialog,
      child: Icon(Icons.add),
    ),
    backgroundColor: Colors.orange[50], // Màu nền phía dưới (màu cam nhạt)
  );
}


 void _showFormDialog() {
  if (selectedPhongBan != null) {
    tenPhongBan = selectedPhongBan!.tenPhongBan;
    phongBanID = selectedPhongBan!.phongBanID;
  }
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(selectedPhongBan == null ? 'Thêm Phòng Ban' : 'Sửa Phòng Ban'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: selectedPhongBan?.phongBanID.toString(),
                decoration: InputDecoration(labelText: 'Mã Phòng Ban'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã phòng ban';
                  }
                  return null;
                },
                onSaved: (value) {
                  phongBanID = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: selectedPhongBan?.tenPhongBan,
                decoration: InputDecoration(labelText: 'Tên Phòng Ban'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên phòng ban';
                  }
                  return null;
                },
                onSaved: (value) {
                  tenPhongBan = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                
                // Check if either the department ID or name already exists
                bool isIDExist = await _phongBanService.isPhongBanIDExist(phongBanID);
                bool isNameExist = await _phongBanService.isPhongBanNameExist(tenPhongBan);
                
                if (isIDExist) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mã phòng ban đã tồn tại. Vui lòng chọn mã khác.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (isNameExist) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tên phòng ban đã tồn tại. Vui lòng chọn tên khác.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  PhongBan phongBan = PhongBan(
                    id: selectedPhongBan?.id ?? 0,
                    phongBanID: phongBanID,
                    tenPhongBan: tenPhongBan,
                  );

                  if (selectedPhongBan == null) {
                    _phongBanService.addPhongBan(phongBan).then((_) {
                      setState(() {
                        futurePhongBan = _phongBanService.fetchPhongBan();
                      });
                      Navigator.pop(context);
                      selectedPhongBan = null;
                    });
                  } else {
                    _phongBanService.updatePhongBan(phongBan).then((_) {
                      setState(() {
                        futurePhongBan = _phongBanService.fetchPhongBan();
                      });
                      Navigator.pop(context);
                      selectedPhongBan = null;
                    });
                  }
                }
              }
            },
            child: Text(selectedPhongBan == null ? 'Thêm' : 'Cập nhật'),
          ),
          TextButton(
            onPressed: () {
              selectedPhongBan = null;
              Navigator.pop(context);
            },
            child: Text('Hủy'),
          ),
        ],
      );
    },
  );
}


  // void _showDeleteConfirmationDialog(int id) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Xác nhận xóa'),
  //         content: Text('Bạn có chắc chắn muốn xóa phòng ban này?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Hủy'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await _phongBanService.deletePhongBan(id);
  //               setState(() {
  //                 futurePhongBan = _phongBanService.fetchPhongBan();
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Xóa'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showDeleteConfirmationDialog(int id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa phòng ban này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Try to delete the department
                await _phongBanService.deletePhongBan(id);
                setState(() {
                  futurePhongBan = _phongBanService.fetchPhongBan();
                });
                Navigator.of(context).pop();
              } catch (e) {
                // Show an error message if deletion fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xóa phòng ban không thành công: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Xóa'),
          ),
        ],
      );
    },
  );
}

}