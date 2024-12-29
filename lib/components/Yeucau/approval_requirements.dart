import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Yeucau/create_request_form.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:intl/intl.dart';

class ApprovalRequirements extends StatefulWidget {
  const ApprovalRequirements({super.key});

  @override
  State<ApprovalRequirements> createState() => _ApprovalRequirementsState();
}

class _ApprovalRequirementsState extends State<ApprovalRequirements> {
  String selectedAll = 'Tất cả';
  String selectedDate = 'Theo ngày yêu cầu';
  DateTimeRange? selectedDateRange;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> requests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hôm nay",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      image: AssetImage("assets/user1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // PopupMenuButton cho "Tất cả"
                PopupMenuButton<String>(
                  onSelected: (String newValue) {
                    setState(() {
                      selectedAll = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return <String>[
                      'Tất cả',
                      'Công tác/Ra ngoài',
                      'Đi muộn về sớm',
                      'Nghỉ phép',
                      'Làm thêm giờ',
                      'Thay đổi giờ vào/ra',
                      'Đăng ký ca làm',
                      'Đổi ca làm',
                      'Tạm ứng lương',
                      'Thanh toán',
                      'Mua hàng',
                      'Khen thưởng',
                      'Kỷ luật'
                    ].map<PopupMenuItem<String>>((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(_getIconForRequest(value)),
                            SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.list),
                        SizedBox(width: 8),
                        Text(selectedAll),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                // PopupMenuButton cho "Theo ngày yêu cầu" và "Theo ngày gửi"
                PopupMenuButton<String>(
                  onSelected: (String newValue) {
                    setState(() {
                      selectedDate = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return <String>[
                      'Theo ngày yêu cầu',
                      'Theo ngày gửi',
                    ].map<PopupMenuItem<String>>((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.date_range),
                            SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        SizedBox(width: 8),
                        Text(selectedDate),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Các phần khác của giao diện
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () async {
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  initialDateRange: selectedDateRange,
                );
                if (picked != null && picked != selectedDateRange) {
                  setState(() {
                    selectedDateRange = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDateRange != null
                          ? '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}'
                          : 'Chọn khoảng thời gian',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Icon(Icons.calendar_today, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          // Phần tiếp theo không thay đổi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  title: Text("Yêu cầu"),
                  trailing: Text("${requests.length}", style: TextStyle(color: Colors.orange)),
                  children: <Widget>[
                    ...requests.map((request) => ListTile(
                      title: Text("${request['type']} - ${request['employeeName']}"),
                    )).toList(),
                  ],
                ),
                ExpansionTile(
                  title: Text("Chấp thuận"),
                  trailing: Text("0", style: TextStyle(color: Colors.green)),
                  children: <Widget>[
                    ListTile(
                        title: Text("Danh sách yêu cầu được chấp thuận...")),
                  ],
                ),
                ExpansionTile(
                  title: Text("Từ chối"),
                  trailing: Text("0", style: TextStyle(color: Colors.red)),
                  backgroundColor: Colors.greenAccent.shade100,
                  children: <Widget>[
                    ListTile(title: Text("Danh sách yêu cầu bị từ chối...")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return CreateRequestForm(onCreate: (String type, String employeeName) {
                // Khi tạo yêu cầu, thêm vào danh sách
                setState(() {
                  requests.add({'type': type, 'employeeName': employeeName});
                });
                Navigator.pop(context); // Đóng modal sau khi tạo yêu cầu
              });
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Hàm để chọn icon phù hợp cho từng loại yêu cầu
  IconData _getIconForRequest(String requestType) {
    switch (requestType) {
      case 'Công tác/Ra ngoài':
        return Icons.business;
      case 'Đi muộn về sớm':
        return Icons.access_time;
      case 'Nghỉ phép':
        return Icons.beach_access;
      case 'Làm thêm giờ':
        return Icons.alarm_add;
      case 'Thay đổi giờ vào/ra':
        return Icons.update;
      case 'Đăng ký ca làm':
        return Icons.schedule;
      case 'Đổi ca làm':
        return Icons.swap_horiz;
      case 'Tạm ứng lương':
        return Icons.attach_money;
      case 'Thanh toán':
        return Icons.payment;
      case 'Mua hàng':
        return Icons.shopping_cart;
      case 'Khen thưởng':
        return Icons.card_giftcard;
      case 'Kỷ luật':
        return Icons.gavel;
      default:
        return Icons.list;
    }
  }
}