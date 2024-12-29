import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application_1/models/congviec_model.dart';

class CongViecService {
  final String apiUrl = 'http://192.168.239.219:5000/api/CongViecs'; // Thay bằng API URL của bạn

  // Lấy danh sách tất cả các công việc
  Future<List<CongViec>> fetchCongViecs() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => CongViec.fromJson(job)).toList();
    } else {
      throw Exception('Không thể tải danh sách công việc');
    }
  }

  // Thêm công việc mới
  Future<CongViec> createCongViec(CongViec congViec) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(congViec.toJson()),
    );

    if (response.statusCode == 201) {
      return CongViec.fromJson(json.decode(response.body));
    } else {
      throw Exception('Không thể thêm công việc');
    }
  }

  // Sửa công việc
  Future<void> updateCongViec(int id, CongViec congViec) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(congViec.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể cập nhật công việc');
    }
  }

  // Xóa công việc
  Future<void> deleteCongViec(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa công việc');
    }
  }
}
