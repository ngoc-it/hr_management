import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/chucvu_model.dart';

class ApiService {
  // URL API của bạn
  static const String url = 'http://192.168.239.219:5000/api/ChucVus';

  // Hàm lấy danh sách ChucVu từ API
  static Future<List<ChucVu>> fetchChucVu() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Nếu API trả về thành công (status 200)
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => ChucVu.fromJson(item)).toList();
    } else {
      // Nếu API trả về lỗi
      throw Exception('Failed to load ChucVu');
    }
  }
}
