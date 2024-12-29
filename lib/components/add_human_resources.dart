import 'package:flutter/material.dart';

class AddHumanResources extends StatefulWidget {
  const AddHumanResources({super.key});

  @override
  State<AddHumanResources> createState() => _AddHumanResourcesState();
}

class _AddHumanResourcesState extends State<AddHumanResources> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController(); // Để lưu trữ ngày sinh
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thêm Nhân Sự"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Họ tên nhân viên"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ tên nhân viên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController, // Sử dụng controller
                decoration: InputDecoration(labelText: "Ngày sinh"),
                readOnly: true, // Để không thể chỉnh sửa trực tiếp
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Định dạng ngày
                  }
                },
              ),
              Text("Giới tính",style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Nam"),
                    value: "Nam",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Nữ"),
                    value: "Nữ",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
              TextFormField(
                decoration: InputDecoration(labelText: "Địa chỉ"),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Chức vụ"),
                items: [
                  DropdownMenuItem(value: "Nhân viên", child: Text("Nhân viên")),
                  DropdownMenuItem(value: "Quản lý", child: Text("Quản lý")),
                  DropdownMenuItem(value: "Giám đốc", child: Text("Giám đốc")),
                ],
                onChanged: (value) {},
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Phòng ban"),
                items: [
                  DropdownMenuItem(value: "Ban IT", child: Text("Ban IT")),
                  DropdownMenuItem(value: "Ban Thiết Kế", child: Text("Ban Thiết Kế")),
                  DropdownMenuItem(value: "Ban Bán Hàng", child: Text("Ban Bán Hàng")),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              // Xử lý thêm nhân sự ở đây
              Navigator.of(context).pop();
            }
          },
          child: Text("Lưu"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Hủy"),
        ),
      ],
    );
  }
}
