import 'package:appwrite/appwrite.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/check_student.model.dart';
import 'package:dartz/dartz.dart';
import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/add_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/delete_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/update_student.model.dart';

class StudentInfoRemoteDatasource {
  late Databases _databases;

  StudentInfoRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addStudentInfo(AddStudentModel addStudentModel) async {
    final String studentId = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.studentsId,
      documentId: studentId,
      data: {
        'id': studentId,
        'titleId': addStudentModel.titleId,
        'firstName': addStudentModel.firstName,
        'lastName': addStudentModel.lastName,
        'course': addStudentModel.course,
        'year_level': addStudentModel.year_level,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<StudentInfoModel>> getStudentsInfo(String titleId) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.userdbId,
        collectionId: Config.studentsId,
        queries: [Query.equal('titleId', titleId)]);
    return docs.documents
        .map((e) => StudentInfoModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteStudentInfo(DeleteStudentModel deleteStudentModel) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.studentsId,
      documentId: deleteStudentModel.id,
    );
    return unit;
  }

  Future<String> updateStudentInfo(
      UpdateStudentModel updateStudentModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.studentsId,
        documentId: updateStudentModel.id,
        data: {
          'id': updateStudentModel.id,
          'firstName': updateStudentModel.firstName,
          'lastName': updateStudentModel.lastName,
          'course': updateStudentModel.course,
          'year_level': updateStudentModel.year_level,
          'subjectId': updateStudentModel.id,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }

   Future<String> checkStudentModel(CheckStudentModel checkStudentModel) async {
    final doc = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.studentsId,
        documentId: checkStudentModel.id,
        data: {'id': checkStudentModel.id, 'isPresent': checkStudentModel.isPresent});
    return doc.$id;
  }
}
