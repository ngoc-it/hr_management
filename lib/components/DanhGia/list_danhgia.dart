import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'evaluate_screen.dart';  // Assuming this imports the necessary classes and services

class DanhGiaPage extends StatefulWidget {
  @override
  _DanhGiaPageState createState() => _DanhGiaPageState();
}

class _DanhGiaPageState extends State<DanhGiaPage> {
  late Future<List<DanhGia>> _danhGiaFuture;
  final DanhGiaService _danhGiaService = DanhGiaService();
  
  // Filter state variables
  String selectedDateFilter = 'Tất cả';
  String selectedScoreFilter = 'Tất cả';

  int countDay = 0;
  int countMonth = 0;
  int countYear = 0;
  int countBelow5 = 0;
  int countAbove5 = 0;

  @override
  void initState() {
    super.initState();
    _danhGiaFuture = _loadDanhGia();
  }

  Future<List<DanhGia>> _loadDanhGia() async {
    final phanCongs = await DropdownService.fetchPhanCong();
    final nhanViens = await DropdownService.fetchNhanVien();
    List<DanhGia> danhGias = await _danhGiaService.getDanhGiasWithNames(phanCongs, nhanViens);
  
    // Áp dụng bộ lọc ở đây
    _applyFilters(danhGias);

    return danhGias;  // Trả về danh sách đã lọc
  }

  void _applyFilters(List<DanhGia> danhGias) {
    DateTime now = DateTime.now();

    List<DanhGia> filteredByDate = danhGias;

    // Lọc theo ngày
    if (selectedDateFilter == 'Ngày') {
      filteredByDate = filteredByDate.where((danhGia) =>
          DateFormat('yyyy-MM-dd').format(danhGia.ngayDanhGia) == DateFormat('yyyy-MM-dd').format(now)).toList();
    } else if (selectedDateFilter == 'Tháng') {
      filteredByDate = filteredByDate.where((danhGia) =>
          DateFormat('yyyy-MM').format(danhGia.ngayDanhGia) == DateFormat('yyyy-MM').format(now)).toList();
    } else if (selectedDateFilter == 'Năm') {
      filteredByDate = filteredByDate.where((danhGia) =>
          DateFormat('yyyy').format(danhGia.ngayDanhGia) == DateFormat('yyyy').format(now)).toList();
    }

    List<DanhGia> filteredByScore = filteredByDate;

    // Lọc theo điểm
    if (selectedScoreFilter == 'Dưới 5.0') {
      filteredByScore = filteredByScore.where((danhGia) => danhGia.dienDanhGia < 5).toList();
    } else if (selectedScoreFilter == 'Từ 5.0 - 10.0') {
      filteredByScore = filteredByScore.where((danhGia) => danhGia.dienDanhGia >= 5).toList();
    }

    setState(() {
      // Cập nhật lại danh sách đã lọc
      _danhGiaFuture = Future.value(filteredByScore); // Cập nhật lại danh sách
      // Cập nhật các thống kê
      countDay = filteredByDate.length;
      countMonth = filteredByDate.where((danhGia) =>
          DateFormat('yyyy-MM').format(danhGia.ngayDanhGia) == DateFormat('yyyy-MM').format(now)).toList().length;
      countYear = filteredByDate.where((danhGia) =>
          DateFormat('yyyy').format(danhGia.ngayDanhGia) == DateFormat('yyyy').format(now)).toList().length;
      countBelow5 = filteredByScore.where((danhGia) => danhGia.dienDanhGia < 5).toList().length;
      countAbove5 = filteredByScore.where((danhGia) => danhGia.dienDanhGia >= 5).toList().length;
    });
  }

  Future<void> _deleteDanhGia(int id) async {
    try {
      await _danhGiaService.deleteDanhGia(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa đánh giá thành công')),
      );
      setState(() {
        _danhGiaFuture = _loadDanhGia(); // Làm mới danh sách
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa đánh giá thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Đánh Giá'), backgroundColor: const Color(0xFF0277BD)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 89, 146, 246), const Color.fromARGB(255, 130, 209, 245)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Filter Section with better styling
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date filter dropdown with icon
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            value: selectedDateFilter,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDateFilter = newValue!;
                              });
                              _loadDanhGia();
                            },
                            items: ['Tất cả', 'Ngày', 'Tháng', 'Năm']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    Text(value, style: TextStyle(color: Colors.black)),
                                    SizedBox(width: 8),
                                    Text('(${countDay})', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      
                      // Score filter dropdown with icon
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            value: selectedScoreFilter,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedScoreFilter = newValue!;
                              });
                              _loadDanhGia();
                            },
                            items: ['Tất cả', 'Dưới 5.0', 'Từ 5.0 - 10.0']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    Text(value, style: TextStyle(color: Colors.black)),
                                    SizedBox(width: 8),
                                    Text(
                                      value == 'Dưới 5.0' ? '(${countBelow5})' : '(${countAbove5})',
                                      style: TextStyle(color: const Color.fromARGB(255, 251, 251, 251)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // List of evaluations
            Expanded(
              child: FutureBuilder<List<DanhGia>>(
                future: _danhGiaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Chưa có đánh giá nào'));
                  }

                  final danhGias = snapshot.data!;
                  return ListView.builder(
                    itemCount: danhGias.length,
                    itemBuilder: (context, index) {
                      final danhGia = danhGias[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text('Điểm: ${danhGia.dienDanhGia}', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Công việc: ${danhGia.tenCongViecPhanCong ?? 'Không rõ'}'),
                              Text('Người đánh giá: ${danhGia.hoTen ?? 'Không rõ'}'),
                              Text('Ghi chú: ${danhGia.ghiChu ?? 'Không có ghi chú'}'),
                              Text('Ngày đánh giá: ${DateFormat('dd/MM/yyyy').format(danhGia.ngayDanhGia)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditDanhGiaPage(danhGia: danhGia),
                                    ),
                                  );
                                  if (result == true) _loadDanhGia();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmation(danhGia.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 107, 24, 250),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditDanhGiaPage()),
          );
          if (result == true) _loadDanhGia();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa đánh giá này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _deleteDanhGia(id);
                Navigator.of(context).pop();
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
