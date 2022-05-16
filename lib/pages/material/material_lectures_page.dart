/*
    @author Sidali Fetoumi
    @date 5/12/2022
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../model/lecture.dart';
class MaterialLecturesPage extends StatefulWidget {
  const MaterialLecturesPage(this.appUrl,this.materialName,this.materialId);
  final String appUrl;
  final String materialName;
  final int materialId;

  @override
  State<MaterialLecturesPage> createState() => _MaterialLecturesPageState();
}

class _MaterialLecturesPageState extends State<MaterialLecturesPage> {

  late Future<List<MaterialLecture>> materialLectures =
  getMaterialLectures(widget.appUrl, widget.materialId);
  void refreshData() async{
    setState(() {
      materialLectures = getMaterialLectures(widget.appUrl,widget.materialId);
    });
  }

  @override
  initState(){
    refreshData();
    super.initState();
  }
  Future createLecture(int materialId) async{
    try{
      var url = "${widget.appUrl}/lecture/create/${materialId}";
      final http.Response response = await http.post(Uri.parse(url));
      if(response.statusCode == 201){
        successToast();
        refreshData();
      }
      else{
        errorToast();
      }
    }catch(e){
      errorToast();
    }

    }

  static Future<List<MaterialLecture>> getMaterialLectures(appUrl, materialId) async {
    // ignore: prefer_const_declarations
    final url = "$appUrl/material/$materialId/lectures";
    final response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    return body.map<MaterialLecture>(MaterialLecture.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.materialName} Lectures")),
      body: FutureBuilder<List<MaterialLecture>>(
        future: materialLectures,
        builder:(ctx,snapshot){
          if(snapshot.hasError){
            return Center(child: Text("${snapshot.error}"));
          }
          if(!snapshot.hasData){
            return const Center(child: Text("Loading..."));
          }
          return buildMaterialLectures(snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final create = await openDialog();
          if(create == null) return;
          createLecture(widget.materialId);
        },
      ),
    );

  }
  Widget buildMaterialLectures(List<MaterialLecture> materialLectures) => ListView.builder(
      itemCount: materialLectures.length,
      itemBuilder: (context,index){
        final materialLecture = materialLectures[index];
        return GestureDetector(
          onTap: (){
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
                      Text(materialLecture.startsDate, style: const TextStyle(color: Colors.blue, fontSize: 18)),
                      const Icon(Icons.watch
                          ,color: Colors.red)
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("P : ${materialLecture.presentStudentsNumber}",
                      style: const TextStyle(fontSize: 26, color: Colors.redAccent)),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ID: ${materialLecture.id}",style: TextStyle(fontSize: 20),),
                      Icon(Icons.key)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
  Future<bool?> openDialog() => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("CREATE LECTURE"),
        content:Text("YOU WANT TO CREATE A LECTURE ?"),
        actions: [
          TextButton(
              onPressed:() {
                Navigator.of(context).pop();
              },
              child: const Text("NO")),
          TextButton(
              onPressed:(){
                Navigator.of(context).pop(true);
              },
              child: const Text("YES"))
        ],
      ));
  void successToast() => Fluttertoast.showToast(msg: "Success", fontSize: 12);
  void errorToast() => Fluttertoast.showToast(
      msg: "Something Went Wrong",
      fontSize: 12,
      backgroundColor: Colors.redAccent);
}
