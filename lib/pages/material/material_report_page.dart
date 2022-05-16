/*
    @author Sidali Fetoumi
    @date 5/14/2022
*/
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stduents_management/model/student.dart';

class MaterialReportPage extends StatefulWidget {
  MaterialReportPage(this.firstname,this.lastname,this.appUrl,this.materialId,this.studentId);
  final String appUrl;
  final int materialId;
  final int studentId;
  final String firstname;
  final String lastname;


  @override
  State<MaterialReportPage> createState() => _MaterialReportPageState();
}

class _MaterialReportPageState extends State<MaterialReportPage> {
  late TextEditingController controller = TextEditingController();
  @override
  initState() {
    refreshData();
    super.initState();
  }
  void refreshData() async {
    setState(() {
      materialStudentReports = getMaterialStudentReports(widget.appUrl, widget.materialId,widget.studentId);
    });
  }

  Future createReport(String title) async {
    try {
      var url = "${widget.appUrl}/report";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "studentId":widget.studentId,
          "materialId":widget.materialId,
          "title": title,
        }),
      );
      if (response.statusCode == 201) {
        successToast();
        refreshData();
      }
      else{
        errorToast();
      }
    } catch (e) {
      errorToast();
    }
  }

  late Future<List<StudentReport>>? materialStudentReports = getMaterialStudentReports(widget.appUrl, widget.materialId,widget.studentId);
  static Future<List<StudentReport>> getMaterialStudentReports(appUrl,materialId,studentId) async{
    // ignore: prefer_const_declarations
    final url = "$appUrl/material/$materialId/students/$studentId/reports";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<StudentReport>(StudentReport.fromJson).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.firstname} ${widget.lastname} Reports")),
      body: FutureBuilder<List<StudentReport>>(
        future: materialStudentReports,
        builder:(ctx,snapshot){
          if(snapshot.hasError){
            return Center(child: Text("${snapshot.error}"));
          }
          if(!snapshot.hasData){
            return const Center(child: Text("Loading..."));
          }
          return buildMaterialStudentReports(snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final title = await openDialog();
          if (title == null || title.isEmpty) return;
          createReport(title);
        },
      ),
    );

  }
  Widget buildMaterialStudentReports(List<StudentReport> studentReports) => ListView.builder(
      itemCount: studentReports.length,
      itemBuilder: (context,index){
        final studentReport = studentReports[index];
        return Card(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child:
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${studentReport.title}", style: const TextStyle(color: Colors.blue, fontSize: 26)),
                const SizedBox(height: 5),
                Text("${studentReport.date}",
                    style: const TextStyle(fontSize: 16, color: Colors.redAccent))
              ],
            ),
          ),
        );
      });
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report ${widget.firstname} ${widget.lastname}"),
        content: TextField(
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              hintText: "Enter report title", labelText: "title"),
          controller: controller,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.clear();
              },
              child: const Text("CANCEL")),
          TextButton(
              onPressed: () {
                if (controller.text == null || controller.text.isEmpty) {
                  return;
                } else {
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                }
              },
              child: const Text("CREATE"))
        ],
      ));
  void successToast() => Fluttertoast.showToast(msg: "Success", fontSize: 12);
  void errorToast() => Fluttertoast.showToast(
      msg: "Something Went Wrong",
      fontSize: 12,
      backgroundColor: Colors.redAccent);
}
