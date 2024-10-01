import 'package:flutter/material.dart';

class ContractManagementScreen extends StatefulWidget {
  @override
  _ContractManagementScreenState createState() => _ContractManagementScreenState();
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  List<Contract> contracts = []; // Danh sách hợp đồng
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Hàm thêm hợp đồng
  void _addContract(Contract contract) {
    setState(() {
      contracts.add(contract);
    });
  }

  // Hàm sửa hợp đồng
  void _editContract(int index, Contract updatedContract) {
    setState(() {
      contracts[index] = updatedContract;
    });
  }

  // Hàm xóa hợp đồng
  void _deleteContract(int index) {
    setState(() {
      contracts.removeAt(index);
    });
  }

  // Hàm hiển thị hộp thoại thêm/sửa hợp đồng
  void _showContractDialog({Contract? contract, int? index}) {
    String title = contract != null ? 'Sửa Hợp Đồng' : 'Thêm Hợp Đồng';
    String contractId = contract?.id ?? '';
    String employeeId = contract?.employeeId ?? '';
    String contractType = contract?.type ?? '';
    String startDate = contract?.startDate ?? '';
    String endDate = contract?.endDate ?? '';
    String basicSalary = contract?.basicSalary ?? '';
    String status = contract?.status ?? '';
    String notes = contract?.notes ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: contractId,
                  decoration: InputDecoration(labelText: 'ID hợp đồng'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập ID hợp đồng' : null,
                  onChanged: (value) => contractId = value,
                ),
                TextFormField(
                  initialValue: employeeId,
                  decoration: InputDecoration(labelText: 'ID Nhân viên'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập ID nhân viên' : null,
                  onChanged: (value) => employeeId = value,
                ),
                TextFormField(
                  initialValue: contractType,
                  decoration: InputDecoration(labelText: 'Loại Hợp Đồng'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập loại hợp đồng' : null,
                  onChanged: (value) => contractType = value,
                ),
                TextFormField(
                  initialValue: startDate,
                  decoration: InputDecoration(labelText: 'Ngày bắt đầu'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập ngày bắt đầu' : null,
                  onChanged: (value) => startDate = value,
                ),
                TextFormField(
                  initialValue: endDate,
                  decoration: InputDecoration(labelText: 'Ngày kết thúc'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập ngày kết thúc' : null,
                  onChanged: (value) => endDate = value,
                ),
                TextFormField(
                  initialValue: basicSalary,
                  decoration: InputDecoration(labelText: 'Lương cơ bản'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập lương cơ bản' : null,
                  onChanged: (value) => basicSalary = value,
                ),
                TextFormField(
                  initialValue: status,
                  decoration: InputDecoration(labelText: 'Trạng thái'),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập trạng thái' : null,
                  onChanged: (value) => status = value,
                ),
                TextFormField(
                  initialValue: notes,
                  decoration: InputDecoration(labelText: 'Ghi chú'),
                  onChanged: (value) => notes = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newContract = Contract(
                    id: contractId,
                    employeeId: employeeId,
                    type: contractType,
                    startDate: startDate,
                    endDate: endDate,
                    basicSalary: basicSalary,
                    status: status,
                    notes: notes,
                  );
                  if (contract != null) {
                    _editContract(index!, newContract);
                  } else {
                    _addContract(newContract);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(contract != null ? 'Cập nhật' : 'Thêm'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Hợp Đồng'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 254, 242, 225), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: contracts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(contracts[index].name),
              subtitle: Text('Loại: ${contracts[index].type}, Ngày bắt đầu: ${contracts[index].startDate}, Ngày kết thúc: ${contracts[index].endDate}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showContractDialog(contract: contracts[index], index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Xác Nhận'),
                            content: Text('Bạn có chắc chắn muốn xóa hợp đồng này không?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _deleteContract(index);
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
        onPressed: () => _showContractDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class Contract {
  final String id;
  final String employeeId;
  final String type;
  final String startDate;
  final String endDate;
  final String basicSalary;
  final String status;
  final String notes;

  Contract({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.basicSalary,
    required this.status,
    required this.notes,
  });

  String get name => 'Hợp đồng $id'; // Tạo thuộc tính tên dựa trên ID
}
