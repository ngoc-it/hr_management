import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CongViec/Task.dart';
import 'package:flutter_application_1/components/CongViec/listCongViec.dart';
import 'package:flutter_application_1/components/DanhGia/evaluate_screen.dart';
import 'package:flutter_application_1/components/DanhGia/list_danhgia.dart';
import 'package:flutter_application_1/components/HopDong/hopdong_screen.dart';
import 'package:flutter_application_1/components/LichSuChamCong/list_chamcong.dart';
import 'package:flutter_application_1/components/Nhansu/add_human_resources.dart';
import 'package:flutter_application_1/components/PhanCong/Assignment_screen.dart';
import 'package:flutter_application_1/components/PhanCong/Giaodien.dart';
import 'package:flutter_application_1/components/Phongban/create_department.dart';
import 'package:flutter_application_1/components/Taikhoan/account_page.dart';
import 'package:flutter_application_1/components/TinhLuong/tinh_luong_screen.dart';
import 'package:flutter_application_1/view/view_screen.dart';
import 'package:flutter_application_1/components/account_page.dart';
import 'package:flutter_application_1/components/calendar_page.dart';
import 'package:flutter_application_1/components/NhanSu/human_resources.dart';
import 'package:flutter_application_1/components/recruit_page.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
// Kiểm tra kết nối mạng
Future<bool> isConnected() async {
  try {
    final result = await http.get(Uri.parse('https://www.google.com'));
    return result.statusCode == 200;
  } catch (e) {
    return false;
  }
}
// Fetch token using the stored cookie and save the token for future use
// Hàm lấy token
Future<String?> fetchToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token != null) {
    return token; // Sử dụng token đã lưu
  }

  // Lấy token mới (thay bằng API đăng nhập nếu có)
  final response = await http.post(
    Uri.parse('http://192.168.239.219:5000/api/LoginLogout/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'tenDangNhap': 'tenDangNhap', // Dữ liệu đăng nhập thực tế
      'matKhau': 'matKhau'
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    token = data['token'];
    await prefs.setString('auth_token', token!);
    return token;
  } else {
    throw Exception('Failed to fetch token');
  }
}

