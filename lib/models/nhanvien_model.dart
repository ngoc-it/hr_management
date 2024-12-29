//tạo model
// nhanvien.dart
class NhanVien {
  final int id;
  final String nhanVienID;
  final String hoTen;
  final DateTime ngaySinh;
  final String diaChi;
  final String sdt;
  final String? anh;
  final String email;
  final int phongBanId;
  final int chucVuId;
  final DateTime ngayVaoLam;
  final int trangThaiID;
  final String? gioiTinh;

  NhanVien({
    required this.id,
    required this.nhanVienID,
    required this.hoTen,
    required this.ngaySinh,
    required this.diaChi,
    required this.sdt,
    this.anh,
    required this.email,
    required this.phongBanId,
    required this.chucVuId,
    required this.ngayVaoLam,
    required this.trangThaiID,
    this.gioiTinh,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'],
      nhanVienID: json['nhanVienID'],
      hoTen: json['hoTen'],
      ngaySinh: DateTime.parse(json['ngaySinh']),
      diaChi: json['diaChi'],
      sdt: json['sdt'],
      anh: json['anh'],
      email: json['email'],
      phongBanId: json['phongBanId'],
      chucVuId: json['chucVuId'],
      ngayVaoLam: DateTime.parse(json['ngayVaoLam']),
      trangThaiID: json['trangThaiID'],
      gioiTinh: json['gioiTinh'],
    );
  }
  // Phương thức chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nhanVienID': nhanVienID,
      'hoTen': hoTen,
      'ngaySinh': ngaySinh.toIso8601String(), // Đảm bảo chuyển DateTime thành ISO 8601 string
      'diaChi': diaChi,
      'sdt': sdt,
      'anh': anh,
      'email': email,
      'phongBanId': phongBanId,
      'chucVuId': chucVuId,
      'ngayVaoLam': ngayVaoLam.toIso8601String(), // Chuyển DateTime thành ISO 8601 string
      'trangThaiID': trangThaiID,
      'gioiTinh': gioiTinh,
    'chucVu': {
      'id': chucVuId,
      'tenChucVu': '', // Cần được cập nhật với tên chức vụ thực tế
    },
    'phongBan': {
      'id': phongBanId,
      'tenPhongBan': '', // Cần được cập nhật với tên phòng ban thực tế
    }
    };
  }
}