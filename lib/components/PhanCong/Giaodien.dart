import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart' as nhansu;
import 'package:flutter_application_1/components/PhanCong/Assignment_screen.dart' as phancong;
import 'package:flutter_application_1/components/Nhansu/add_human_resources.dart';
import 'package:flutter_application_1/components/CongViec/Task.dart';

class PhanCongPage extends StatefulWidget {
  @override
  _PhanCongPageState createState() => _PhanCongPageState();
}

class _PhanCongPageState extends State<PhanCongPage> {
  late phancong.ApiService apiService;
  late Future<List<phancong.PhanCong>> phanCongs;
  List<nhansu.NhanVien> nhanViens = [];

  @override
  void initState() {
    super.initState();
    apiService = phancong.ApiService();
    phanCongs = apiService.getPhanCongs();
    _fetchNhanViens();
  }

  void _fetchNhanViens() async {
    try {
     nhanViens = await phancong.DropdownService.fetchNhanVien();
      setState(() {});
    } catch (e) {
      print('Error fetching nhanViens: $e');
    }
  }

  String getNhanVienNameById(int id, List<nhansu.NhanVien> nhanViens) {
  final nhanVien = nhanViens.firstWhere(
    (nv) => nv.id == id,
    orElse: () => nhansu.NhanVien(
        id: 0,
        nhanVienID: '',
        hoTen: 'Không xác định',
        ngaySinh: DateTime.now(),
        diaChi: '',
        sdt: '',
        email: '',
        phongBanId: 0,
        chucVuId: 0,
        ngayVaoLam: DateTime.now(),
        trangThaiID: 0,
        gioiTinh: '',
    ),
  );
  return nhanVien.hoTen;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Phân Công'),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.pink[100],
      body: FutureBuilder<List<phancong.PhanCong>>(
        future: phanCongs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phân công nào.'));
          } else {
            List<phancong.PhanCong> phanCongList = snapshot.data!;

            return ListView.builder(
              itemCount: phanCongList.length,
              itemBuilder: (context, index) {
                phancong.PhanCong phanCong = phanCongList[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4, // Độ cao của bóng đổ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc cho Card
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phanCong.tenCongViecPhanCong,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                  'Người phân công: ${getNhanVienNameById(phanCong.nguoiPhanCongId, nhanViens)}'),
                              SizedBox(height: 4),
                              Text(
                                  'Người được phân công: ${getNhanVienNameById(phanCong.nguoiDuocPhanCongId, nhanViens)}'),
                              SizedBox(height: 4),
                              Text(
                                  'Ngày bắt đầu: ${phanCong.ngayBatDau != null ? phanCong.ngayBatDau!.toLocal().toString().split(' ')[0] : 'Chưa có ngày bắt đầu'}'),
                              SizedBox(height: 4),
                              Text('Trạng thái: ${phanCong.trangThai}'),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editPhanCong(context, phanCong);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deletePhanCong(phanCong.id, context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPhanCong(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addPhanCong(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return phancong.AddEditPhanCongDialog(
          onSave: (phancong.PhanCong phanCong) async {
            await apiService.createPhanCong(phanCong);
            setState(() {
              phanCongs = apiService.getPhanCongs();
            });
          },
        );
      },
    );
  }

  void _editPhanCong(BuildContext context, phancong.PhanCong phanCong) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return phancong.AddEditPhanCongDialog(
          phanCong: phanCong,
          onSave: (phancong.PhanCong updatedPhanCong) async {
            await apiService.updatePhanCong(
                updatedPhanCong.id, updatedPhanCong);
            setState(() {
              phanCongs = apiService.getPhanCongs();
            });
          },
        );
      },
    );
  }

  //  void _deletePhanCong(int id, BuildContext context) {
  //   // Xác nhận và xóa phân công
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Xóa phân công'),
  //         content: Text('Bạn có chắc muốn xóa phân công này không?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               apiService.deletePhanCong(id); // Xóa phân công
  //               setState(() {
  //                 phanCongs = apiService.getPhanCongs();
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Xóa'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Hủy'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _deletePhanCong(int id, BuildContext context) {
    // Xác nhận và xóa phân công
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa phân công'),
          content: Text('Bạn có chắc muốn xóa phân công này không?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await apiService.deletePhanCong(id); // Xóa phân công
                  setState(() {
                    phanCongs = apiService.getPhanCongs();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  // Hiển thị thông báo lỗi nếu không thể xóa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Không thể xóa phân công. Vui lòng thử lại!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Xóa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }
}
