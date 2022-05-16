/*
    @author Sidali Fetoumi
    @date 5/11/2022
*/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stduents_management/model/educationalClass.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stduents_management/pages/class_materials_page.dart';
import 'package:stduents_management/pages/class_second_page.dart';
import 'package:stduents_management/pages/students_list_page.dart';

class ClassList extends StatefulWidget {
  ClassList(this.appUrl);
  String appUrl;

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  late Future<List<EducationalClass>> educationalClasses =
      getClasses(widget.appUrl);
  late TextEditingController controller = TextEditingController();

  void refreshData() async {
    setState(() {
      educationalClasses = getClasses(widget.appUrl);
    });
  }

  @override
  initState() {
    refreshData();
    super.initState();
  }

  static Future<List<EducationalClass>> getClasses(appUrl) async {
    String url = "$appUrl/class";
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body.map<EducationalClass>(EducationalClass.fromJson).toList();
  }

  Future createClass(String className) async {
    try {
      var url = "${widget.appUrl}/class";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "name": className,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
        actions: [
          IconButton(onPressed: refreshData, icon: const Icon(Icons.replay))
        ],
      ),
      body: FutureBuilder<List<EducationalClass>>(
        future: educationalClasses,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          return buildClass(snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final className = await openDialog();
          if (className == null || className.isEmpty) return;
          createClass(className);
        },
      ),
    );
  }

  Widget buildClass(List<EducationalClass> educationalClasses) =>
      ListView.builder(
          itemCount: educationalClasses.length,
          itemBuilder: (context, index) {
            final educationalClass = educationalClasses[index];
            return GestureDetector(
              onTap: () {
                // StudentsList(educationalClass.id, educationalClass.name,widget.appUrl)
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ClassSecondPage(educationalClass.id,
                      educationalClass.name, widget.appUrl);
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
                          Text(educationalClass.name,
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 36)),
                          const Icon(Icons.class__outlined, color: Colors.red)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("S: ${educationalClass.studentsNumber}",
                              style: const TextStyle(
                                  fontSize: 26, color: Colors.redAccent)),
                          SizedBox(width: 20),
                          Text("M: ${educationalClass.numberOfMaterials}",
                              style: const TextStyle(
                                  fontSize: 26, color: Colors.redAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Create New Class"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "Enter Class Name", labelText: "Class Name"),
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
