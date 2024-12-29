class Thuong {
  int id;
  String tenTienThuong; // Tên tiền thưởng
  double soTienThuong;  // Số tiền thưởng

  // Constructor
  Thuong({required this.id, required this.tenTienThuong, required this.soTienThuong});

  // Hàm chuyển từ Map sang đối tượng Thuong
  factory Thuong.fromJson(Map<String, dynamic> json) {
    return Thuong(
      id: json['id']?.toInt() ?? 0,
      tenTienThuong: json['tenTienThuong'] ?? '',
      soTienThuong: json['soTienThuong']?.toDouble() ?? 0.0,
    );

  }

  // Hàm chuyển từ đối tượng Thuong sang Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTienThuong': tenTienThuong,
      'soTienThuong': soTienThuong,
    };
  }
}
