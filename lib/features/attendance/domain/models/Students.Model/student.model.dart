// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class StudentInfoModel {
  final String id;
  final String firstName;
  final String lastName;
  final String course;
  final String year_level;
  final String? titleId;
  final String? date;

  bool isPresent;
  String? createdAt;

  StudentInfoModel(
      {this.isPresent = false,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.course,
      this.titleId,
      required this.year_level,
      this.createdAt,
       this.date});
  factory StudentInfoModel.fromJson(Map<String, dynamic> json) {
    return StudentInfoModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        course: json['course'],
        isPresent: json['isPresent'],
        year_level: json['year_level'],
        titleId: json['titleId'],
        createdAt: json['createdAt'],
        date: json['date']);
  }
}
