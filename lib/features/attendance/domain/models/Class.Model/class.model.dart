// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassInfoModel {
  final String id;
  final String title;
  final String subjectCode;
  String? createdAt;
  ClassInfoModel({
    required this.id,
    required this.title,
    required this.subjectCode,
    this.createdAt,
  });

  factory ClassInfoModel.fromJson(Map<String, dynamic> map) {
    return ClassInfoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subjectCode: map['subjectCode'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }
}
