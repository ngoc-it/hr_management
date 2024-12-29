import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';  // Thư viện cho thông báo
import 'package:permission_handler/permission_handler.dart';



// ChamCong model
class ChamCong {
  int id;
  int NhanVienID;
  DateTime ngayChamCong;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String? ViTriCheckIn;
  String? ViTriCheckOut;

  ChamCong({
    required this.id,
    required this.NhanVienID,
    required this.ngayChamCong,
    this.checkInTime,
    this.checkOutTime,
    this.ViTriCheckIn,
    this.ViTriCheckOut,
  });

  factory ChamCong.fromJson(Map<String, dynamic> json) {
    return ChamCong(
      id: json['id'],
      NhanVienID: json['NhanVienID'],
      ngayChamCong: DateTime.parse(json['ngayChamCong']),
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      ViTriCheckIn: json['ViTriCheckIn'],
      ViTriCheckOut: json['ViTriCheckOut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "NhanVienID": NhanVienID,
      "ngayChamCong": ngayChamCong.toIso8601String(),
      "checkInTime": checkInTime?.toIso8601String(),
      "checkOutTime": checkOutTime?.toIso8601String(),
      "ViTriCheckIn": ViTriCheckIn,
      "ViTriCheckOut": ViTriCheckOut,
    };
  }
}
class ChamCongService {
  final String apiUrl = "http://192.168.239.219:5000/api/CheckInCheckOut";

  Future<void> checkIn(int NhanVienID, String? ViTriCheckIn) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/CheckIn'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NhanVienID': NhanVienID,
          'ngayChamCong': DateTime.now().toIso8601String(),
          'checkInTime': DateTime.now().toIso8601String(),
          'ViTriCheckIn': ViTriCheckIn,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Check-in thành công");
      } else {
        Fluttertoast.showToast(msg: "Lỗi khi check-in");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi khi check-in: $e");
    }
  }

  Future<void> checkOut(int NhanVienID, String ViTriCheckOut) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/CheckOut'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NhanVienID': NhanVienID,
          'ngayChamCong': DateTime.now().toIso8601String(),
          'checkOutTime': DateTime.now().toIso8601String(),
          'ViTriCheckOut': ViTriCheckOut,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Check-out thành công");
      } else {
        Fluttertoast.showToast(msg: "Lỗi khi check-out: ${response.body}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi khi check-out: $e");
    }
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late int NhanVienID;
  final ChamCongService _service = ChamCongService();
  bool isCheckIn = false;
  bool isCheckOut = false;
  String message = "";
  Position? _currentPosition;
  late GoogleMapController mapController;
  late LatLng _currentLatLng;
   Set<Marker> _markers = {}; // Set để lưu các marker
  late Timer _timer;
  String _currentTime = "";
    late String formattedTime;
  late String formattedDate;
   bool _isMounted = false; // Cờ theo dõi trạng thái widget
