import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

class ShiftSelectionScreen extends StatelessWidget {
  const ShiftSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Chọn ca làm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blueAccent.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chấm công có thể không hoạt động khi quyền Vị trí hoặc chế độ Vị trí chính xác bị tắt.',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          // Kiểm tra và yêu cầu quyền truy cập vị trí
                          var status = await Permission.location.request();
                          if (status.isGranted) {
                            // Hiện bản đồ khi nhấn nút cấp phép
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(),
                              ),
                            );
                          } else {
                            // Hiển thị thông báo nếu quyền không được cấp
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Quyền truy cập vị trí bị từ chối.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 231, 241, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text('Cấp phép'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.wifi, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kết nối: wifi Không lấy được thông tin wifi hiện tại',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Bạn đang có 1 ca làm, chọn ca để Vào ca',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ShiftOption(
                  title: 'Ca hành chính',
                  time: '(08:00 - 17:30)',
                  selected: true,
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý sự kiện xác nhận
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 231, 241, 54),
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Xác nhận',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bản đồ'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(10.7769, 106.6951), // Đặt tọa độ bạn muốn hiển thị
          zoom: 14,
        ),
        myLocationEnabled: true, // Kích hoạt hiện vị trí của người dùng
        myLocationButtonEnabled: true, // Kích hoạt nút hiện vị trí
      ),
    );
  }
}

class ShiftOption extends StatelessWidget {
  final String title;
  final String time;
  final bool selected;

  const ShiftOption(
      {super.key,
      required this.title,
      required this.time,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.blue : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Radio(
            value: true,
            groupValue: selected,
            onChanged: (value) {},
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
