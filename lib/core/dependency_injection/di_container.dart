import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/attendance/domain/students_info_bloc/students_info_bloc.dart';
import 'package:attendance_practice/features/attendance/domain/class_info_bloc/class_info_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_local.datasource.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_remote.datasource.dart';
import 'package:attendance_practice/features/auth/data/repository/auth_repository.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:appwrite/appwrite.dart';
import 'package:attendance_practice/features/attendance/data/datasource/students_info_remote.datesource.dart';
import 'package:attendance_practice/features/attendance/data/datasource/class_info_remote.datasource.dart';
import 'package:attendance_practice/features/attendance/data/repository/students_info_repository.dart';
import 'package:attendance_practice/features/attendance/data/repository/class_info_reposiroty.dart';

class DIContainer {
  ///co
  Client get _client => Client()
      .setEndpoint(Config.endpoint)
      .setProject(Config.projectId)
      .setSelfSigned(status: true);

  Account get _account => Account(_client);

  Databases get _databases => Databases(_client);

  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();

  //Local Datasoure
  AuthLocalDatasource get _authLocalDatasource =>
      AuthLocalDatasource(_secureStorage);
  //Remote Datasoure
  AuthRemoteDatasoure get _authRemoteDatasoure =>
      AuthRemoteDatasoure(_account, _databases);

  //TodoRemoteDatasource
  // TodoRemoteDatasource get _todoRemoteDatasource =>
  //     TodoRemoteDatasource(_databases);

  // Gikan Remote ipasa sa repository
  //GroceryRemoteDatasource
  StudentInfoRemoteDatasource get _studentInfoRemoteDatasource =>
      StudentInfoRemoteDatasource(_databases);

  //titleGrocery
  ClassInfoRemoteDatasource get _classInfoRemoteDatasource =>
      ClassInfoRemoteDatasource(_databases);

  //Repository
  AuthRepository get _authRepository =>
      AuthRepository(_authRemoteDatasoure, _authLocalDatasource);

  //TodoRepository
  // TodoRepository get _todoRepository => TodoRepository(_todoRemoteDatasource);

  //Kuha sa remote pasa adto sa bloc para ma basa ang value
  StudentInfoRepository get _studentInfoRepository =>
      StudentInfoRepository(_studentInfoRemoteDatasource);

  ClassInfoRepository get _classInfoRepository =>
      ClassInfoRepository(_classInfoRemoteDatasource);

  //Bloc
  AuthBloc get authBloc => AuthBloc(_authRepository);

  //TodoBLoc
  // TodoBloc get todoBloc => TodoBloc(_todoRepository);

  StudentInfoBloc get studentInfoBloc => StudentInfoBloc(_studentInfoRepository);

  ClassInfoBloc get classInfoBloc => ClassInfoBloc(_classInfoRepository);
}
