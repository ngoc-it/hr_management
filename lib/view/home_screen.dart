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
      body: SafeArea(                              //Đảm bảo ND hiển thị trong vùng an toàn ko bị che bởi các thành phần hệ thống vd: thanh diều hướng.
        child: SingleChildScrollView(              //Cho phép cuộn khi nội dung vượt quá màn hình (scroll), chứa 1 widget "phức tạp"
          child: Column(                           //Widget bố cục như một container, sắp xếp các widget con theo chiều dọc
            crossAxisAlignment:                    //Các WD con trong column có thể căn chỉnh theo trục Y
            CrossAxisAlignment.start,              //Căn chỉnh WD con bắt đầu từ phía trái màn hình
            children: [                            //Danh sách các WD con mà column hiển thị theo chiều dọc Y
              Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7), //Gói widget con bên trong padding cách đều trái phải(hor) 20px trên dưới(ver) 20px
              child: Row(                          //Giống column nhưng theo chiều ngang trục X
                mainAxisAlignment:                 //Tương tự phía trên nhưng là trong Row trục X
                MainAxisAlignment.spaceBetween,    //Các WD con đc sắp xếp căn đều, với các WD đầu tiên căn trái và WD cuối cùng căn phải
                children: [                        //Tương tự phía trên nhưng theo ngữ cảnh thì hiển thị theo trục X
                  
                  Column(                          //Ở đây ta sẽ tạo tiếp một WD Column bên trong Row
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Buổi sáng",
                        style: TextStyle(                     //Định dạng cho văn bản
                          fontSize: 18,
                          fontWeight: FontWeight.bold,        //In đậm
                        ),
                      ),
                      SizedBox(height: 5),                    //Tạo khoảng cách 5px theo chiều dọc
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
    // Xử lý sự kiện khi người dùng nhấn vào nút
    // Thay đổi trang sang trang đăng nhập ở đây
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Chuyển đến trang đăng nhập
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
              // SizedBox(height: 10),                            
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20), 
              //   child: SizedBox(                               //Quy định kích thước của widget
              //     height: 40,                                  //Ở đây có thể thấy chiều cao đc qđ là 50px
              //     child: TextField(                            //Tạo ô nhập liệu văn bản
              //       decoration: InputDecoration(               
              //         enabled: false,                          //Chặn không cho nhập
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(25),
              //           borderSide: BorderSide.none,            //Không vẽ đường viền cho ô nhập
              //         ),
              //         prefixIcon: Icon(Feather.search,          //Đặt biểu tượng kính lúp phía trc ô nhập
              //        color: Colors.black,size: 30,),  
              //        fillColor: const Color.fromARGB(255, 233, 233, 233),             //Đặt màu nền cho ô nhập
              //        filled: true,                              //Đảm bảo màu nền được hiển thị (true)
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),
             Padding(padding: EdgeInsets.symmetric(horizontal: 20),
             child: Text("Lịch làm việc",
             style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
             ),
             ),
             ),
             SizedBox(height: 10),
             ListView(
              shrinkWrap: true,                                           //Với thuộc tính này Listview sẽ chỉ chiếm ko gian vừa đủ để hiển thị tát cả các phần tử của nó
              physics: NeverScrollableScrollPhysics(),                    //Loại bỏ khả năng cuộn của listview, ko thể cuộn kể cả khi có nhiều phần tử hơn trong không gian có sẵn
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                userWorkedWith(
                  "Vào ca",
                  "assets/user1.jpg",
                  const Color.fromARGB(255, 44, 9, 147),
                  "07:38",
                ),
                // userWorkedWith(
                //   "Henry Jack",
                //   "assets/user3.jpg",
                //   Colors.grey,
                //   "Developer",
                // ),
                // userWorkedWith(
                //   "Harry Lu",
                //   "assets/user4.jpg",
                //   Colors.grey,
                //   "HR Specialist",
                // ),
              ],
             ),
              SizedBox(height: 20),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Chức năng",                           //Tạo widget nội dung
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
               ),
              ),
             ),
             SizedBox(height: 10),
             SizedBox(height: 125,
             child: ListView(
              scrollDirection: Axis.horizontal,                  //Chỉ định hướng cuộn các phần tử theo chiều ngang (X)
              children: [
                SizedBox(width: 20),                             //Tạo khoảng cách 20px theo chiều ngang
                departmentCard(                                  //Hàm chi tiết cho DS phòng ban
                  "Nhân sự",                                  //Tên phong ban
                  2,                                             //Số lượng nv phòng ban
                  "Scrum Master",                                //Chức danh cv chính trong phòng ban
                  Colors.blueAccent,                           //Màu sắc đại diện
                  "📊",                                          //Biểu tượng đại diện
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
              ],
             ),
             ),
             SizedBox(height: 10),
             SizedBox(height: 125,
             child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 20),
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
                departmentCard(
                  "Marketing", 
                  2, 
                  "Content Marketer", 
                  Colors.purpleAccent, 
                  "📢",
                ),
                departmentCard(
                  "HR", 
                  2, 
                  "HR Specialist", 
                  Colors.blueGrey, 
                  "📑",
                ),
              ],
             ),
             ),
            ],
          ),
        ),
      ),
    );
  }

Widget userWorkedWith(String name, String image, Color color, String jobTitle){       //Đinh nghĩa một hàm, truyền tham số 
  return Padding(padding: EdgeInsets.only(bottom: 10),
  child: InkWell(                                                                     //Widget tương tác, kích hoạt sự kiện khi được chạm vào
    onTap: (){                                                                        //Sự kiện onTap dduoc kích hoạt
      Navigator.push(                                                                //Điều hướng đến màn hình WorkerDetailsScreen. Sử dụng Navigator.push để chuyển sang trang mới
          context,  
          MaterialPageRoute(
          builder: (context) => ShiftSelectionScreen(
        ),
      ),);
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
          title: Text(name, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
        subtitle: Text(jobTitle, style: TextStyle(
          color: Colors.black54,
        )),
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

  Widget departmentCard(String name, int number, String title, Color color, String emoji){
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        width: 150,
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
                  child: Text(emoji,
                  style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                name, 
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                number.toString() + " " + title, 
                style: TextStyle(
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