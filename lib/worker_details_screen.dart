import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class WorkerDetailsScreen extends StatelessWidget {
  final String name;
  final String image;
  final Color color;
  final String jobTitle;

  const WorkerDetailsScreen(
    {super.key, 
    required this.name, 
    required this.image, 
    required this.color, 
    required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea
    (child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          color: color.withOpacity(0.2),
          child: Stack(
            children: [
            Stack(
              children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20, 
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 40),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent,
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0.1,
                                blurRadius: 2,
                                offset: Offset(0,5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                        child: Text(
                          jobTitle,
                          style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              builder: (context, ScrollController){
                return Container(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: ListView(
                    controller: ScrollController,
                    children: [
                      Text("Thông tin",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          iconContainer(
                            Colors.redAccent,
                            Ionicons.heart,
                            "lượt thích",
                            43,
                          ),
                           iconContainer(
                            Colors.deepPurpleAccent.withOpacity(0.5),
                            AntDesign.like1,
                            "cảm ơn",
                            24,
                          ),
                           iconContainer(
                            Colors.blue,
                            Ionicons.ribbon,
                            "tín nhiệm",
                            50,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Cập nhật",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(height: 15),
                      lastUpdates(
                        name,
                        "Dự án",
                        "Great job when meeting newcomers in the office yesterday. Im proud of him",
                      ),
                      SizedBox(height: 15),
                       lastUpdates(
                        name,
                        "hhhhh",
                        "took the extra efot to help me with my project last week. He's five star teamlead!",
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget lastUpdates(String name, String title, String desc){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
             Text(
              name + " " + desc,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ), 
      ),
    );
  }

  Widget iconContainer(Color color, IconData icon, String title, int number){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
          color: color,
          size: 40,),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              number.toString(),
              style: TextStyle(
                fontSize: 14,
              ),
              ),
              SizedBox(width: 2),
              Text(
              title,
              style: TextStyle(
                color: Colors.black54,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}