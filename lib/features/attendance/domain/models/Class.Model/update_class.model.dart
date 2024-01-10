// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateClassInfoModel {
  final String id;
  final String title;
  final String subjectCode;
  String? updatedAt;
  UpdateClassInfoModel({
    required this.id,
    required this.title,
    required this.subjectCode,
    this.updatedAt,
  });
}
