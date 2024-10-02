import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/XepCa/xepca_quanly.dart';


class XepCaNhanVienScreen extends StatelessWidget {
  const XepCaNhanVienScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho danh sách ca làm việc
    final List<CaLamViec> caLamViecs = [
      CaLamViec(id: 1, ca: 'Hành chính', gioVao: '08:30', gioRa: '17:30'),
      CaLamViec(id: 2, ca: 'Tăng ca', gioVao: '18:00', gioRa: '22:00'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Ca Làm Việc'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: caLamViecs.length,
          itemBuilder: (context, index) {
            final caLamViec = caLamViecs[index];
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(caLamViec.ca),
                subtitle: Text('Giờ vào: ${caLamViec.gioVao}, Giờ ra: ${caLamViec.gioRa}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Chuyển đến trang quản lý xếp ca
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerShiftScreen(caLamViec: caLamViec),
                      ),
                    );
                  },
                  child: Text('Chọn'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Mẫu lớp CaLamViec
class CaLamViec {
  final int id;
  final String ca;
  final String gioVao;
  final String gioRa;

  CaLamViec({required this.id, required this.ca, required this.gioVao, required this.gioRa});
}
