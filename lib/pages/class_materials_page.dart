/*
    @author Sidali Fetoumi
    @date 5/12/2022
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stduents_management/model/material.dart';
import 'package:stduents_management/pages/material/material_second_page.dart';

class ClassMaterialsList extends StatefulWidget {
  ClassMaterialsList(this.className, this.appUrl, this.classId);
  final int classId;
  final String appUrl;
  final String className;
  @override
  State<ClassMaterialsList> createState() => _ClassMaterialsListState();
}

class _ClassMaterialsListState extends State<ClassMaterialsList> {
  late Future<List<ClassMaterial>> materials =
      getMaterials(widget.appUrl, widget.classId);
  late TextEditingController controller = TextEditingController();
  void refreshData() async{
    setState(() {
      materials = getMaterials(widget.appUrl,widget.classId);
    });
  }

  @override
  initState(){
    refreshData();
    super.initState();
  }

  static Future<List<ClassMaterial>> getMaterials(appUrl, classId) async {
    // ignore: prefer_const_declarations
    final url = "$appUrl/class/$classId/materials";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<ClassMaterial>(ClassMaterial.fromJson).toList();
  }
  Future createMaterial(String className) async{
    var url = "${widget.appUrl}/material";
    final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },body:
      json.encode({
        "classId":widget.classId,
        "name":className,
      }),
    );
    if(response.statusCode == 201){
      refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.className} Materials")),
      body: FutureBuilder<List<ClassMaterial>>(
        future: materials,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          return buildMaterials(snapshot.data!);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          final materialName = await openDialog();
          if(materialName == null || materialName.isEmpty) return;
          createMaterial(materialName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildMaterials(List<ClassMaterial> materials) => ListView.builder(
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return GestureDetector(
          onTap: () {
            // StudentsList(educationalClass.id, educationalClass.name,widget.appUrl)
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return MaterialSecondPage(widget.appUrl,material.id,material.name);
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
                        Text(material.name,
                            style:
                                const TextStyle(color: Colors.blue, fontSize: 22)),
                        const Icon(Icons.book, color: Colors.red),
                      ]),
                  Text("Lectures: ${material.numberOfLectures}",style: TextStyle(color: Colors.red,fontSize: 17),)
                ],
              ),
            ),
          ),
        );
      });
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Material}"),
        content:TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter Material Name",labelText:"Material Name" ),
          controller:controller,
        ),
        actions: [
          TextButton(
              onPressed:() {
                Navigator.of(context).pop();
                controller.clear();
              },
              child: const Text("CANCEL")),
          TextButton(
              onPressed:(){
                if(controller.text == null || controller.text.isEmpty){
                  return;
                }
                else {
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                }
              },
              child: const Text("CREATE"))
        ],
      ));
}
