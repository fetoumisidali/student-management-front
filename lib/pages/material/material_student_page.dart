/*
    @author Sidali Fetoumi
    @date 5/12/2022
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stduents_management/pages/material/material_report_page.dart';
import 'package:stduents_management/pages/material/material_student_second_page.dart';

import '../../model/student.dart';

class MaterialStudentsPage extends StatefulWidget {
  MaterialStudentsPage(this.appUrl,this.materialId,this.materialName);
  final int materialId;
  final String materialName;
  final String appUrl;


  @override
  State<MaterialStudentsPage> createState() => _MaterialStudentsPageState();
}

class _MaterialStudentsPageState extends State<MaterialStudentsPage> {
  @override
  initState() {
    refreshData();
    super.initState();
  }
  void refreshData() async {
    setState(() {
      materialsPresense = getMaterialsPrsense(widget.appUrl, widget.materialId);
    });
  }

  late Future<List<StudentMaterialPresense>>? materialsPresense = getMaterialsPrsense(widget.appUrl,widget.materialId);
  static Future<List<StudentMaterialPresense>> getMaterialsPrsense(appUrl,materialId) async{
    // ignore: prefer_const_declarations
    final url = "$appUrl/material/$materialId/students";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<StudentMaterialPresense>(StudentMaterialPresense.fromJson).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("${widget.materialName} Students")),
      body: FutureBuilder<List<StudentMaterialPresense>>(
        future: materialsPresense,
        builder:(ctx,snapshot){
          if(snapshot.hasError){
            return Center(child: Text("${snapshot.error}"));
          }
          if(!snapshot.hasData){
            return const Center(child: Text("Loading..."));
          }
          return buildMaterialPresense(snapshot.data!);
        },
      ),
    );
  }
  Widget buildMaterialPresense(List<StudentMaterialPresense> materialsPresense) => ListView.builder(
      itemCount: materialsPresense.length,
      itemBuilder: (context,index){
        final materialPresense = materialsPresense[index];
        return GestureDetector(
          onTap: () {
            // StudentsList(educationalClass.id, educationalClass.name,widget.appUrl)
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return MaterialStudentSecondPage(materialPresense.studentFirstname,
                  materialPresense.studentLastName,widget.appUrl,
                  widget.materialId, materialPresense.studentId);
            }));
          },
          child: Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${materialPresense.studentFirstname} ${materialPresense.studentLastName}", style: const TextStyle(color: Colors.blue, fontSize: 36)),
                      const Icon(Icons.person,color: Colors.red)
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("Presence : ${materialPresense.presenseNumber}",
                      style: const TextStyle(fontSize: 26, color: Colors.redAccent))
                ],
              ),
            ),
          ),
        );
      });
}
