/*
    @author Sidali Fetoumi
    @date 5/8/2022
*/
class StudentMaterial{

  final int materialId;
  final String materialName;
  final int presentCount;

  const StudentMaterial({
    required this.materialId,
    required this.materialName,
    required this.presentCount,
});
  static StudentMaterial fromJson(json) => StudentMaterial(
      materialId: json['materialId'],
      materialName: json['materialName'],
      presentCount:json['presentCount']
  );
}
class ClassMaterial{
  final int id;
  final String name;
  final int numberOfLectures;
  const ClassMaterial({
    required this.id,
    required this.name,
    required this.numberOfLectures
});
  static ClassMaterial fromJson(json) => ClassMaterial(
    id:json['id'],
    name:json['name'],
      numberOfLectures:json['numberOfLectures']
  );
}