/*
    @author Sidali Fetoumi
    @date 5/11/2022
*/
import 'package:flutter/material.dart';
class Student {
  final int? id;
  final String firstname;
  final String lastname;
  Student({
    this.id,
    required this.firstname,
    required this.lastname,
});
  static Student fromJson(json) => Student(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
  );
}
class StudentMaterialPresense{
  final int presenseNumber;
  final String studentFirstname;
  final String studentLastName;
  final int studentId;
  StudentMaterialPresense({
    required this.presenseNumber,
    required this.studentFirstname,
    required this.studentLastName,
    required this.studentId,
  });
  static StudentMaterialPresense fromJson(json) => StudentMaterialPresense(
      presenseNumber: json['presenseNumber'],
      studentFirstname: json['studentFirstname'],
      studentLastName: json['studentLastName'],
    studentId: json['studentId']
  );
}
class StudentReport{
  final String materialName;
  final String title;
  final String date;

  StudentReport({
    required this.materialName,
    required this.title,
    required this.date
});
  static StudentReport fromJson(json) => StudentReport(
    materialName: json['materialName'],
    title: json['title'],
    date: json['date']
  );
}
class StudentNote{
  final String materialName;
  final String noteType;
  final double note;

  StudentNote({
    required this.materialName,
    required this.noteType,
    required this.note
  });
  static StudentNote fromJson(json) => StudentNote(
      materialName: json['materialName'],
      noteType: json['noteType'],
      note: json['note']
  );
}