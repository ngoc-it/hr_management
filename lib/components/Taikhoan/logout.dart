import 'package:http/http.dart' as http;

Future<void> logoutFromServer() async {
  final response = await http.post(
    Uri.parse('https://yourapi.com/logout'),
    headers: {
      'Authorization': 'Bearer your_token', // Token của người dùng
    },
  );

  if (response.statusCode == 200) {
    print("Đăng xuất thành công");
  } else {
    print("Lỗi khi đăng xuất: ${response.statusCode}");
  }
}
