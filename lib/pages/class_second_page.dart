/*
    @author Sidali Fetoumi
    @date 5/12/2022
*/
import 'package:flutter/material.dart';
import 'package:stduents_management/pages/class_materials_page.dart';
import 'package:stduents_management/pages/students_list_page.dart';
class ClassSecondPage extends StatefulWidget {
  ClassSecondPage(this.classId,this.className,this.appUrl);
  final int classId;
  late String className;
  late String appUrl;
  @override
  State<ClassSecondPage> createState() => _ClassSecondPageState();
}

class _ClassSecondPageState extends State<ClassSecondPage> {
  int currentIndex = 0;

  late List<Widget> screens = [
    ClassMaterialsList(widget.className,widget.appUrl,widget.classId),
    StudentsList(widget.classId, widget.className, widget.appUrl),

  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: ((index) => setState(() => currentIndex = index)),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Materials",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Students"
            ),
          ],
        )
    );
  }
}

