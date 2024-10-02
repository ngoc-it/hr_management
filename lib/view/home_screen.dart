import 'dart:async'; // Import thư viện để sử dụng Timer
import "package:flutter/material.dart";
import 'package:flutter_application_1/view/ChamCong/timekeeping_creen.dart';
import 'package:flutter_application_1/view/TinhLuong/salary_calculation_screen.dart';
import 'package:flutter_application_1/view/XepCa/xepca_nhanvien.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/NhanSu/hr_screen_home.dart';
import 'package:flutter_application_1/view/worker_details_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_application_1/view/PhanCong/Assignment_screen.dart';
import 'package:intl/intl.dart'; // Import thư viện để định dạng ngày

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
  DateTime today = DateTime.now();
  late List<Map<String, String>> days;

  String currentTime = ''; // Biến lưu trữ giờ hiện tại
  Timer? timer; // Khai báo Timer

  @override
  void initState() {
    super.initState();
    days = getDaysOfWeek();
    updateTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  }

  // Tạo danh sách chứa các ngày trong tuần, bắt đầu từ ngày hôm nay
  List<Map<String, String>> getDaysOfWeek() {
    List<Map<String, String>> days = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = today.add(Duration(days: i));
      String day = weekDays[date.weekday % 7]; // Lấy tên ngày trong tuần
      days.add({'day': day, 'date': DateFormat('dd').format(date)});
    }
    return days;
  }

  // Hàm cập nhật giờ hiện tại
  void updateTime() {
    setState(() {
      currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Hủy Timer khi không cần thiết
    super.dispose();
  }

  int selectedIndex = 0; // Biến lưu trữ ngày được chọn, mặc định là ngày hôm nay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hôm nay",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent,
                          image: DecorationImage(
                            image: AssetImage("assets/user1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Lịch làm việc",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Hiển thị danh sách lịch làm việc
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(days.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Cập nhật ngày được chọn
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.green
                                : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              days[index]['day']!,
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              days[index]['date']!,
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  userWorkedWith(
                    "Vào ca",
                    "assets/user1.jpg",
                    const Color.fromARGB(255, 44, 9, 147),
                    currentTime, // Hiển thị giờ hiện tại
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Chức năng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
             GridView.count(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  padding: EdgeInsets.symmetric(horizontal: 20),
  crossAxisCount: 2,
  childAspectRatio: 1,
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  children: [
    departmentCard(
      "Nhân sự",
      Colors.blueAccent,
      "🧑‍💼", // Icon cho nhân sự
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HRScreenHome()),
        );
      },
    ),
    departmentCard(
      "Chấm công",
      Colors.greenAccent,
      "🕒", // Icon cho chấm công
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TimekeepingScreen()),
        );
      },
    ),
    departmentCard(
      "Xếp ca",
      Colors.orangeAccent,
      "📅", // Icon cho xếp ca
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const XepCaNhanVienScreen()),
        );
      },
    ),
    departmentCard(
      "Tính lương",
      Colors.redAccent,
      "💰", // Icon cho tính lương
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SalaryCalculationScreen()),
        );
      },
    ),
    departmentCard(
      "Phân công",
      Colors.pinkAccent,
      "📝", // Icon cho phân công
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AssignWorkPage()),
        );
      },
    ),
    departmentCard(
      "Tiến độ dự án",
      Colors.yellowAccent,
      "📈", // Icon cho tiến độ dự án
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HRScreenHome()),
        );
      },
    ),
  ],
),


            ],
          ),
        ),
      ),
    );
  }

 Widget userWorkedWith(
  String name, String image, Color color, String jobTitle) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShiftSelectionScreen(), // Chuyển hướng tới WorkerDetailsScreen
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueAccent,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              jobTitle,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            trailing: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Icon(Ionicons.chevron_forward),
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget departmentCard(String name, Color color, String emoji, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20), // Tăng padding để có khoảng trống
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều ngang
            children: [
              Container(
                height: 50, // Tăng kích thước chiều cao
                width: 50,  // Tăng kích thước chiều rộng
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 40), // Tăng kích thước biểu tượng
                  ),
                ),
              ),
              SizedBox(height: 10), // Tăng khoảng cách giữa biểu tượng và tên
              Text(
                name,
                style: TextStyle(
                  fontSize: 20, // Tăng kích thước chữ
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Căn giữa tên
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
