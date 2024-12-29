import 'dart:convert';
import 'package:flutter_application_1/models/phancong_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.239.219:5000/api/PhanCongs';

  // Lấy danh sách PhanCong
  Future<List<PhanCong>> getPhanCongs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PhanCong.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load PhanCongs');
    }
  }

  // Lấy một PhanCong theo ID
  Future<PhanCong> getPhanCong(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return PhanCong.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load PhanCong');
    }
  }

  // Thêm mới một PhanCong
  Future<void> createPhanCong(PhanCong phanCong) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(phanCong.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create PhanCong');
    }
  }

  // Sửa một PhanCong
  Future<void> updatePhanCong(int id, PhanCong phanCong) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(phanCong.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update PhanCong');
    }
  }

  // Xóa một PhanCong
  Future<void> deletePhanCong(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete PhanCong');
    }
  }
}

