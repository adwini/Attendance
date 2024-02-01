// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class UpdateStudentModel {
  final String firstName;
  final String lastName;
  final String course;
  final String year_level;

  final String id;
  final String? date;

  UpdateStudentModel({
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year_level,
    this.date,
    required this.id,
  });
}
