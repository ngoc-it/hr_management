class ChucVu {
  int id;
  final int chucVuID;  // Hoặc Id nếu bạn sử dụng trường Id từ API
  final String tenChucVu;

  ChucVu({required this.id,required this.chucVuID, required this.tenChucVu});

  // Phương thức từ JSON sang đối tượng
  factory ChucVu.fromJson(Map<String, dynamic> json) {
    return ChucVu(
      id: json['id'] ?? 0,
      chucVuID: json['chucVuID'],
      tenChucVu: json['tenChucVu'],
    );
  }

  // Phương thức từ đối tượng sang JSON (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chucVuID': chucVuID,
      'tenChucVu': tenChucVu,
    };
  }
}
