/*
    @author Sidali Fetoumi
    @date 5/15/2022
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../model/student.dart';

class StudentNotesListPage extends StatefulWidget {
  StudentNotesListPage(this.appUrl, this.studentId, this.firstname, this.lastname);
  final String appUrl;
  final int? studentId;
  final String firstname;
  final String lastname;

  @override
  State<StudentNotesListPage> createState() => _StudentNotesLIstPageState();
}

class _StudentNotesLIstPageState extends State<StudentNotesListPage> {
  @override
  initState() {
    refreshData();
    super.initState();
  }

  void refreshData() async {
    setState(() {
      studentNotes = getStudentNotes(widget.appUrl, widget.studentId);
    });
  }

  late Future<List<StudentNote>>? studentNotes =
  getStudentNotes(widget.appUrl, widget.studentId);

  static Future<List<StudentNote>> getStudentNotes(
      appUrl, studentId) async {
    // ignore: prefer_const_declarations
    final url = "$appUrl/student/$studentId/notes";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<StudentNote>(StudentNote.fromJson).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.firstname} ${widget.lastname} Notes")),
      body: FutureBuilder<List<StudentNote>>(
        future: studentNotes,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          return buildStudentNotes(snapshot.data!);
        },
      ),
    );
  }

  Widget buildStudentNotes(List<StudentNote> studentNotes) =>
      ListView.builder(
          itemCount: studentNotes.length,
          itemBuilder: (context, index) {
            final studentNote = studentNotes[index];
            return Card(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${studentNote.materialName}",
                        style:
                        const TextStyle(color: Colors.blue, fontSize: 30)),
                    const SizedBox(height: 5),
                    Text(
                      "${studentNote.noteType}",
                      style:
                      TextStyle(color: Colors.orangeAccent, fontSize: 24),
                    ),
                    SizedBox(height: 5),
                    Text("${studentNote.note}",
                        style: const TextStyle(
                            fontSize: 20, color: Colors.redAccent))
                  ],
                ),
              ),
            );
          });
}
