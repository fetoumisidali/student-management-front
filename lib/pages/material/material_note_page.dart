/*
    @author Sidali Fetoumi
    @date 5/15/2022
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/student.dart';
import 'package:http/http.dart' as http;
class StudentMaterialNotePage extends StatefulWidget {
  StudentMaterialNotePage(this.firstname,this.lastname,this.appUrl,this.materialId,this.studentId);
  final String firstname;
  final String lastname;
  final String appUrl;
  final int materialId;
  final int studentId;

  @override
  State<StudentMaterialNotePage> createState() => _StudentMaterialNotePageState();
}

class _StudentMaterialNotePageState extends State<StudentMaterialNotePage> {
  @override
  initState() {
    refreshData();
    super.initState();
  }

  void refreshData() async {
    setState(() {
      studentNotes = getStudentNotes(widget.appUrl, widget.studentId,widget.materialId);
    });
  }
  Future createNote(note) async {
    try {
      var url = "${widget.appUrl}/notes";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "studentId": widget.studentId,
          "materialId":widget.materialId,
          "noteType":noteType,
          "note":note
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
  String? noteType;
  final noteTypes = ["EXAM","TD","TP","CC"];
  final note = TextEditingController();
  late Future<List<StudentNote>>? studentNotes =
  getStudentNotes(widget.appUrl, widget.studentId,widget.materialId);

  static Future<List<StudentNote>> getStudentNotes(
      appUrl, studentId,materialId) async {
    // ignore: prefer_const_declarations
    final url = "$appUrl/material/$materialId/students/$studentId/notes";
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{
         final note = await openDialog();
         if(note == null || note < 0 || note > 20 || noteType == null) return;
         createNote(note);
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
                    Text(
                      "${studentNote.noteType}",
                      style:
                      TextStyle(color: Colors.orangeAccent, fontSize: 26),
                    ),
                    SizedBox(height: 5),
                    Text("${studentNote.note}",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.redAccent))
                  ],
                ),
              ),
            );
          });
  DropdownMenuItem<String> buildMenuItem(String item)=>
      DropdownMenuItem(value: item,
          child: Text(
            item,
          ));
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context,setState) => AlertDialog(
          title: const Text("ADD NOTE TO STUDENT"),
          content:SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: noteType,
                  items: noteTypes.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() {
                    noteType = value!;
                  })),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "enter note",labelText:"note"),
                  controller:note,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed:() {
                  Navigator.of(context).pop();
                  note.clear();
                },
                child: const Text("CANCEL")),
            TextButton(
                onPressed:(){
                  try{
                    double note2 = double.parse(note.text);
                    if((noteType == null || note2 < 0 || note2 > 20)){
                      return;
                    }
                    else {
                      Navigator.of(context).pop(note2);
                      note.clear();
                    }
                  }
                  catch(e){
                    return;
                  }
                },
                child: const Text("ADD"))
          ],
        ),
      ));
  void successToast() => Fluttertoast.showToast(msg: "Success", fontSize: 12);
  void errorToast() => Fluttertoast.showToast(
      msg: "Something Went Wrong",
      fontSize: 12,
      backgroundColor: Colors.redAccent);
}