// Hàm lấy thông tin người dùng
Future<Map<String, String>> fetchUserInfo() async {
  if (!await isConnected()) {
    throw Exception('Không có kết nối internet');
  }

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('Token not found');
  }

  try {
    final response = await http.get(
      Uri.parse('http://192.168.239.219:5000/api/LoginLogout/getCurrentUserInfo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'hoTen': data['hoTen'] ?? 'Họ tên không xác định',
        'chucVu': data['chucVu'] ?? 'Chức vụ không xác định',
      };
    } else {
      throw Exception('Failed to fetch user info');
    }
  } catch (e) {
    throw Exception('Lỗi kết nối mạng: $e');
  }
}
class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}
class _NavbarState extends State<Navbar> {
  late Future<Map<String, String>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(); // Lấy thông tin người dùng khi widget được tạo
  }
  // Hàm điều hướng chung để tránh lặp lại mã
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, String>>(
            future: _userInfoFuture, // Sử dụng dữ liệu đã lấy từ initState
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: Text("Đang tải..."),
                  accountEmail: Text("Đang tải..."),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user1.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return UserAccountsDrawerHeader(
                  accountName: Text("Lỗi"),
                  accountEmail: Text("Không thể tải thông tin người dùng"),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user1.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return UserAccountsDrawerHeader(
                  accountName: Text(user['hoTen'] ?? 'Tên không xác định'),
                  accountEmail: Text(user['chucVu'] ?? 'Chức vụ không xác định'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user1.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
                  accountName: Text("Không rõ"),
                  accountEmail: Text("Dữ liệu không tồn tại"),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user1.jpg",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            },
          ),


          ListTile(
            leading: Icon(Icons.home),
            title: Text("Trang chủ"),
            onTap: () => _navigateToScreen(context, HomeScreen()),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text("Lịch"),
            onTap: () => _navigateToScreen(context, CalendarPage()),
          ),
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text("Công Việc"),
            onTap: () => _navigateToScreen(context, CongViecListScreen()),  // Điều hướng đến CongViecListScreen
          ),
          
          ListTile(
            leading: Icon(Icons.feed_rounded),
            title: Text("Phân công"),
            onTap: () => _navigateToScreen(context,PhanCongPage()),  // Điều hướng đến CongViecListScreen
          ),
         
          //           ListTile(
          //   leading: Icon(Icons.note_alt_rounded),
          //   title: Text("Hợp đồng"),
          //   onTap: () => _navigateToScreen(context,HopDongPage()),  // Điều hướng đến CongViecListScreen
          // ),
          FutureBuilder<Map<String, String>>(
  future: _userInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ListTile(
        leading: Icon(Icons.account_circle),
        title: Text("Hợp đồng"),
        subtitle: Text("Lỗi khi tải dữ liệu"),
      );
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      if (user['chucVu'] == 'Admin' || user['chucVu'] == 'Giám đốc') {
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.note_alt_rounded),
              title: Text("Hợp đồng"),
              onTap: () => _navigateToScreen(context, HopDongPage()),  // Điều hướng đến trang hợp đồng
            ),
          ],
        );
      } else {
        return Container(); // Không hiển thị nếu không phải Admin hoặc Giám đốc
      }
    } else {
      return Container(); // Nếu không có dữ liệu hoặc trạng thái không rõ
    }
  },
),

          ListTile(
            leading: Icon(Icons.fact_check),
            title: Text("Đánh Giá"),
            onTap: () => _navigateToScreen(context,DanhGiaPage()),  // Điều hướng đến CongViecListScreen
          ),
         
          // ListTile(
          //   leading: Icon(Icons.group_outlined),
          //   title: Text("Tài khoản"),
          //   onTap: () => _navigateToScreen(context, TaiKhoanPage()),
          // ),
          // Kiểm tra nếu người dùng là Admin mới cho vào trang Tài khoản
          FutureBuilder<Map<String, String>>(
  future: _userInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ListTile(
        leading: Icon(Icons.account_circle),
        title: Text("Tài khoản"),
        subtitle: Text("Lỗi khi tải dữ liệu"),
      );
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      if (user['chucVu'] == 'Admin') {
        return ListTile(
          leading: Icon(Icons.group_outlined),
          title: Text("Tài khoản"),
          onTap: () => _navigateToScreen(context, TaiKhoanPage()),
        );
      } else {
        return Container(); // Không hiển thị mục này nếu không phải Admin
      }
    } else {
      return Container(); // Nếu không có dữ liệu hoặc trạng thái không rõ
    }
  },
),
          
          FutureBuilder<Map<String, String>>(
  future: _userInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ListTile(
        leading: Icon(Icons.account_circle),
        title: Text("Nhân sự"),
        subtitle: Text("Lỗi khi tải dữ liệu"),
      );
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      if (user['chucVu'] == 'Admin' || user['chucVu'] == 'Giám đốc') {
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.hub_outlined),
              title: Text("Nhân sự"),
              onTap: () => _navigateToScreen(context, NhanVienTablePage()),
            ),
          ],
        );
      } else {
        return Container(); // Không hiển thị mục này nếu không phải Admin hoặc Giám đốc
      }
    } else {
      return Container(); // Nếu không có dữ liệu hoặc trạng thái không rõ
    }
  },
),

          FutureBuilder<Map<String, String>>(
  future: _userInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ListTile(
        leading: Icon(Icons.account_circle),
        title: Text("Phòng ban"),
        subtitle: Text("Lỗi khi tải dữ liệu"),
      );
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      if (user['chucVu'] == 'Admin') {
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.chair),
              title: Text("Phòng ban"),
              onTap: () => _navigateToScreen(context, PhongBanManager()),
            ),
          ],
        );
      } else {
        return Container(); // Không hiển thị mục này nếu không phải Admin
      }
    } else {
      return Container(); // Nếu không có dữ liệu hoặc trạng thái không rõ
    }
  },
),

         
          FutureBuilder<Map<String, String>>(
  future: _userInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ListTile(
        leading: Icon(Icons.receipt_long),
        title: Text("Tính lương"),
        subtitle: Text("Lỗi khi tải dữ liệu"),
      );
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      if (user['chucVu'] == 'Admin') {
        return ListTile(
          leading: Icon(Icons.group_outlined),
          title: Text("Tính lương"),
          onTap: () => _navigateToScreen(context, TinhLuongScreen()),
        );
      } else {
        return Container(); // Không hiển thị mục này nếu không phải Admin
      }
    } else {
      return Container(); // Nếu không có dữ liệu hoặc trạng thái không rõ
    }
  },
),
          // ListTile(
          //   leading: Icon(Icons.receipt_long),
          //   title: Text("Tính Lương"),
          //   onTap: () => _navigateToScreen(context,TinhLuongScreen()),
          // ),
          
                    ListTile(
            leading: Icon(Icons.fmd_good),
            title: Text("Chấm công"),
            onTap: () => _navigateToScreen(context,AttendanceListPage()),
          ),
          
          ListTile(
            leading: Icon(Icons.checklist_outlined),
            title: Text("Yêu cầu"),
            onTap: () => null,
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    "10",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
