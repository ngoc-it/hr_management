import 'package:flutter/material.dart';

class AssignWorkPage extends StatefulWidget {
  @override
  _AssignWorkPageState createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> {
  // Dữ liệu mẫu cho dự án và công việc
  final List<Project> projects = [
    Project(
      projectId: 1,
      projectName: 'Dự án A',
      startDate: DateTime(2024, 10, 1),
      endDate: DateTime(2024, 10, 30),
      tasks: [
        Task(taskName: 'Thiết kế giao diện', dueDate: '2024-10-05'),
        Task(taskName: 'Phát triển API', dueDate: '2024-10-15'),
      ],
    ),
    Project(
      projectId: 2,
      projectName: 'Dự án B',
      startDate: DateTime(2024, 10, 2),
      endDate: DateTime(2024, 10, 20),
      tasks: [
        Task(taskName: 'Xây dựng cơ sở dữ liệu', dueDate: '2024-10-10'),
        Task(taskName: 'Kiểm thử ứng dụng', dueDate: '2024-10-18'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phân Công Công Việc'),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(projects[index].projectName),
              subtitle: Text(
                'Bắt đầu: ${projects[index].startDate.toLocal().toString().split(' ')[0]} - '
                'Kết thúc: ${projects[index].endDate.toLocal().toString().split(' ')[0]}',
              ),
              onTap: () {
                // Khi nhấn vào dự án, điều hướng đến danh sách công việc
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListView(tasks: projects[index].tasks),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Mô hình Dự án
class Project {
  final int projectId;
  final String projectName;
  final DateTime startDate;
  final DateTime endDate;
  final List<Task> tasks;

  Project({
    required this.projectId,
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });
}

// Mô hình Công việc
class Task {
  final String taskName;
  final String dueDate;

  Task({
    required this.taskName,
    required this.dueDate,
  });
}

// Trang hiển thị danh sách công việc cho một dự án
class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  TaskListView({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Công Việc'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].taskName),
              subtitle: Text('Hạn cuối: ${tasks[index].dueDate}'),
            ),
          );
        },
      ),
    );
  }
}
