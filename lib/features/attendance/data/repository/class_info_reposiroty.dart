import 'package:dartz/dartz.dart';
import 'package:attendance_practice/features/attendance/data/datasource/class_info_remote.datasource.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/add_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/delete_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/update_class.model.dart';

class ClassInfoRepository {
  late ClassInfoRemoteDatasource _classInfoRemoteDatasource;

  ClassInfoRepository(ClassInfoRemoteDatasource remoteDatasource) {
    _classInfoRemoteDatasource = remoteDatasource;
  }

  Future<Either<String, String>> addClassInfoRepo(
      AddClassInfoModel addClassInfoModel) async {
    try {
      final result = await _classInfoRemoteDatasource
          .addClassInfo(addClassInfoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateClassInfoRepo(
      UpdateClassInfoModel updateClassInfoModel) async {
    try {
      final result = await _classInfoRemoteDatasource
          .updateClassInfo(updateClassInfoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ClassInfoModel>>> getClassInfoRepo(
      String userId) async {
    try {
      final result = await _classInfoRemoteDatasource.getClassInfo(userId);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> deleteClassInfoRepo(
      DeleteClassInfoModel deleteClassInfoModel) async {
    try {
      final result = await _classInfoRemoteDatasource
          .deleteClassInfo(deleteClassInfoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
