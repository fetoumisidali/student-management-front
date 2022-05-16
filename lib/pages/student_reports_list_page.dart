/*
    @author Sidali Fetoumi
    @date 5/14/2022
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/student.dart';

class StudentsReportsListPage extends StatefulWidget {
  StudentsReportsListPage(this.appUrl, this.studentId, this.firstname, this.lastname);
  final String appUrl;
  final int? studentId;
  final String firstname;
  final String lastname;

  @override
  State<StudentsReportsListPage> createState() =>
      _StudentsReportsListPageState();
}

class _StudentsReportsListPageState extends State<StudentsReportsListPage> {
  @override
  initState() {
    refreshData();
    super.initState();
  }

  void refreshData() async {
    setState(() {
      studentReports = getStudentReports(widget.appUrl, widget.studentId);
    });
  }

  late Future<List<StudentReport>>? studentReports =
      getStudentReports(widget.appUrl, widget.studentId);

  static Future<List<StudentReport>> getStudentReports(
      appUrl, studentId) async {
    // ignore: prefer_const_declarations
    final url = "$appUrl/student/$studentId/reports";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<StudentReport>(StudentReport.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.firstname} ${widget.lastname} Reports")),
      body: FutureBuilder<List<StudentReport>>(
        future: studentReports,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          return buildStudentReports(snapshot.data!);
        },
      ),
    );
  }

  Widget buildStudentReports(List<StudentReport> studentReports) =>
      ListView.builder(
          itemCount: studentReports.length,
          itemBuilder: (context, index) {
            final studentReport = studentReports[index];
            return Card(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${studentReport.materialName}",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 30)),
                    const SizedBox(height: 5),
                    Text(
                      "${studentReport.title}",
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 24),
                    ),
                    SizedBox(height: 5),
                    Text("${studentReport.date}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.redAccent))
                  ],
                ),
              ),
            );
          });
}
