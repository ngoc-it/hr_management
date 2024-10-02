import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/XepCa/xepca_nhanvien.dart';

class ManagerShiftScreen extends StatelessWidget {
  final CaLamViec caLamViec;

  const ManagerShiftScreen({Key? key, required this.caLamViec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Xếp Ca: ${caLamViec.ca}'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin ca làm việc',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ca: ${caLamViec.ca}', style: TextStyle(fontSize: 16)),
                    Text('Giờ vào: ${caLamViec.gioVao}', style: TextStyle(fontSize: 16)),
                    Text('Giờ ra: ${caLamViec.gioRa}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Thêm các thông tin khác cho quản lý xếp ca
            ElevatedButton(
              onPressed: () {
                // Xử lý sự kiện xếp ca
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Xếp Ca'),
            ),
          ],
        ),
      ),
    );
  }
}
