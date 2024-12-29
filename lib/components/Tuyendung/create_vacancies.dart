import 'package:flutter/material.dart';

class CreateVacanciesPage extends StatefulWidget {
  const CreateVacanciesPage({super.key});

  @override
  State<CreateVacanciesPage> createState() => _CreateVacanciesPageState();
}

class _CreateVacanciesPageState extends State<CreateVacanciesPage> {
  String? _jobTitle;
  String? _workType;
  String? _ageRequirement;
  String? _numberOfVacancies;
  String? _position;
  String? _educationLevel;
  String? _genderRequirement;
  String? _workLocation;
  String? _minSalary;
  String? _maxSalary;
  String? _jobDescription;
  String? _experience;
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _contactAddress;
  bool _isSalaryNegotiable = false;

  final List<String> _workTypes = [
    'Toàn thời gian',
    'Bán thời gian',
    'Thực tập',
    'Tự do'
  ];
  final List<String> _ageRequirements = ['18-25', '26-35', '36-45', '45+'];
  final List<String> _positions = [
    'Nhân viên',
    'Quản lý',
    'Trưởng phòng',
    'Giám đốc'
  ];
  final List<String> _educationLevels = [
    'Trung học',
    'Cao đẳng',
    'Đại học',
    'Thạc sĩ'
  ];
  final List<String> _genderRequirements = ['Nam', 'Nữ', 'Không yêu cầu'];
  final List<String> _experiences = [
    'Không có kinh nghiệm',
    '1-3 năm',
    '3-5 năm',
    'Trên 5 năm'
  ];

  void _deleteInfo() {
    setState(() {
      _jobTitle = null;
      _workType = null;
      _ageRequirement = null;
      _numberOfVacancies = null;
      _position = null;
      _educationLevel = null;
      _genderRequirement = null;
      _workLocation = null;
      _minSalary = null;
      _maxSalary = null;
      _jobDescription = null;
      _experience = null;
      _fullName = null;
      _email = null;
      _phoneNumber = null;
      _contactAddress = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thông tin đã được xóa')),
    );
  }

  void _updateInfo() {
    if (_jobTitle != null &&
        _workType != null &&
        _ageRequirement != null &&
        _position != null &&
        _educationLevel != null) {
      print('Cập nhật thông tin...');
      print('Công việc: $_jobTitle');
      print('Hình thức làm việc: $_workType');
      print('Yêu cầu độ tuổi: $_ageRequirement');
      print('Số lượng cần tuyển: $_numberOfVacancies');
      print('Vị trí: $_position');
      print('Trình độ học vấn: $_educationLevel');
      print('Giới tính: $_genderRequirement');
      print('Kinh nghiệm: $_experience');
      print('Nơi làm việc: $_workLocation');
      print('Mức lương tối thiểu: $_minSalary');
      print('Mức lương tối đa: $_maxSalary');
      print('Mô tả công việc: $_jobDescription');
      print('Thông tin liên hệ: $_fullName, $_email, $_phoneNumber, $_contactAddress');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm vị trí tuyển dụng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Phần Thông tin liên hệ
              Text(
                'Thông tin liên hệ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Họ và tên'),
                onChanged: (value) {
                  _fullName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _phoneNumber = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Địa chỉ liên hệ'),
                onChanged: (value) {
                  _contactAddress = value;
                },
              ),
              SizedBox(height: 20),

              // Phần Vị trí tuyển dụng
              Text(
                'Vị trí tuyển dụng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Công việc'),
                    onChanged: (value) {
                      _jobTitle = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Hình thức làm việc'),
                    items: _workTypes.map((workType) {
                      return DropdownMenuItem(
                        value: workType,
                        child: Text(workType),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _workType = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Yêu cầu độ tuổi'),
                    items: _ageRequirements.map((age) {
                      return DropdownMenuItem(
                        value: age,
                        child: Text(age),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _ageRequirement = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Số lượng cần tuyển'),
                    onChanged: (value) {
                      _numberOfVacancies = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Vị trí tuyển dụng'),
                    items: _positions.map((position) {
                      return DropdownMenuItem(
                        value: position,
                        child: Text(position),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _position = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Trình độ học vấn'),
                    items: _educationLevels.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _educationLevel = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Yêu cầu giới tính'),
                    items: _genderRequirements.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _genderRequirement = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Nơi làm việc'),
                    onChanged: (value) {
                      _workLocation = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Kinh nghiệm làm việc'),
                    items: _experiences.map((experience) {
                      return DropdownMenuItem(
                        value: experience,
                        child: Text(experience),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _experience = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Phần Thỏa thuận lương
              Text(
                'Thỏa thuận lương',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Mức lương tối thiểu'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _minSalary = value;
                      },
                      enabled: !_isSalaryNegotiable,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Mức lương tối đa'),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                      _maxSalary = value;
                    },
                    enabled: !_isSalaryNegotiable,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (_isSalaryNegotiable)
              Text(
                'Thỏa thuận khi phỏng vấn',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Thỏa thuận lương?'),
              value: _isSalaryNegotiable,
              onChanged: (value) {
                setState(() {
                  _isSalaryNegotiable = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Phần Mô tả công việc
            Text(
              'Mô tả công việc',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mô tả công việc',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              onChanged: (value) {
                _jobDescription = value;
              },
            ),
            SizedBox(height: 20),

            // Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _deleteInfo,
                  child: Text('Xóa'),
                ),
                ElevatedButton(
                  onPressed: _updateInfo,
                  child: Text('Cập nhật'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}