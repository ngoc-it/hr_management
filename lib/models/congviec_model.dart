class CongViec {
  final int id;
  final String tenCongViec;
  final String nguoiTao;
  final String moTa;
  final String trangThai;
  final DateTime ngayTao;
  final DateTime ngayHoanThanh;

  CongViec({
    required this.id,
    required this.tenCongViec,
    required this.nguoiTao,
    this.moTa = '',
    required this.trangThai,
    required this.ngayTao,
    required this.ngayHoanThanh,
  });

  factory CongViec.fromJson(Map<String, dynamic> json) {
    return CongViec(
      id: json['id'],
      tenCongViec: json['tenCongViec'],
      nguoiTao: json['nguoiTao'],
      moTa: json['moTa'] ?? '',
      trangThai: json['trangThai'],
      ngayTao: DateTime.parse(json['ngayTao']),
      ngayHoanThanh: DateTime.parse(json['ngayHoanThanh']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenCongViec': tenCongViec,
      'nguoiTao': nguoiTao,
      'moTa': moTa,
      'trangThai': trangThai,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayHoanThanh': ngayHoanThanh.toIso8601String(),
    };
  }
}
