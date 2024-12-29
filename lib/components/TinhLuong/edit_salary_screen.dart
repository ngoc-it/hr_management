import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_model.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_service.dart';
import 'package:flutter_application_1/models/phat_model.dart';
import 'package:flutter_application_1/models/thuong_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../models/hopdong_model.dart';
class EditSalaryScreen extends StatefulWidget {
  final  tinhLuong;

  EditSalaryScreen({Key? key,this.tinhLuong} ) : super(key: key);

  @override
  _EditSalaryScreenState createState() => _EditSalaryScreenState();
}

class _EditSalaryScreenState extends State<EditSalaryScreen> {
  final TinhLuongService _service = TinhLuongService();
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  List<NhanVien> nhanViens = [];
  List<Thuong> thuongs = [];
  List<Phat> phats = [];
  int? selectedEmployee;
  List<String> selectedBonuses = [];
  List<String> selectedPenalties = [];
  TextEditingController salaryNameController = TextEditingController();
  double? salary; // Basic salary
  double? soNgayCong; // Total days worked (from attendance data)
  TextEditingController soNgayNghiCoPhepController = TextEditingController();
  TextEditingController soNgayNghiKhongPhepController = TextEditingController();
  DateTime? selectedThangNam; // Selected month-year for salary calculation
  double? soNgayNghiCoPhep;
  double? soNgayNghiKhongPhep;
  double? luongThucNhan; // Actual salary
  int? hopDongId;
  double? soNgayCongThucTe; // Actual days worked from the system


 @override
  void initState() {
    super.initState();
    fetchData();
    // Đồng bộ giá trị controller với biến
  soNgayNghiCoPhepController.addListener(() {
    soNgayNghiCoPhep = double.tryParse(soNgayNghiCoPhepController.text) ?? 0.0;
  });

  soNgayNghiKhongPhepController.addListener(() {
    soNgayNghiKhongPhep = double.tryParse(soNgayNghiKhongPhepController.text) ?? 0.0;
  });
    if (widget.tinhLuong != null) {
      salaryNameController.text = widget.tinhLuong?.tenTinhLuong?? '';
      selectedEmployee = widget.tinhLuong?.nhanVienId ?? 0;
      id = widget.tinhLuong?.id ?? 0;
      // selectedBonuses = List<String>.from(widget.tinhLuong?.thuongIds ?? []);
      selectedBonuses = List<String>.from(
  (widget.tinhLuong?.thuongIds ?? <dynamic>[])
      .map((item) => item.toString())
);

      // selectedPenalties = List<String>.from(widget.tinhLuong?.phatIds ?? []);
      selectedPenalties = List<String>.from(
  (widget.tinhLuong?.phatIds ?? <dynamic>[])
      .map((item) => item.toString())
);

      soNgayNghiCoPhepController.text = widget.tinhLuong?.soNgayNghiCoPhep?.toString() ?? '0';
      soNgayNghiKhongPhepController.text = widget.tinhLuong?.soNgayNghiKhongPhep?.toString() ?? '0';
selectedThangNam = widget.tinhLuong?.thangNam != null
    ? widget.tinhLuong!.thangNam is String
        ? DateTime.parse(widget.tinhLuong!.thangNam)
        : widget.tinhLuong!.thangNam // Nếu đã là DateTime
    : DateTime.now();

      hopDongId = widget.tinhLuong?.hopDongId ?? 0;
      soNgayCong = widget.tinhLuong?.soNgayCong ?? 0.0;
      soNgayCongThucTe = widget.tinhLuong?.soNgayCongThucTe ?? 0.0;
    } else {
      salary = 0.0;
      soNgayCong = 0.0;
      luongThucNhan = 0.0;
      soNgayCongThucTe = 0.0;
    }
  }