// Định dạng giờ và ngày
  void updateTime() {
    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat("HH:mm:ss");
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    if (_isMounted) {
      setState(() {
        formattedTime = timeFormat.format(now);
        formattedDate = dateFormat.format(now);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Đánh dấu widget đã được gắn kết
    _getCurrentLocation();
    _initializeNhanVienID();
    _startTimer();
    // Cập nhật thời gian mỗi giây
    formattedTime = DateFormat("HH:mm:ss").format(DateTime.now());
    formattedDate = DateFormat("dd/MM/yyyy").format(DateTime.now());

    // Sử dụng Timer để cập nhật giờ liên tục
    Future.delayed(Duration(seconds: 1), () {
      updateTime();
    });
  }

  Future<void> _initializeNhanVienID() async {
  final prefs = await SharedPreferences.getInstance();
  final nhanVienID = prefs.getInt('NhanVienID');
  if (nhanVienID == null || nhanVienID == 0) {
    setState(() {
      message = "Lỗi: Không thể lấy NhanVienID.";
    });
    return;
  }
  
  final isCheckedIn = prefs.getBool('isCheckedIn') ?? false;
  
  setState(() {
    NhanVienID = nhanVienID;
    isCheckIn = isCheckedIn; // Đặt đúng trạng thái check-in
    isCheckOut = !isCheckedIn; // Nếu đã check-in thì chưa check-out
    message = isCheckedIn 
        ? "Bạn đã check-in. Hãy check-out trước khi tiếp tục." 
        : "Chưa thực hiện chấm công.";
  });
}


  @override
  void dispose() {
     _isMounted = false; // Đánh dấu widget đã bị hủy
    _timer.cancel();
    super.dispose();
  }

   Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (_isMounted) {
          setState(() {
            message = "Dịch vụ vị trí không được bật.";
          });
        }
        return;
      }
       LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (_isMounted) {
            setState(() {
              message = "Quyền truy cập vị trí bị từ chối.";
            });
          }
          return;
        }
      }

       if (permission == LocationPermission.deniedForever) {
        if (_isMounted) {
          setState(() {
            message = "Quyền truy cập vị trí bị từ chối vĩnh viễn.";
          });
        }
        return;
      }
       _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (_isMounted) {
        setState(() {
          message = "Lấy vị trí thành công!";
          _currentLatLng = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
          _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            position: _currentLatLng,
            infoWindow: InfoWindow(title: "Vị trí của bạn"),
          ));
        });
      }
      mapController.animateCamera(CameraUpdate.newLatLng(_currentLatLng));
    } catch (e) {
      if (_isMounted) {
        setState(() {
          message = "Lỗi khi lấy vị trí: $e";
        });
      }
    }
  }

   void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_isMounted) {
        _getCurrentLocation();
        setState(() {
          _currentTime = TimeOfDay.now().format(context);
        });
      }
    });
}


  void _handleCheckIn() async {
  if (isCheckIn) {
    Fluttertoast.showToast(msg: "Bạn đã check-in rồi. Vui lòng check-out trước khi check-in lại.");
    return;
  }

  if (_currentPosition == null) {
    setState(() {
      message = "Không có thông tin vị trí hiện tại.";
    });
    return;
  }

  String? ViTriCheckIn = "${_currentPosition!.latitude}, ${_currentPosition!.longitude}";

  // Gửi yêu cầu check-in đến server
  await _service.checkIn(NhanVienID, ViTriCheckIn);

  // Cập nhật trạng thái sau khi check-in
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isCheckedIn', true); // Lưu trạng thái check-in

  setState(() {
    isCheckIn = true;
    isCheckOut = false; // Không cho phép check-out ngay sau check-in
    message = "Check-in thành công lúc: ${DateTime.now().toLocal()}";
  });
}


  void _handleCheckOut() async {
  if (!isCheckIn) {
    Fluttertoast.showToast(msg: "Bạn chưa check-in. Vui lòng check-in trước khi check-out.");
    return;
  }

  if (_currentPosition == null) {
    setState(() {
      message = "Không có thông tin vị trí hiện tại.";
    });
    return;
  }

  String ViTriCheckOut = "${_currentPosition!.latitude}, ${_currentPosition!.longitude}";

  // Gửi yêu cầu check-out đến server
  await _service.checkOut(NhanVienID, ViTriCheckOut);

  // Cập nhật trạng thái sau khi check-out
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('isCheckedIn'); // Xóa trạng thái check-in khi check-out

  setState(() {
    isCheckIn = false;
    isCheckOut = true; // Cho phép check-in sau khi check-out
    message = "Check-out thành công lúc: ${DateTime.now().toLocal()}";
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chấm Công")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị giờ hiện tại
            // Nâng cấp phần hiển thị giờ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hiển thị ngày và giờ
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //  Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: isCheckIn ? Colors.green.shade100 : isCheckOut ? Colors.red.shade100 : Colors.grey.shade200,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 10,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(
            //         isCheckIn ? Icons.check_circle : isCheckOut ? Icons.exit_to_app : Icons.access_alarm,
            //         color: isCheckIn ? Colors.green : isCheckOut ? Colors.red : Colors.grey,
            //         size: 30,
            //       ),
            //       const SizedBox(width: 10),
            //       Text(
            //         message.isEmpty ? "Trạng thái: Chưa chấm công" : message,
            //         style: TextStyle(
            //           fontSize: 10,
            //           fontWeight: FontWeight.bold,
            //           color: isCheckIn ? Colors.green : isCheckOut ? Colors.red : Colors.grey,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isCheckIn
        ? Colors.green.shade100
        : isCheckOut
            ? Colors.red.shade100
            : Colors.grey.shade200,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(
        isCheckIn
            ? Icons.check_circle
            : isCheckOut
                ? Icons.exit_to_app
                : Icons.access_alarm,
        color: isCheckIn ? Colors.green : isCheckOut ? Colors.red : Colors.grey,
        size: 30,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          message.isEmpty ? "Trạng thái: Chưa chấm công" : message,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isCheckIn
                ? Colors.green
                : isCheckOut
                    ? Colors.red
                    : Colors.grey,
          ),
          overflow: TextOverflow.ellipsis, // Nếu văn bản quá dài, sẽ bị cắt và thêm dấu ba chấm
        ),
      ),
    ],
  ),
),

            // Hiển thị bản đồ với vị trí hiện tại
            _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLatLng,
                        zoom: 15,
                      ),
                      markers: _markers,  // Dùng set markers
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Check-in
                ElevatedButton.icon(
                  onPressed: isCheckIn ? null : _handleCheckIn,
                  icon: const Icon(Icons.check_circle, size: 30),
                  label: const Text("Check-in"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bo góc nút
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shadowColor: Colors.greenAccent, // Màu bóng đổ
                    elevation: 10, // Độ cao của nút
                  ),
                ),
                const SizedBox(width: 20),
                // Nút Check-out
                ElevatedButton.icon(
                  onPressed: isCheckOut ? null : _handleCheckOut,
                  icon: const Icon(Icons.exit_to_app, size: 30),
                  label: const Text("Check-out"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bo góc nút
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shadowColor: Colors.redAccent, // Màu bóng đổ
                    elevation: 10, // Độ cao của nút
                  ),
                ),
                

              ],
            ),
           Center(
  child: ElevatedButton(
    onPressed: () {
      if (_currentPosition != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(_currentLatLng));
      }
    },
    child: Text("Vị trí hiện tại"),
  ),
)

          ],
        ),
      ),
    );
  }
}
