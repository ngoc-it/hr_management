import 'package:flutter/material.dart';

class CreateRequestForm extends StatelessWidget {
  final Function(String type, String employeeName) onCreate;
  const CreateRequestForm({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chọn loại yêu cầu",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildOption(context, Icons.business_center, "Công tác/Ra ngoài", Colors.green),
            _buildOption(context, Icons.access_time, "Đi muộn về sớm", Colors.green),
            _buildOption(context, Icons.airline_seat_recline_normal, "Nghỉ phép", Colors.green),
            _buildOption(context, Icons.hourglass_empty, "Làm thêm giờ", Colors.green),
            SizedBox(height: 16),
            _buildOption(context, Icons.access_alarm, "Thay đổi giờ vào/ra", Colors.orange),
            _buildOption(context, Icons.schedule, "Đăng ký ca làm", Colors.orange),
            _buildOption(context, Icons.swap_horizontal_circle, "Đổi ca làm", Colors.orange),
            _buildOption(context, Icons.attach_money, "Tạm ứng lương", Colors.blue),
            _buildOption(context, Icons.payment, "Thanh toán", Colors.blue),
            _buildOption(context, Icons.shopping_cart, "Mua hàng", Colors.blue),
            _buildOption(context, Icons.star, "Khen thưởng", Colors.red),
            _buildOption(context, Icons.warning, "Kỷ luật", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () {
        // Khi bấm vào loại yêu cầu, hiển thị form tương ứng
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestForm(type: text, onCreate: onCreate),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 16),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class RequestForm extends StatefulWidget {
  final String type;
  final Function(String type, String employeeName) onCreate;

  const RequestForm({Key? key, required this.type, required this.onCreate}) : super(key: key); // Sửa constructor


  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(); // Controller cho địa điểm
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String _selectedShift = 'Ca 1'; // Mặc định chọn ca 1
  final List<String> _shifts = ['Ca 1', 'Ca 2', 'Ca 3']; // Danh sách các ca làm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFormFields(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [
      _buildTextField("Tên nhân viên", _employeeController),
      SizedBox(height: 16),
      _buildTextField("Lý do", _reasonController, maxLines: 3),
    ];

    // Thêm các trường bổ sung dựa trên loại yêu cầu
    switch (widget.type) {
      case "Công tác/Ra ngoài":
        fields.insertAll(2, [
          // Thêm ô nhập liệu địa điểm
          SizedBox(height: 16),
          _buildDatePicker("Ngày bắt đầu", _startDateController),
          SizedBox(height: 16),
          _buildDatePicker("Ngày kết thúc", _endDateController),
           SizedBox(height: 16),
          _buildTextField("Địa điểm", _locationController), 
          SizedBox(height: 16),
          _buildShiftDropdown(),
        ]);
        break;
      case "Làm thêm giờ":
        fields.insertAll(2, [
          SizedBox(height: 16),
          _buildTextField("Loại làm thêm", TextEditingController()),
          SizedBox(height: 16),
          _buildTextField("Thời gian làm thêm", TextEditingController()),
        ]);
        break;
      // Thêm các trường hợp khác ở đây
    }

    // Thêm nút tạo
    fields.add(SizedBox(height: 20));
    fields.add(ElevatedButton(
    onPressed: () {
      if (_employeeController.text.isEmpty || _reasonController.text.isEmpty || (widget.type == "Công tác/Ra ngoài" && (_locationController.text.isEmpty || _startDateController.text.isEmpty || _endDateController.text.isEmpty || _selectedShift.isEmpty))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hãy nhập đầy đủ các mục!'),
          ),
        );
      } else {
        // Gọi callback để gửi dữ liệu trở lại
        widget.onCreate(widget.type, _employeeController.text);
        Navigator.pop(context); // Quay về trang trước
      }
    },
    child: Text('Tạo'),
  ));

    return fields;
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          controller.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey), // Biểu tượng lịch
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiftDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedShift,
        decoration: InputDecoration(
          labelText: "Ca làm việc",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8.0),
        ),
        items: _shifts.map((String shift) {
          return DropdownMenuItem<String>(
            value: shift,
            child: Text(shift),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedShift = newValue!;
          });
        },
      ),
    );
  }
}
