import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CongViec/Task.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:intl/intl.dart';

class CongViecListScreen extends StatefulWidget {
  @override
  _CongViecListScreenState createState() => _CongViecListScreenState();
}

class _CongViecListScreenState extends State<CongViecListScreen> {
  final CongViecService service = CongViecService();
  late Future<List<CongViec>> futureCongViecs;
  List<NhanVien>? nhanViens;
  List<CongViec> filteredCongViecs = [];

  // Filters
  String selectedDateFilter = 'Tất cả';
  String selectedStatusFilter = 'Tất cả';

  int countAll = 0;
  int countDay = 0;
  int countMonth = 0;
  int countYear = 0;
  int countCompleted = 0;
  int countPending = 0;

  @override
  void initState() {
    super.initState();
    futureCongViecs = service.fetchCongViecs();
    NhanVienController().fetchNhanViens().then((value) {
      setState(() {
        nhanViens = value;
      });
    });
  }

  void _refreshList() {
    setState(() {
      futureCongViecs = service.fetchCongViecs();
    });
  }

  // Function to filter tasks and update counts
  void _applyFilters(List<CongViec> congViecs) {
    DateTime now = DateTime.now();

    // Filter by date
    List<CongViec> filteredByDate = congViecs;
    if (selectedDateFilter == 'Ngày') {
      filteredByDate = filteredByDate.where((congViec) => DateFormat('yyyy-MM-dd').format(congViec.ngayTao) == DateFormat('yyyy-MM-dd').format(now)).toList();
    } else if (selectedDateFilter == 'Tháng') {
      filteredByDate = filteredByDate.where((congViec) => DateFormat('yyyy-MM').format(congViec.ngayTao) == DateFormat('yyyy-MM').format(now)).toList();
    } else if (selectedDateFilter == 'Năm') {
      filteredByDate = filteredByDate.where((congViec) => DateFormat('yyyy').format(congViec.ngayTao) == DateFormat('yyyy').format(now)).toList();
    }

    // Filter by status
    List<CongViec> filteredByStatus = filteredByDate;
    if (selectedStatusFilter != 'Tất cả') {
      filteredByStatus = filteredByStatus.where((congViec) => congViec.trangThai == selectedStatusFilter).toList();
    }

    setState(() {
      filteredCongViecs = filteredByStatus;

      // Update the counts
      countAll = congViecs.length;
      countDay = filteredByDate.length;
      countMonth = filteredByDate.where((congViec) => DateFormat('yyyy-MM').format(congViec.ngayTao) == DateFormat('yyyy-MM').format(now)).toList().length;
      countYear = filteredByDate.where((congViec) => DateFormat('yyyy').format(congViec.ngayTao) == DateFormat('yyyy').format(now)).toList().length;
      countCompleted = filteredByStatus.where((congViec) => congViec.trangThai == 'Completed').toList().length;
      countPending = filteredByStatus.where((congViec) => congViec.trangThai == 'Pending').toList().length;
    });
  }

  void _deleteCongViec(int id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa công việc này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await service.deleteCongViec(id);
        _refreshList();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa công việc thành công')),
        );
      } catch (e) {
        print("Lỗi khi xóa công việc: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa công việc: $e')),
        );
      }
    }
  }

  void _addOrUpdateCongViec(CongViec? congViec) async {
    final result = await showDialog<CongViec>(
      context: context,
      builder: (context) => CongViecFormDialog(congViec: congViec),
    );
    if (result != null) {
      if (congViec == null) {
        await service.createCongViec(result);
      } else {
        await service.updateCongViec(congViec.id, result);
      }
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách công việc"), backgroundColor: const Color.fromARGB(255, 247, 71, 142)),
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 240, 161, 252), const Color.fromARGB(255, 255, 102, 209)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
       child:Column(
        children: [
          // Filters Section with Count Display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    _refreshList();
                  },
                  items: ['Tất cả', 'Ngày', 'Tháng', 'Năm']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value),
                          SizedBox(width: 8),
                          Text(
                            '(${countDay})',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                 ],
                      ),
                      Row(
                        children: [
                         
                          SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedStatusFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatusFilter = newValue!;
                    });
                    _refreshList();
                  },
                  items: ['Tất cả', 'Đã hoàn thành', 'Chưa hoàn thành']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value),
                          SizedBox(width: 8),
                          Text(
                            '(${value == 'Completed' ? countCompleted : value == 'Pending' ? countPending : countAll})',
                            style: TextStyle(color: Colors.grey),
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
          // Task List
          Expanded(
            child: FutureBuilder<List<CongViec>>(
              future: futureCongViecs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có công việc nào.'));
                } else {
                  // Apply filters after data is fetched
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _applyFilters(snapshot.data!);
                  });

                  return ListView.builder(
                    itemCount: filteredCongViecs.length,
                    itemBuilder: (context, index) {
                      final congViec = filteredCongViecs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(congViec.tenCongViec,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Người tạo: ${nhanViens?.firstWhere(
                                        (nhanVien) =>
                                            nhanVien.id == congViec.nguoiTaoId,
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
                                      ).hoTen}",
                                ),
                                Text("Trạng thái: ${congViec.trangThai}"),
                                Text(
                                    "Ngày tạo: ${DateFormat('yyyy-MM-dd').format(congViec.ngayTao)}"),
                                Text(
                                    "Ngày hoàn thành dự kiến: ${DateFormat('yyyy-MM-dd').format(congViec.ngayHoanThanhDuKien ?? DateTime.now())}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _addOrUpdateCongViec(congViec),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCongViec(congViec.id),
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
          ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 249, 52, 131),
        onPressed: () => _addOrUpdateCongViec(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
