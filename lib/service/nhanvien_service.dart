import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';

class NhanVienController {
  final String baseUrl = 'http://localhost:5215/api/NhanViens';

  // Thêm nhân viên
  Future<void> addNhanVien(NhanVien nhanVien) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nhanVien.toJson()),
    );
    //if (response.statusCode != 201) {
    //  throw Exception('Failed to add NhanVien');
   // }
   if (response.statusCode != 201) {
  print('Error response: ${response.body}');
}

  }

Future<void> updateNhanVien(int id, NhanVien nhanVien) async {
  print('Updating NhanVien with ID: $id');
  final requestBody = jsonEncode(nhanVien.toJson());
  print('Request body: $requestBody');
  
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: requestBody,
  );
  
  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Failed to update NhanVien: ${response.statusCode}\nResponse: ${response.body}');
  }
}

    // Xóa nhân viên
  Future<void> deleteNhanVien(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete NhanVien');
    }
  }

  

  // Lấy danh sách nhân viên
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load NhanViens');
    }
  }

  // Upload ảnh cho nhân viên
  Future<String> uploadImage(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/UploadImage'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var res = await request.send();
    if (res.statusCode == 200) {
      var responseData = await res.stream.bytesToString();
      var imageUrl = json.decode(responseData)['Url'];
      return imageUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  fetchPhongBan(int phongBanId) {}

  fetchChucVu(int chucVuId) {}
}