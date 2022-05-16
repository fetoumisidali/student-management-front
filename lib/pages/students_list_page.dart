/*
    @author Sidali Fetoumi
    @date 5/11/2022
*/
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stduents_management/model/student.dart';
import 'package:http/http.dart' as http;
import 'package:stduents_management/pages/student_materials_page.dart';

class StudentsList extends StatefulWidget {
  const StudentsList(this.classId, this.className, this.appUrl);
  final int classId;
  final String className;
  final String appUrl;
  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  late Future<List<Student>>? students =
      getStudents(widget.appUrl, widget.classId);

  static Future<List<Student>> getStudents(appUrl, classId) async {
    final url = "$appUrl/class/$classId/students";
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body.map<Student>(Student.fromJson).toList();
  }

  void refreshData() async {
    setState(() {
      students = getStudents(widget.appUrl, widget.classId);
    });
  }
  late TextEditingController firstname = TextEditingController();
  late TextEditingController lastname = TextEditingController();

  @override
  initState() {
    refreshData();
    super.initState();
  }

  Future createStudent(int classId, Student student) async {
    var url = "${widget.appUrl}/student";
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "firstname": student.firstname,
        "lastname": student.lastname,
        "classId": classId,
      }),
    );
    if (response.statusCode == 201) {
      print("Saved");
      refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.className} Students')),
      body: FutureBuilder<List<Student>>(
        future: students,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          return buildStudent(snapshot.data!);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Student student = await openDialog();
          if (student.firstname == null || student.firstname.isEmpty || student.lastname == null || student == null  || student.lastname.isEmpty) return;
          createStudent(widget.classId,student);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildStudent(List<Student> students) => ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return StudentMaterialPage(student.firstname, student.lastname,
                  student.id, widget.className, widget.appUrl);
            }));
          },
          child: Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(student.firstname + " " + student.lastname,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 20)),
                        const Icon(Icons.person, color: Colors.red)
                      ],
                    ),
                  ]),
            ),
          ),
        );
      });
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Student"),
        content:SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "firstname",labelText:"firstname" ),
                controller:firstname,
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "lastname",labelText:"lastname"),
                controller:lastname,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed:() {
                Navigator.of(context).pop();
                firstname.clear();
                lastname.clear();
              },
              child: const Text("CANCEL")),
          TextButton(
              onPressed:(){
                if((firstname.text == null || firstname.text.isEmpty) || (lastname.text == null || lastname.text.isEmpty)){
                  return;
                }
                else {
                  Navigator.of(context).pop(Student(firstname: firstname.text, lastname: lastname.text));
                  firstname.clear();
                  lastname.clear();
                }
              },
              child: const Text("CREATE"))
        ],
      ));
}
