/*
    @author Sidali Fetoumi
    @date 5/15/2022
*/
import 'package:flutter/material.dart';
import 'package:stduents_management/pages/student/student_notes_list_page.dart';

import '../student_reports_list_page.dart';
class StudentSecondPage extends StatefulWidget {
  StudentSecondPage(this.appUrl, this.studentId, this.firstname, this.lastname);
  final String appUrl;
  final int? studentId;
  final String firstname;
  final String lastname;

  @override
  State<StudentSecondPage> createState() => _StudentSecondPageState();
}

class _StudentSecondPageState extends State<StudentSecondPage> {
  int currentIndex = 0;
  late List<Widget> screens = [
    StudentsReportsListPage(widget.appUrl, widget.studentId, widget.firstname, widget.lastname),
    StudentNotesListPage(widget.appUrl, widget.studentId, widget.firstname, widget.lastname)
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
    );
  }
}
