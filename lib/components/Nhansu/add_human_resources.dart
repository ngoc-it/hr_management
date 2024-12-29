import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/models/chucvu_model.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:flutter_application_1/models/phongban_model.dart';

class NhanVienTablePage extends StatefulWidget {
  @override
  _NhanVienTablePageState createState() => _NhanVienTablePageState();
}

class _NhanVienTablePageState extends State<NhanVienTablePage> {
  final NhanVienController _nhanVienController = NhanVienController();
  List<NhanVien> _nhanViens = [];
  List<PhongBan> _phongBans = [];
  List<ChucVu> _chucVus = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _nhanViens = await _nhanVienController.fetchNhanViens();
    _phongBans = (await DropdownService.fetchPhongBan()).cast<PhongBan>();
    _chucVus = await DropdownService.fetchChucVu();
    setState(() {});
  }

  String _getPhongBanName(int phongBanId) {
    return _phongBans.firstWhere((phongBan) => phongBan.id == phongBanId).tenPhongBan;
  }

  String _getChucVuName(int chucVuId) {
    return _chucVus.firstWhere((chucVu) => chucVu.id == chucVuId).tenChucVu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(title: Text('Danh sách Nhân Viên', style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Colors.green.shade500,
      ),
      body: PaginatedDataTable(
                      rowsPerPage: 8,
                      columns: [
                        DataColumn(label: Text('Mã NV')),
                        DataColumn(label: Text('Họ và Tên')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Ngày Sinh')),
                        DataColumn(label: Text('Ngày Vào Làm')),
                        DataColumn(label: Text('Phòng Ban')),
                        DataColumn(label: Text('Chức Vụ')),
                        DataColumn(label: Text('Giới Tính')),
                        DataColumn(label: Text('Sửa')),
                      ],
                      source: NhanVienDataSource(
                        _nhanViens, 
                        _getPhongBanName, 
                        _getChucVuName,
                        context // Truyền context vào DataSource
                      ),
                    ),
              
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NhanVienForm()),
          );
          if (result != null) {
            await _loadData();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Thêm Nhân Viên',
      ),
    );
  }
}

class NhanVienDataSource extends DataTableSource {
  final List<NhanVien> _nhanViens;
  final String Function(int) _getPhongBanName;
  final String Function(int) _getChucVuName;
  final BuildContext context;

  NhanVienDataSource(
    this._nhanViens, 
    this._getPhongBanName, 
    this._getChucVuName, 
    this.context
  );

  void addNhanVien(NhanVien nhanVien) {
    _nhanViens.add(nhanVien);
    notifyListeners(); // Cập nhật bảng
  }

  @override
  DataRow getRow(int index) {
    final nhanVien = _nhanViens[index];
    return DataRow(
      color: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return index.isEven ? Colors.white : Colors.green.shade100; // Nền trắng và xanh lá xen kẽ
      }),
      cells: [
        DataCell(Text(nhanVien.nhanVienID)),
        DataCell(Text(nhanVien.hoTen)),
        DataCell(Text(nhanVien.email)),
        DataCell(Text(DateFormat('dd/MM/yyyy').format(nhanVien.ngaySinh))),
        DataCell(Text(DateFormat('dd/MM/yyyy').format(nhanVien.ngayVaoLam))),
        DataCell(Text(_getPhongBanName(nhanVien.phongBanId))),
        DataCell(Text(_getChucVuName(nhanVien.chucVuId))),
        DataCell(Text(nhanVien.gioiTinh ?? '')),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NhanVienForm(nhanVien: nhanVien),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Xác nhận xóa"),
                      content: Text("Bạn có chắc chắn muốn xóa nhân viên này không?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Xóa"),
                        ),
                      ],
                    );
                  },
                );
                if (confirm) {
                  try {
                    await NhanVienController().deleteNhanVien(nhanVien.id);
                    _nhanViens.removeAt(index);
                    notifyListeners();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Xóa nhân viên thất bại: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  int get rowCount => _nhanViens.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
