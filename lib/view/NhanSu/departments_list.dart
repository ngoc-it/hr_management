import 'package:flutter/material.dart';

class DepartmentsList extends StatelessWidget {
  final List<String> departments = [
    'Phòng Kỹ Thuật',
    'Phòng Nhân Sự',
    'Phòng Kế Toán',
    'Phòng Marketing'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng ban'),
        backgroundColor: Colors.blueAccent,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       // Điều hướng đến trang thêm phòng ban
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => AddDepartmentScreen()),
        //       );
        //     },
        //   )
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Hai cột
            mainAxisSpacing: 16, // Khoảng cách giữa các hàng
            crossAxisSpacing: 16, // Khoảng cách giữa các cột
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Điều hướng đến trang chi tiết phòng ban
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepartmentDetailScreen(
                      department: departments[index],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apartment, size: 50, color: Colors.blue), // Thay đổi biểu tượng nếu cần
                      const SizedBox(height: 16),
                      Text(
                        departments[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// class AddDepartmentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Thêm phòng ban')),
//       body: Center(child: const Text('Form thêm phòng ban sẽ được đặt ở đây')),
//     );
//   }
// }

class DepartmentDetailScreen extends StatelessWidget {
  final String department;

  DepartmentDetailScreen({required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết $department')),
      body: Center(child: Text('Thông tin chi tiết về $department')),
    );
  }
}
