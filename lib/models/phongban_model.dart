import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PhongBan {
  int id;
  int phongBanID; // Giữ nguyên kiểu int
  String tenPhongBan;

  PhongBan({required this.id, required this.phongBanID, required this.tenPhongBan});

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    return PhongBan(
      id: json['id'] ?? 0, // Cung cấp giá trị mặc định nếu null
      phongBanID: json['phongBanID'], // Phải trùng với tên trường trong JSON
      tenPhongBan: json['tenPhongBan'], // Phải trùng với tên trường trong JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phongBanID': phongBanID, // Phải trùng với tên trường trong JSON
      'tenPhongBan': tenPhongBan, // Phải trùng với tên trường trong JSON
    };
  }
}
