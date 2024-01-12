import 'package:attendance_practice/features/attendance/domain/models/Students.Model/check_student.model.dart';
import 'package:dartz/dartz.dart';
import 'package:attendance_practice/features/attendance/data/datasource/students_info_remote.datesource.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/add_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/delete_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/update_student.model.dart';

class StudentInfoRepository {
  late StudentInfoRemoteDatasource _studentInfoRemoteDatasource;

  StudentInfoRepository(
    StudentInfoRemoteDatasource remoteDatasource,
  ) {
    _studentInfoRemoteDatasource = remoteDatasource;
  }

  Future<Either<String, String>> addStudentInfoRepo(
      AddStudentModel addStudentModel) async {
    try {
      final result =
          await _studentInfoRemoteDatasource.addStudentInfo(addStudentModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateStudentInfoRepo(
      UpdateStudentModel updateStudentModel) async {
    try {
      final result =
          await _studentInfoRemoteDatasource.updateStudentInfo(updateStudentModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<StudentInfoModel>>> getStudentsInfoRepo(
      String titleId) async {
    try {
      final result = await _studentInfoRemoteDatasource.getStudentsInfo(titleId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> deleteStudentInfoRepo(
      DeleteStudentModel deleteStudentModel) async {
    try {
      final result = await _studentInfoRemoteDatasource.deleteStudentInfo(
        deleteStudentModel,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

    Future<Either<String, Unit>> checkStudentRepo(
      CheckStudentModel checkStudentModel) async {
    try {
      await _studentInfoRemoteDatasource.checkStudentModel(checkStudentModel);

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
