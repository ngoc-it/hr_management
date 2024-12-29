import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_model.dart';

class SalaryDetailScreen extends StatelessWidget {
  final TinhLuong tinhLuong;

  const SalaryDetailScreen({Key? key, required this.tinhLuong}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ${tinhLuong.tenTinhLuong}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên lương: ${tinhLuong.tenTinhLuong}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Lương thực nhận: ${tinhLuong.luongThucNhan.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Tháng năm: ${tinhLuong.thangNam.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Nhân viên ID: ${tinhLuong.nhanVienId}', style: TextStyle(fontSize: 16)),
            Text('Hợp đồng ID: ${tinhLuong.hopDongId}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Thưởng: ${tinhLuong.thuongIds.join(", ")}', style: TextStyle(fontSize: 16)),
            Text('Phạt: ${tinhLuong.phatIds.join(", ")}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Số ngày công: ${tinhLuong.soNgayCong}', style: TextStyle(fontSize: 16)),
            Text('Số ngày nghỉ có phép: ${tinhLuong.soNgayNghiCoPhep}', style: TextStyle(fontSize: 16)),
            Text('Số ngày nghỉ không phép: ${tinhLuong.soNgayNghiKhongPhep}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
