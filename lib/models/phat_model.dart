class Phat{
  int id;
  String tenPhat;
  double soTien;


  Phat({required this.id,required this.tenPhat,required this.soTien});

  factory Phat.fromJson(Map<String,dynamic> json){
  return Phat(
    id: json['id'],
    tenPhat: json['tenPhat'] ?? '',
    soTien: json['soTien']?.toDouble() ?? 0.0
  );
}
  // Hàm chuyển từ đối tượng Thuong sang Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenPhat': tenPhat,
      'soTien': soTien,
    };
  }
}