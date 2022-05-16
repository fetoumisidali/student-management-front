import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

/*
    @author Sidali Fetoumi
    @date 5/8/2022
*/
import 'package:flutter/material.dart';
import 'package:stduents_management/pages/student/student_second_page.dart';
import 'package:stduents_management/pages/student_reports_list_page.dart';

import '../model/material.dart';
class StudentMaterialPage extends StatefulWidget {
  StudentMaterialPage(this.firstname,this.lastname,this.studentId,this.className,this.appUrl);
  final String firstname;
  final String lastname;
  final int? studentId;
  final String? className;
  final String appUrl;
  @override
  State<StudentMaterialPage> createState() => _StudentMaterialPageState();
}

class _StudentMaterialPageState extends State<StudentMaterialPage> {

  late Future<List<StudentMaterial>>? materials = getMaterials(widget.appUrl,widget.studentId);

  late TextEditingController controller = TextEditingController();

  Future enrollToLecture(int id) async {
    try {
      var url = "${widget.appUrl}/lecture";
      final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, body:
        json.encode({
          "lectureId": id,
          "studentId": widget.studentId
        }),
      );
      if (response.statusCode == 200) {
            successToast();
        refreshData();
      }
      else {
            errorToast();
      }
    }catch(e){
      errorToast();
    }
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  void refreshData() async{
    setState(() {
      materials = getMaterials(widget.appUrl,widget.studentId);
    });
  }
  static Future<List<StudentMaterial>> getMaterials(appUrl,id) async{
    // ignore: prefer_const_declarations
    final url = "$appUrl/student/$id/materials";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<StudentMaterial>(StudentMaterial.fromJson).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("${widget.firstname} ${widget.lastname}"),
      actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return StudentSecondPage(widget.appUrl,widget.studentId,widget.firstname,widget.lastname);
          }));
        }, icon: Icon(Icons.person)),
        const SizedBox(width: 5,)
      ],),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Class",style: TextStyle(color: Colors.red,fontSize: 26)),
                    Text("${widget.className}",style: TextStyle(color: Colors.black54,fontSize: 22),)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 450,
              child: FutureBuilder<List<StudentMaterial>>(
                future: materials,
                builder:(ctx,snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text("${snapshot.error}"));
                  }
                  if(!snapshot.hasData){
                    return const Center(child: Text("Loading..."));
                  }
                  return buildMaterial(snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final id = await openDialog();
          if(id == null || id <= 0) return;
          enrollToLecture(id);
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
  Widget buildMaterial(List<StudentMaterial> materials) => ListView.builder(
      itemCount: materials.length,
      itemBuilder: (context,index){
        final material = materials[index];
        return Card(
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
                    Text(material.materialName, style: const TextStyle(color: Colors.blue, fontSize: 36)),
                    const Icon(Icons.book,color: Colors.red)
                  ],
                ),
                const SizedBox(height: 5),
                Text("Presence : ${material.presentCount}",
                    style: const TextStyle(fontSize: 26, color: Colors.redAccent))
              ],
            ),
          ),
        );
      });
  Future<int?> openDialog() => showDialog<int>(
  context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enroll to lecture"),
        content:TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter lecture id",labelText:"lecture id" ),
          controller:controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
              onPressed:() {
                Navigator.of(context).pop();
                controller.clear();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed:(){
                    try{
                      int id = int.parse(controller.text);
                      if(id <= 0 || controller.text.isEmpty){
                        return;
                      }
                      Navigator.of(context).pop(id);
                      controller.clear();
                    }
                    catch (error){
                      return;
                    }
                  },
              child: const Text("Enroll"))
        ],
      ));
  void successToast() => Fluttertoast.showToast(msg: "Success", fontSize: 12);
  void errorToast() => Fluttertoast.showToast(
      msg: "Something Went Wrong",
      fontSize: 12,
      backgroundColor: Colors.redAccent);
}
