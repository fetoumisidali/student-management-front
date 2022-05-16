/*
    @author Sidali Fetoumi
    @date 5/12/2022
*/
import 'package:flutter/material.dart';
import 'package:stduents_management/pages/material/material_lectures_page.dart';
import 'package:stduents_management/pages/material/material_student_page.dart';
class MaterialSecondPage extends StatefulWidget {
  MaterialSecondPage(this.appUrl,this.materialId,this.materialName);
  final String appUrl;
  final int materialId;
  final String materialName;

  @override
  State<MaterialSecondPage> createState() => _MaterialSecondPageState();
}

class _MaterialSecondPageState extends State<MaterialSecondPage> {
  int currentIndex = 0;
  late List<Widget> screens = [
    MaterialLecturesPage(widget.appUrl,widget.materialName,widget.materialId),
    MaterialStudentsPage(widget.appUrl,widget.materialId,widget.materialName)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: ((index) => setState(() => currentIndex = index)),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: "Lectures",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Students"
          ),
        ],
      ),
    );
  }
}
