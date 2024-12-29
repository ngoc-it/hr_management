import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_application_1/components/Nhansu/human_resources.dart';
import 'package:flutter_application_1/models/hopdong_model.dart';
import 'package:flutter_application_1/models/phat_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/components/TinhLuong/TinhLuong_model.dart';
import 'package:flutter_application_1/models/thuong_model.dart';
class TinhLuongService {
  static const String baseUrl = 'http://192.168.239.219:5000/api/TinhLuongs';

  Future<List<TinhLuong>> getAllTinhLuongs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TinhLuong.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Tinh Luong');
    }
  }

  Future<TinhLuong> getTinhLuongById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TinhLuong.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Tinh Luong');
    }
  }


  
Future<void> createTinhLuong(TinhLuong tinhLuong) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(tinhLuong.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create TinhLuong');
    }
  }

  Future<void> updateTinhLuong(int id, TinhLuong tinhLuong) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'tenTinhLuong': tinhLuong.tenTinhLuong,
        'thangNam': tinhLuong.thangNam.toIso8601String(),
        'nhanVienId': tinhLuong.nhanVienId,
        'hopDongId': tinhLuong.hopDongId,
        'thuongIds': tinhLuong.thuongIds,
        'phatIds': tinhLuong.phatIds,
        'soNgayCong': tinhLuong.soNgayCong,
        'soNgayNghiCoPhep': tinhLuong.soNgayNghiCoPhep,
        'soNgayNghiKhongPhep': tinhLuong.soNgayNghiKhongPhep,
        'soNgayCongThucTe':tinhLuong.soNgayCongThucTe,
        'luongThucNhan':tinhLuong.luongThucNhan,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update Tinh Luong');
    }
  }

  Future<void> deleteTinhLuong(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete Tinh Luong');
    }
  }

  // Fetch bonuses
  Future<List<Thuong>> fetchBonuses() async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/Thuongs'));
     if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Thuong.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load penalties');
    }
  }

  // Fetch penalties
  static Future<List<Phat>> fetchPenalties() async {
    final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/Phats'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Phat.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load penalties');
    }
  }

  // Fetch employees
 static Future<List<NhanVien>> fetchNhanVien() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/NhanViens'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load NhanVien ');
    }
  }
  static Future<List<HopDong>> fetchHopDong() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.219:5000/api/HopDongs'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => HopDong.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load NhanVien ');
    }
  }
  Future<HopDong?> fetchHopDongByNhanVienId(int nhanVienId) async {
  final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/HopDongs?nhanVienId=$nhanVienId'));
  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    if (jsonData.isNotEmpty) {
      return HopDong.fromJson(jsonData[0]); // Giả sử chỉ có một hợp đồng cho mỗi nhân viên
    } else {
      return null; // Không tìm thấy hợp đồng cho nhân viên này
    }
  } else {
    throw Exception('Failed to load contract');
  }
}
// // Thêm hàm lấy số ngày công từ bảng chấm công
// static Future<int> fetchSoNgayCong(int nhanVienId) async {
//   final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/ChamCongs/TongSoNgayCong/$nhanVienId'));
  
//   if (response.statusCode == 200) {
//     // Giả sử API trả về số ngày công
//     final data = json.decode(response.body);
//     return data['soNgayCong']; // Trả về số ngày công của nhân viên
//   } else {
//     throw Exception('Failed to load ChamCong');
//   }
// }
static Future<double> fetchSoNgayCong(int nhanVienId) async {
  final response = await http.get(Uri.parse('http://192.168.239.219:5000/api/ChamCongs/TongSoNgayCong/$nhanVienId'));

  if (response.statusCode == 200) {
    try {
      // Dữ liệu trả về chỉ là số, parse trực tiếp
      final data = double.parse(response.body);
      print('Số ngày công thực tế trả về từ API: $data');
      return data; // Trả về giá trị double
    } catch (e) {
      throw Exception('Lỗi khi parse dữ liệu số ngày công: $e');
    }
  } else {
    throw Exception('Không thể lấy dữ liệu từ API, mã lỗi: ${response.statusCode}');
  }
}

Future<bool> checkTinhLuongForMonth(int nhanVienId, DateTime thangNam) async {
  try {
    // Truyền tháng và năm từ thangNam, không cần truyền year và month nữa.
    final response = await http.get(
      Uri.parse('$baseUrl/CheckTinhLuongForMonth/$nhanVienId/${thangNam.year}-${thangNam.month.toString().padLeft(2, '0')}'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Check if the response is a boolean value directly
      if (responseData is bool) {
        return responseData;  // Return the boolean value directly
      } else {
        // Handle the case where the response is not a boolean, e.g., log or throw error
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to check salary for the month');
    }
  } catch (e) {
    throw Exception('Error checking salary: ${e.toString()}');
  }
}




}