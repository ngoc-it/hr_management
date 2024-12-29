import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Thư viện biểu đồ tròn

class TimekeepingChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Bóng đổ cho khung
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Đồng nhất với `WorkingHours`
        children: [
           Text(
            'Thời gian',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TimekeepingChart1(), // Biểu đồ thời gian chấm công
        ],
      ),
    );
  }
}

class TimekeepingChart1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 140, // Điều chỉnh kích thước tương tự với phần "Số tiếng làm việc"
          width: 140,
          child: PieChart(
            PieChartData(
              sections: showingSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LegendItem(color: Colors.greenAccent, text: 'Đúng giờ'),
            LegendItem(color: Colors.orangeAccent, text: 'Trễ giờ'),
            LegendItem(color: Colors.redAccent, text: 'Quên chấm công'),
            LegendItem(color: Colors.blueAccent, text: 'Không chấm công'),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value: 40,
            radius: 40, // Giảm bán kính của các phần biểu đồ
            titleStyle: TextStyle(
              fontSize: 12, // Giảm kích thước font tiêu đề
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: 30,
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: 20,
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: 10,
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14, // Giảm kích thước ô vuông màu
          height: 14,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14), // Giảm kích thước font chữ
        ),
      ],
    );
  }
}