  void fetchData() async {
    try {
      nhanViens = await TinhLuongService.fetchNhanVien();
      thuongs = await _service.fetchBonuses();
      phats = await TinhLuongService.fetchPenalties();
      if (selectedEmployee != null) {
        HopDong? hopDong = await _service.fetchHopDongByNhanVienId(selectedEmployee!);
        if (hopDong != null) {
          setState(() {
            salary = hopDong.luongCoBan;
            hopDongId = hopDong.id;
          });
        }
        fetchSoNgayCong();
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
  void fetchSoNgayCong() async {
  if (selectedEmployee != null) {
    try {
      double? result = await TinhLuongService.fetchSoNgayCong(selectedEmployee!);
      print('API returned soNgayCongThucTe: $result');
      setState(() {
        soNgayCongThucTe = result ?? 0.0;
      });
      print('Updated soNgayCongThucTe: $soNgayCongThucTe');
    } catch (e) {
      print('Error fetching soNgayCongThucTe: $e');
      setState(() {
        soNgayCongThucTe = soNgayCong ?? 0.0;
      });
    }
  }
}


double calculateSalary(
  double basicSalary,
  double daysWorked,
  double daysOffWithPermission,
  double daysOffWithoutPermission,
  List<Thuong> bonuses,
  List<Phat> penalties,
  double soNgayCongThucTe,
) {
  double dailySalary = basicSalary / 22; // Assuming 22 working days in a month
  double salaryForWorkedDays = dailySalary * (soNgayCongThucTe + daysOffWithPermission);
  double totalBonuses = bonuses.fold(0, (sum, bonus) => sum + bonus.soTienThuong);
  double totalPenalties = penalties.fold(0, (sum, penalty) => sum + penalty.soTien);

  return salaryForWorkedDays + totalBonuses - totalPenalties;
}


  void calculateSalaryAndUpdate() {
    checkForNullValues();

    if (salary != null && soNgayCongThucTe != null) {
      double finalSalary = calculateSalary(
        salary!,
        soNgayCong!, 
        soNgayNghiCoPhep ?? 0.0,
        soNgayNghiKhongPhep ?? 0.0,
        thuongs.where((bonus) => selectedBonuses.contains(bonus.id.toString())).toList(),
        phats.where((penalty) => selectedPenalties.contains(penalty.id.toString())).toList(),
        soNgayCongThucTe!,
      );
      setState(() {
        luongThucNhan = finalSalary; // Update actual salary
      });
    }
  }

Future<bool> checkTinhLuongForMonth(int nhanVienId, DateTime thangNam) async {
  try {
    var response = await _service.checkTinhLuongForMonth(nhanVienId, thangNam);
    
    // Directly return the response if it's a boolean
    if (response is bool) {
      return response;
    } else {
      throw Exception("Dữ liệu trả về không phải boolean");
    }
  } catch (e) {
    // Handle error and show message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    return false;
  }
}





 void saveSalary() async {
    checkForNullValues();
    if (!_formKey.currentState!.validate()) return;
  // Kiểm tra xem nhân viên đã được chấm công cho tháng này chưa
  
  // Kiểm tra xem nhân viên đã được chấm công cho tháng này chưa
  bool hasAttendance = false;
  if (widget.tinhLuong == null) {
    // Only check if it's a new salary record
    hasAttendance = await checkTinhLuongForMonth(selectedEmployee!, selectedThangNam!);
  }

  if (hasAttendance) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nhân viên đã chấm công trong tháng này!')));
    return;
  }
    final salaryData = {
      'id': id,
      'tenTinhLuong': salaryNameController.text,
      'nhanVienId': selectedEmployee ?? 0,
      'thuongIds': selectedBonuses.isNotEmpty ? selectedBonuses : [],
      'phatIds': selectedPenalties.isNotEmpty ? selectedPenalties : [],
       'soNgayNghiCoPhep': soNgayNghiCoPhep ?? double.tryParse(soNgayNghiCoPhepController.text) ?? 0.0,
    'soNgayNghiKhongPhep': soNgayNghiKhongPhep ?? double.tryParse(soNgayNghiKhongPhepController.text) ?? 0.0,
      'thangNam': selectedThangNam?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'luongCoBan': salary ?? 0.0,
      'luongThucNhan': luongThucNhan ?? 0.0,
      'soNgayCong': soNgayCong ?? 0.0,
      'hopDongId': hopDongId ?? 0,
      'soNgayCongThucTe': soNgayCongThucTe ?? 0.0,
    };

    try {
      if (widget.tinhLuong == null) {
        await _service.createTinhLuong(TinhLuong.fromJson(salaryData));
      } else {
        await _service.updateTinhLuong(widget.tinhLuong!.id, TinhLuong.fromJson(salaryData));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
 void checkForNullValues() {
    final fields = {
      'id': id,
      'selectedEmployee': selectedEmployee,
      'salary': salary,
      'soNgayCong': soNgayCong,
      'soNgayNghiCoPhep': soNgayNghiCoPhep,
      'soNgayNghiKhongPhep': soNgayNghiKhongPhep,
      'luongThucNhan': luongThucNhan,
      'soNgayCongThucTe':soNgayCongThucTe
    };

    fields.forEach((key, value) {
      if (value == null) {
        print("Warning: $key is null.");
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tinhLuong == null ? 'Thêm tính lương' : 'Sửa tính lương'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
         child: SingleChildScrollView( 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: salaryNameController,
                decoration: InputDecoration(labelText: 'Tên bảng lương'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                   return 'Tên bảng lương không thể trống';
            }
                    return null;
          },

              ),
              DropdownButtonFormField<int>(
  value: selectedEmployee != 0 ? selectedEmployee : null,
  items: nhanViens
      .map((e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(e.hoTen),
          ))
      .toList(),
  onChanged: (value) {
    setState(() {
      selectedEmployee = value ?? 0; // Giá trị mặc định nếu null
      fetchData();
      fetchSoNgayCong();
    calculateSalaryAndUpdate();
    });
  },
  decoration: InputDecoration(labelText: 'Nhân viên'),
),

              // Hiển thị lương cơ bản
              if (salary != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Lương cơ bản: ${salary.toString()}'),
                ),
                 // Hiển thị số ngày công
              if (soNgayCong != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Số ngày công thực tế: ${soNgayCongThucTe.toString()}'),
                  
                ),
              MultiSelectDialogField(
  items: thuongs.map((bonus) => MultiSelectItem(bonus.id, bonus.tenTienThuong)).toList(),
  title: Text("Thưởng"),
  selectedColor: Colors.blue,
  decoration: BoxDecoration(
    color: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: Colors.blue, width: 2),
  ),
  initialValue: selectedBonuses.where((s) => int.tryParse(s) != null).map(int.parse).toList(),


  onConfirm: (values) {
    setState(() {
      selectedBonuses = values.map((e) => e.toString()).toList(); // Chuyển ngược lại thành String
    });
     calculateSalaryAndUpdate(); // Tính toán lại lương thực nhận
  },
),
MultiSelectDialogField(
  items: phats.map((penalty) => MultiSelectItem(penalty.id, penalty.tenPhat)).toList(),
  title: Text("Phạt"),
  selectedColor: Colors.red,
  decoration: BoxDecoration(
    color: Colors.red.withOpacity(0.1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: Colors.red, width: 2),
  ),
  initialValue: selectedPenalties.where((s) => int.tryParse(s) != null).map(int.parse).toList(),
  onConfirm: (values) {
    setState(() {
      selectedPenalties = values.map((e) => e.toString()).toList(); // Chuyển ngược lại thành String
    });
    calculateSalaryAndUpdate();
  },
),
TextFormField(
  controller: soNgayNghiCoPhepController,
  decoration: InputDecoration(labelText: 'Số ngày nghỉ có phép'),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Trường này không được bỏ trống';
    }
    if (double.tryParse(value) == null) {
      return 'Vui lòng nhập số hợp lệ';
    }
    return null;
  },
  onChanged: (value) {
    // setState(() {
    //   soNgayNghiCoPhep = double.tryParse(value) ?? 0.0;
    // });
    calculateSalaryAndUpdate(); // Recalculate salary when days change
  },
),

TextFormField(
  controller: soNgayNghiKhongPhepController,
  decoration: InputDecoration(labelText: 'Số ngày nghỉ không phép'),
  keyboardType: TextInputType.numberWithOptions(decimal: true), // Cho phép nhập số lẻ
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Trường này không được bỏ trống';
    }
    if (double.tryParse(value) == null) {
      return 'Vui lòng nhập số hợp lệ';
    }
    return null;
  },
  onChanged: (value) {
    // setState(() {
    //   soNgayNghiKhongPhep = double.tryParse(value) ?? 0.0;
    // });
    calculateSalaryAndUpdate();
  },
  
),
 if (luongThucNhan != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Lương thực nhận: ${luongThucNhan?.toStringAsFixed(2)}'),
                ),
                ListTile(
                title: Text(
                    'Ngày tính lương: ${selectedThangNam != null ? selectedThangNam!.toLocal().toString().split(' ')[0] : 'Chọn ngày'}'),
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
                      selectedThangNam = pickedDate;
                    });
                  }
                },
              ),
              ElevatedButton(
  onPressed: () {
    calculateSalaryAndUpdate(); // Gọi hàm tính toán lương
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã tính lại lương thực nhận!')),
    );
  },
  child: Text('Tính Lương'),
),


              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveSalary,
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
