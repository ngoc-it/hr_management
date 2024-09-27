import "package:flutter/material.dart";
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/worker_details_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                          "Buổi sáng",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Ngày 24/09/2024",
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
                          MaterialPageRoute(builder: (context) => LoginScreen()),
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
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  userWorkedWith(
                    "Vào ca",
                    "assets/user1.jpg",
                    const Color.fromARGB(255, 44, 9, 147),
                    "07:38",
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
              // Sử dụng GridView để hiển thị 2 card chức năng trên mỗi hàng
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                crossAxisCount: 2, // Hai cột
                childAspectRatio: 1, // Tỉ lệ chiều rộng và chiều cao
                mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                crossAxisSpacing: 10, // Khoảng cách giữa các cột
                children: [
                  departmentCard(
                    "Nhân sự",
                    2,
                    "Scrum Master",
                    Colors.blueAccent,
                    "📊",
                  ),
                  departmentCard(
                    "Chấm công",
                    5,
                    "Developer",
                    Colors.greenAccent,
                    "🖥️",
                  ),
                  departmentCard(
                    "Xếp ca",
                    2,
                    "Designer",
                    Colors.orangeAccent,
                    "🖌️",
                  ),
                  departmentCard(
                    "Tính lương",
                    3,
                    "Test Engineer",
                    Colors.redAccent,
                    "🔎",
                  ),
                  departmentCard(
                    "Phân công",
                    2,
                    "Accountant",
                    Colors.pinkAccent,
                    "💵",
                  ),
                  departmentCard(
                    "Tiến độ dự án",
                    2,
                    "Sales Manager",
                    Colors.yellowAccent,
                    "📦",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userWorkedWith(String name, String image, Color color, String jobTitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShiftSelectionScreen(),
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
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(
                    child: Icon(
                      FontAwesome5Regular.edit,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget departmentCard(String name, int number, String title, Color color, String emoji) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10), // Thêm khoảng cách dưới mỗi card
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 8), // Thay đổi khoảng cách giữa emoji và tên
              Text(
                name,
                style: TextStyle(
                  fontSize: 18, // Tăng kích thước chữ
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4), // Thay đổi khoảng cách giữa tên và tiêu đề
              Text(
                "$number $title",
                style: TextStyle(
                  fontSize: 16, // Tăng kích thước chữ
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
