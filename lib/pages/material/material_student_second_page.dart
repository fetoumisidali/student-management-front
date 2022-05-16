/*
    @author Sidali Fetoumi
    @date 5/15/2022
*/
import 'package:flutter/material.dart';

import 'material_note_page.dart';
import 'material_report_page.dart';
class MaterialStudentSecondPage extends StatefulWidget {
  MaterialStudentSecondPage(this.firstname,this.lastname,this.appUrl,this.materialId,this.studentId);
  final String firstname;
  final String lastname;
  final String appUrl;
  final int materialId;
  final int studentId;

  @override
  State<MaterialStudentSecondPage> createState() => _MaterialStudentSecondPageState();
}

class _MaterialStudentSecondPageState extends State<MaterialStudentSecondPage> {
  int currentIndex = 0;
  late List<Widget> screens = [
    MaterialReportPage(widget.firstname,widget.lastname,widget.appUrl,widget.materialId,widget.studentId),
    StudentMaterialNotePage(widget.firstname,widget.lastname,widget.appUrl,widget.materialId,widget.studentId),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: ((index) => setState(() => currentIndex = index)),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Reports",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_add_outlined),
              label: "Notes"
          ),
        ],
      ),
    );;
  }
}
