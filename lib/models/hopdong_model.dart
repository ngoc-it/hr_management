class HopDong {
  int id;
  int hopDongId;
  String tenHopDong;
  int nhanVienId;
  DateTime  ngayBatDau;
  DateTime ?ngayKetThuc;
  String? ghiChu;
  double luongCoBan;
  String trangThai;
    String? hoTen;  // Added
   // Added
  HopDong({
    required this.id,
    required this.hopDongId,
    required this.tenHopDong,
    required this.nhanVienId,
    required this.ngayBatDau,
    required this.luongCoBan,
    this.ghiChu,
    required this.ngayKetThuc, // Added
    required this.trangThai, 
        this.hoTen,// Added
  });
  factory HopDong.fromJson(Map<String, dynamic> json) {
    return HopDong(
      id: json['id'] as int,
      hopDongId: json['hopDongId'] as int,
      nhanVienId: json['nhanVienId'] as int,
      luongCoBan:(json['luongCoBan'] as num).toDouble(), // Chuyển đổi thành double
      trangThai: json['trangThai'],
      ghiChu: json['ghiChu'] as String?,
      tenHopDong: json['tenHopDong'], // Added
     ngayKetThuc: json['ngayKetThuc'] != null ? DateTime.parse(json['ngayKetThuc']) : null,

      ngayBatDau: DateTime.parse(json['ngayBatDau']),
            hoTen: json['hoTen'] as String?, 
      // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hopDongId': hopDongId,
      'nhanVienId': nhanVienId,
      'luongCoBan': luongCoBan,
      'trangThai': trangThai,
      'ghiChu': ghiChu ?? '',
      'tenhopDong': tenHopDong, // Added
      'ngayBatDau': ngayBatDau,
      'ngayKetThuc': ngayKetThuc, 
            'hoTen': hoTen,// Added
    };
  }
}