import 'dart:convert';

class PhanCong {
  int phanCongId;
  int congViecId;
  String tenCongViecPhanCong;
  int nhanVienId;
  String nguoiPhanCong;
  DateTime ngayBatDau;
  DateTime ngayHoanThanh;
  String trangThai;
  String ghiChu;

  PhanCong({
    required this.phanCongId,
    required this.congViecId,
    required this.tenCongViecPhanCong,
    required this.nhanVienId,
    required this.nguoiPhanCong,
    required this.ngayBatDau,
    required this.ngayHoanThanh,
    required this.trangThai,
    required this.ghiChu,
  });

  factory PhanCong.fromJson(Map<String, dynamic> json) {
    return PhanCong(
      phanCongId: json['phanCongId'],
      congViecId: json['congViecId'],
      tenCongViecPhanCong: json['tenCongViecPhanCong'],
      nhanVienId: json['nhanVienId'],
      nguoiPhanCong: json['nguoiPhanCong'],
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayHoanThanh: DateTime.parse(json['ngayHoanThanh']),
      trangThai: json['trangThai'],
      ghiChu: json['ghiChu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phanCongId': phanCongId,
      'congViecId': congViecId,
      'tenCongViecPhanCong': tenCongViecPhanCong,
      'nhanVienId': nhanVienId,
      'nguoiPhanCong': nguoiPhanCong,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayHoanThanh': ngayHoanThanh.toIso8601String(),
      'trangThai': trangThai,
      'ghiChu': ghiChu,
    };
  }
}
