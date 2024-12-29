import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_model.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_service.dart';
import 'package:flutter_application_1/components/TinhLuong/edit_salary_screen.dart';
import 'package:flutter_application_1/components/TinhLuong/salary_detail_screen.dart';

class TinhLuongScreen extends StatefulWidget {
  @override
  _TinhLuongScreenState createState() => _TinhLuongScreenState();
}

class _TinhLuongScreenState extends State<TinhLuongScreen> {
  final TinhLuongService _service = TinhLuongService();
  late Future<List<TinhLuong>> _tinhLuongs;
  List<TinhLuong> _filteredTinhLuongs = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tinhLuongs = _service.getAllTinhLuongs();
    _searchController.addListener(_filterTinhLuong);
  }

  // Lọc danh sách lương theo tên lương
  void _filterTinhLuong() {
    setState(() {
      _filteredTinhLuongs = _searchController.text.isEmpty
          ? []
          : _filteredTinhLuongs
              .where((tinhLuong) => tinhLuong.tenTinhLuong
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
    });
  }

  // Hàm làm mới dữ liệu
  void _refreshData() {
    setState(() {
      _tinhLuongs = _service.getAllTinhLuongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tính lương'),
        backgroundColor: Colors.redAccent,
        actions: [
          // Thêm ô tìm kiếm
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SalarySearchDelegate(),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.red[100],
      body: FutureBuilder<List<TinhLuong>>(
        future: _tinhLuongs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu lương.'));
          } else {
            final tinhLuongs = snapshot.data!;
            return ListView.builder(
              itemCount: tinhLuongs.length,
              itemBuilder: (context, index) {
                final tinhLuong = tinhLuongs[index];
                return Card(
                  elevation: 8, // Tăng độ sáng tối của shadow để tạo hiệu ứng 3D
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                        tinhLuong.tenTinhLuong,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nhân viên ID: ${tinhLuong.nhanVienId}'),
                          Text('Lương thực nhận: ${tinhLuong.luongThucNhan.toStringAsFixed(2)}'),
                          Text('Tháng năm: ${tinhLuong.thangNam}'),
                        ],
                      ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SalaryDetailScreen(tinhLuong: tinhLuong),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditSalaryScreen(tinhLuong: tinhLuong),
                            ),
                          ).then((_) => _refreshData());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool? confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Xóa lương'),
                              content: Text('Bạn có chắc chắn muốn xóa không?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                          if (confirmDelete == true) {
                            await _service.deleteTinhLuong(tinhLuong.id);
                            _refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditSalaryScreen()),
        ).then((_) => _refreshData()),
        child: Icon(Icons.add),
      ),
    );
  }
}

// Tìm kiếm theo nhân viên
class SalarySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<TinhLuong>>(
      future: TinhLuongService().getAllTinhLuongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có dữ liệu.'));
        } else {
          final tinhLuongs = snapshot.data!.where((tinhLuong) {
            return tinhLuong.tenTinhLuong
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
          return ListView.builder(
            itemCount: tinhLuongs.length,
            itemBuilder: (context, index) {
              final tinhLuong = tinhLuongs[index];
              return ListTile(
                title: Text(tinhLuong.tenTinhLuong),
                subtitle: Text(
                    'Lương thực nhận: ${tinhLuong.luongThucNhan.toStringAsFixed(2)}'),
              );
            },
          );
        }
      },
    );
  }
}
