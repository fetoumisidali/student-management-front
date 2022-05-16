/*
    @author Sidali Fetoumi
    @date 5/11/2022
*/
class EducationalClass {
  final int id;
  final String name;
  final int studentsNumber;
  final int numberOfMaterials;
  const EducationalClass({
    required this.id,
    required this.name,
    required this.studentsNumber,
    required this.numberOfMaterials
  });


  static EducationalClass fromJson(json) => EducationalClass(
      id: json['id'],
      name:json['name'],
      studentsNumber: json['studentsNumber'],
      numberOfMaterials:json['numberOfMaterials']
  );

}