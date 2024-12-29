import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Hàm giải mã và lưu NhanVienID
// Hàm giải mã và lưu NhanVienID dưới dạng int
Future<void> saveNhanVienID(String token) async {
  try {
    // Tách token thành 3 phần (header, payload, signature)
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Token không hợp lệ');

    // Giải mã phần payload (phần giữa của token)
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = json.decode(payload); // Giải mã từ chuỗi JSON

    // Trích xuất NhanVienID từ payload và chuyển đổi sang int
    final nhanVienID = int.parse(data['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'].toString());

    // Lưu NhanVienID dưới dạng int vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('NhanVienID', nhanVienID);
    print("NhanVienID đã lưu: $nhanVienID");

  } catch (e) {
    print('Lỗi khi giải mã token và lưu NhanVienID: $e');
  }
}
Future<void> saveUserRole(String token) async {
  try {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Token không hợp lệ');

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = json.decode(payload);

    // Trích xuất role từ payload
    final role = data['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserRole', role); // Lưu role vào SharedPreferences
    print("Role đã lưu: $role");
  } catch (e) {
    print('Lỗi khi giải mã token và lưu role: $e');
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController tenDangNhapController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  bool _isLoading = false;

 Future<void> _login(String tenDangNhap, String matKhau, BuildContext context) async {
  setState(() {
    _isLoading = true;
  });

  final url = Uri.parse('http://192.168.239.219:5000/api/LoginLogout/login'); 

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tenDangNhap': tenDangNhap, // Sử dụng đúng trường yêu cầu từ server
        'matKhau': matKhau,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token']; // Trích xuất token từ phản hồi

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
         await saveNhanVienID(token);
         await saveUserRole(token);

        print('Token saved: $token');
        print('User role saved: $token');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công!')),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: Không nhận được token!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tài khoản hoặc mật khẩu không đúng!')),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xảy ra lỗi trong quá trình đăng nhập!')),
    );
  }
}



  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 13, 29, 209),
                Color.fromARGB(255, 4, 81, 236),
                Color.fromARGB(255, 9, 159, 228)
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 40)),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text("Chào mừng trở lại", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 60),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                  ),
                                  child: TextField(
                                    controller: tenDangNhapController,
                                    decoration: const InputDecoration(
                                      hintText: "Tên đăng nhập",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                  ),
                                  child: TextField(
                                    controller: matKhauController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Mật khẩu",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () {
                              _login(
                                tenDangNhapController.text,
                                matKhauController.text,
                                context,
                              ); // Gọi hàm login
                            },
                            height: 50,
                            color: const Color.fromARGB(255, 3, 81, 250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "ĐĂNG NHẬP",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}