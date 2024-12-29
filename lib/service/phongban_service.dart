import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/phongban_model.dart';
class PhongBanService {
  final String apiUrl = 'http://192.168.239.219:5000/api/PhongBans';

  // Get list of departments
  Future<List<PhongBan>> fetchPhongBan() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PhongBan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // Add a department
  Future<PhongBan> addPhongBan(PhongBan phongBan) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phongBan.toJson()),
    );
    if (response.statusCode == 201) {
      return PhongBan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add department');
    }
  }

Future<void> updatePhongBan(PhongBan phongBan) async {
  final url = Uri.parse('$apiUrl/${phongBan.id}'); // Đảm bảo phongBan.id là số nguyên
  final headers = {'Content-Type': 'application/json'};

  // Chỉ gửi hai trường cần thiết trong body
  final body = json.encode({
    'id': phongBan.id,
    'phongBanID': phongBan.phongBanID, // Trường này cần khớp với lớp trên server
    'tenPhongBan': phongBan.tenPhongBan, // Trường này cần khớp với lớp trên server
  });

  print('URL: $url'); // In URL để kiểm tra xem id có đúng không
  print('Body: $body'); // In ra dữ liệu JSON gửi lên để kiểm tra
  
  final response = await http.put(
    url,
    headers: headers,
    body: body,
  );

  if (response.statusCode == 204) { // 204 No Content khi cập nhật thành công
    print('Cập nhật phòng ban thành công!');
  } else {
    print('Lỗi cập nhật phòng ban: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to update department');
  }
}




  // Delete a department
  Future<void> deletePhongBan(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete department');
    }
  }
}
