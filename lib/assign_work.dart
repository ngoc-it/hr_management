import 'package:flutter/material.dart';

class AssignWorkPage extends StatefulWidget {
  @override
  _AssignWorkPageState createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0; // Thêm biến để theo dõi tab hiện tại

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
            // Action for adding new task or project
            if (currentTab == 0) {
              // Thực hiện hành động thêm cho tab "Việc của tôi"
            } else {
              // Thực hiện hành động thêm cho tab "Dự án"
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

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
            // Sử dụng ExpansionTile cho "Mới giao"
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
            // Các ExpansionTile khác ở đây...
          ],
        ),
      ),
    );
  }
}

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
            // Sử dụng ExpansionTile cho các dự án
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
            // Các ExpansionTile cho dự án khác ở đây...
          ],
        ),
      ),
    );
  }
}

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
