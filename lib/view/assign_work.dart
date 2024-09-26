import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/add_project_screen.dart';
import 'package:flutter_application_1/view/add_task_screen.dart'; // Thêm import nếu bạn có màn hình thêm công việc

class AssignWorkPage extends StatefulWidget {
  @override
  _AssignWorkPageState createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0; // Biến theo dõi tab hiện tại

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTab = _tabController.index; // Cập nhật trạng thái tab hiện tại
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giao việc'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Việc của tôi'),
            Tab(text: 'Dự án'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Action for refresh button
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab "Việc của tôi"
          TaskListView(),
          // Tab "Dự án"
          ProjectListView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            // Kiểm tra tab hiện tại và điều hướng đúng
            if (currentTab == 0) {
              // Nếu tab hiện tại là "Việc của tôi", điều hướng đến trang thêm công việc
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()), 
              );
            } else {
              // Nếu tab hiện tại là "Dự án", điều hướng đến trang thêm dự án
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProjectScreen()), 
              );
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

// Trang danh sách công việc (Tab "Việc của tôi")
class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tên công việc...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Sử dụng ExpansionTile cho danh sách công việc
            ExpansionTile(
              title: Text(
                'Danh sách công việc',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                TaskItem(taskName: 'Design', dueDate: '09 Th.10'),
                TaskItem(taskName: 'App đồ ăn', dueDate: '02 Th.10'),
              ],
            ),
            // Có thể thêm các ExpansionTile khác ở đây...
          ],
        ),
      ),
    );
  }
}

// Trang danh sách dự án (Tab "Dự án")
class ProjectListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tên dự án...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Sử dụng ExpansionTile cho danh sách dự án
            ExpansionTile(
              title: Text(
                'Danh sách dự án',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                TaskItem(taskName: 'Dự án A', dueDate: '09 Th.10'),
                TaskItem(taskName: 'Dự án B', dueDate: '02 Th.10'),
              ],
            ),
            // Có thể thêm các ExpansionTile khác ở đây...
          ],
        ),
      ),
    );
  }
}

// Widget cho các mục công việc hoặc dự án
class TaskItem extends StatelessWidget {
  final String taskName;
  final String dueDate;

  TaskItem({required this.taskName, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      leading: Checkbox(
        value: false,
        onChanged: (bool? value) {
          // Handle checkbox state change
        },
      ),
      title: Text(taskName),
      trailing: Text(dueDate),
    );
  }
}