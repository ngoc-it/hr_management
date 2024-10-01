import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EmployeeManagementScreen extends StatefulWidget {
  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  List<Employee> employees = []; // Danh sách nhân viên
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Danh sách phòng ban có sẵn
  final List<String> departments = [
    'Phòng Kinh Doanh',
    'Phòng Kỹ Thuật',
    'Phòng Hành Chính',
    'Phòng Nhân Sự',
    'Phòng Marketing',
  ];

  // Danh sách chức vụ có sẵn
  final List<String> positions = [
    'Giám đốc',
    'Trưởng phòng',
    'Nhân viên',
    'Quản lý',
  ];

  // Danh sách trạng thái có sẵn
  final List<String> statuses = ['Đang làm việc', 'Đã nghỉ'];

  // Hàm thêm nhân viên
  void _addEmployee(Employee employee) {
    setState(() {
      employees.add(employee);
    });
  }

  // Hàm sửa nhân viên
  void _editEmployee(int index, Employee updatedEmployee) {
    setState(() {
      employees[index] = updatedEmployee;
    });
  }

  // Hàm xóa nhân viên
  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  // Hàm hiển thị hộp thoại thêm/sửa nhân viên
  void _showEmployeeDialog({Employee? employee, int? index}) {
    String title = employee != null ? 'Sửa Nhân Viên' : 'Thêm Nhân Viên';
    String employeeId = employee?.id ?? '';
    String employeeName = employee?.name ?? '';
    String employeeAddress = employee?.address ?? '';
    String employeePhone = employee?.phone ?? '';
    String employeeEmail = employee?.email ?? '';
    String employeePosition = employee?.position ?? positions[0];
    String employeeDepartment = employee?.department ?? departments[0];
    DateTime? employeeDob = employee?.dob;
    DateTime? employeeJoinDate = employee?.joinDate;
    String employeeStatus = employee?.status ?? statuses[0];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    labelText: 'Mã Nhân Viên',
                    initialValue: employeeId,
                    onChanged: (value) => employeeId = value,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    labelText: 'Tên Nhân Viên',
                    initialValue: employeeName,
                    onChanged: (value) => employeeName = value,
                  ),
                  SizedBox(height: 16),
                  _buildDatePicker(
                    labelText: 'Ngày Sinh',
                    initialValue: employeeDob,
                    onChanged: (value) => employeeDob = value,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    labelText: 'Địa chỉ',
                    initialValue: employeeAddress,
                    onChanged: (value) => employeeAddress = value,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    labelText: 'Số Điện Thoại',
                    initialValue: employeePhone,
                    onChanged: (value) => employeePhone = value,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    labelText: 'Email',
                    initialValue: employeeEmail,
                    onChanged: (value) => employeeEmail = value,
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    labelText: 'Chức Vụ',
                    value: employeePosition,
                    items: positions,
                    onChanged: (value) => employeePosition = value!,
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    labelText: 'Phòng Ban',
                    value: employeeDepartment,
                    items: departments,
                    onChanged: (value) => employeeDepartment = value!,
                  ),
                  SizedBox(height: 16),
                  _buildDatePicker(
                    labelText: 'Ngày Vào Làm',
                    initialValue: employeeJoinDate,
                    onChanged: (value) => employeeJoinDate = value,
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    labelText: 'Trạng Thái',
                    value: employeeStatus,
                    items: statuses,
                    onChanged: (value) => employeeStatus = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newEmployee = Employee(
                    id: employeeId,
                    name: employeeName,
                    address: employeeAddress,
                    phone: employeePhone,
                    email: employeeEmail,
                    position: employeePosition,
                    department: employeeDepartment,
                    dob: employeeDob!,
                    joinDate: employeeJoinDate!,
                    status: employeeStatus,
                  );
                  if (employee != null) {
                    _editEmployee(index!, newEmployee);
                  } else {
                    _addEmployee(newEmployee);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(employee != null ? 'Cập Nhật' : 'Thêm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập $labelText' : null,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: labelText),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker({
    required String labelText,
    required DateTime? initialValue,
    required Function(DateTime?) onChanged,
  }) {
    return FormBuilderDateTimePicker(
      name: labelText.toLowerCase(),
      initialValue: initialValue,
      inputType: InputType.date,
      format: DateFormat('dd-MM-yyyy'),
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Vui lòng chọn $labelText' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Nhân Viên'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [const Color.fromARGB(255, 215, 249, 224), Colors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
      child:ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(employees[index].name),
            subtitle: Text(
                'Chức vụ: ${employees[index].position}, Phòng ban: ${employees[index].department}, Ngày sinh: ${DateFormat('dd-MM-yyyy').format(employees[index].dob)}, Trạng thái: ${employees[index].status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEmployeeDialog(employee: employees[index], index: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Xác Nhận'),
                          content: Text('Bạn có chắc chắn muốn xóa nhân viên này không?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _deleteEmployee(index);
                                Navigator.of(context).pop();
                              },
                              child: Text('Có'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Không'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String position;
  final String department;
  final DateTime dob;
  final DateTime joinDate;
  final String status;

  Employee({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.position,
    required this.department,
    required this.dob,
    required this.joinDate,
    required this.status,
  });
}