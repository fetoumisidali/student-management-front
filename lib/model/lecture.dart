/*
    @author Sidali Fetoumi
    @date 5/13/2022
*/
import 'package:flutter/material.dart';

class MaterialLecture {
  final String startsDate;
  final int presentStudentsNumber;
  final int id;

  MaterialLecture(
      {required this.startsDate, required this.presentStudentsNumber,required this.id});
  static MaterialLecture fromJson(json) => MaterialLecture(
        startsDate: json['startsDate'],
        presentStudentsNumber: json['presentStudentsNumber'],
    id:json['id']

      );
}
