import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/update_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/add_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/delete_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/class.model.dart';

class ClassInfoRemoteDatasource {
  late Databases _databases;

  ClassInfoRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addClassInfo(AddClassInfoModel addClassInfoModel) async {
    final String subjectTitle = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.classInfoId,
      documentId: subjectTitle,
      data: {
        'id': subjectTitle,
        'title': addClassInfoModel.title,
        'subjectCode': addClassInfoModel.subjectCode,
        'userId': addClassInfoModel.userId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<ClassInfoModel>> getClassInfo(String userId) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.userdbId,
        collectionId: Config.classInfoId,
        queries: [Query.equal('userId', userId)]);

    return docs.documents
        .map((e) => ClassInfoModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteClassInfo(
      DeleteClassInfoModel deleteSubjectTitleModel) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.classInfoId,
      documentId: deleteSubjectTitleModel.id,
    );
    return unit;
  }

  Future<String> updateClassInfo(
      UpdateClassInfoModel updateTitleSubjectModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.classInfoId,
        documentId: updateTitleSubjectModel.id,
        data: {
          'id': updateTitleSubjectModel.id,
          'title': updateTitleSubjectModel.title,
          'subjectCode': updateTitleSubjectModel.subjectCode,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }
}
