class TinhLuong {
  final int id;
  final String tenTinhLuong;
  final DateTime thangNam;
  final double luongThucNhan;
  final int nhanVienId;
  final int hopDongId;
  final List<int> thuongIds;
  final List<int> phatIds;
  final double soNgayCong;
  final double soNgayNghiCoPhep;
  final double soNgayNghiKhongPhep;
  final double soNgayCongThucTe;
  TinhLuong({
    required this.id,
    required this.tenTinhLuong,
    required this.thangNam,
    required this.luongThucNhan,
    required this.nhanVienId,
    required this.hopDongId,
    required this.thuongIds,
    required this.phatIds,
    required this.soNgayCong,
    required this.soNgayNghiCoPhep,
    required this.soNgayNghiKhongPhep,
    required this.soNgayCongThucTe,
  });

  factory TinhLuong.fromJson(Map<String, dynamic> json) {
  print('Field id: ${json['id']}');
  print('Field tenTinhLuong: ${json['tenTinhLuong']}');
  print('Field thangNam: ${json['thangNam']}');
  print('Field luongThucNhan: ${json['luongThucNhan']}');
  print('Field nhanVienId: ${json['nhanVienId']}');
  print('Field hopDongId: ${json['hopDongId']}');
  print('Field thuongIds: ${json['thuongIds']}');
  print('Field phatIds: ${json['phatIds']}');
  print('Field soNgayCong: ${json['soNgayCong']}');
  print('Field soNgayNghiCoPhep: ${json['soNgayNghiCoPhep']}');
  print('Field soNgayNghiKhongPhep: ${json['soNgayNghiKhongPhep']}');
  print('Field soNgayCongThucTe: ${json['soNgayCongThucTe']}');

  // Xử lý trường hợp 'soNgayCongThucTe' là kiểu số và phân tích đúng cách.
  return TinhLuong(
    id: json['id'] ?? 0,
    tenTinhLuong: json['tenTinhLuong'] ?? '',
    thangNam: json['thangNam'] != null ? DateTime.parse(json['thangNam']) : DateTime.now(),
    luongThucNhan: (json['luongThucNhan'] is num)
        ? (json['luongThucNhan'] as num).toDouble()
        : 0.0, // Mặc định là 0 nếu null hoặc không phải số
    nhanVienId: json['nhanVienId'] ?? 0,
    hopDongId: json['hopDongId'] != null ? json['hopDongId'] : 0, // Mặc định là 0 nếu null
    thuongIds: (json['thuongIds'] as List<dynamic>?)?.map((e) {
      return e is String ? int.tryParse(e) ?? 0 : e as int;
    }).toList() ?? [],
    phatIds: (json['phatIds'] as List<dynamic>?)?.map((e) {
      return e is String ? int.tryParse(e) ?? 0 : e as int;
    }).toList() ?? [],
    soNgayCong: (json['soNgayCong'] is num)
        ? (json['soNgayCong'] as num).toDouble()
        : 0.0, // Mặc định là 0 nếu null hoặc không phải số
    soNgayNghiCoPhep: (json['soNgayNghiCoPhep'] is num)
        ? (json['soNgayNghiCoPhep'] as num).toDouble()
        : 0.0, // Mặc định là 0 nếu null hoặc không phải số
    soNgayNghiKhongPhep: (json['soNgayNghiKhongPhep'] is num)
        ? (json['soNgayNghiKhongPhep'] as num).toDouble()
        : 0.0, // Mặc định là 0 nếu null hoặc không phải số
    soNgayCongThucTe: json['soNgayCongThucTe'] != null 
        ? (json['soNgayCongThucTe'] is num
            ? (json['soNgayCongThucTe'] as num).toDouble()
            : double.tryParse(json['soNgayCongThucTe'].toString()) ?? 0.0)
        : 0.0, // Mặc định là 0 nếu null hoặc không phải số
  );
}

  get hoTen => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTinhLuong': tenTinhLuong,
      'thangNam': thangNam.toIso8601String(),
      'luongThucNhan': luongThucNhan,
      'nhanVienId': nhanVienId,
      'hopDongId': hopDongId,
      'thuongIds': thuongIds,
      'phatIds': phatIds,
      'soNgayCong': soNgayCong,
      'soNgayNghiCoPhep': soNgayNghiCoPhep,
      'soNgayNghiKhongPhep': soNgayNghiKhongPhep,
      'soNgayCongThucTe': soNgayCongThucTe,
    };
  }
}
