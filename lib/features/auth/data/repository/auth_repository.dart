// ignore_for_file: avoid_print

import 'package:appwrite/models.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_local.datasource.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_remote.datasource.dart';
import 'package:attendance_practice/features/auth/domain/models/auth_user.model.dart';
import 'package:attendance_practice/features/auth/domain/models/login_model.dart';
import 'package:attendance_practice/features/auth/domain/models/register_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepository {
  late AuthRemoteDatasoure _remoteDatasoure;
  late AuthLocalDatasource _authlocalDatasource;

  AuthRepository(
    AuthRemoteDatasoure remoteDatasoure,
    AuthLocalDatasource localDatasource,
  ) {
    _remoteDatasoure = remoteDatasoure;
    _authlocalDatasource = localDatasource;
  }

  Future<Either<String, AuthUserModel>> login(LoginModel loginModel) async {
    try {
      final Session session = await _remoteDatasoure.login(loginModel);

      _authlocalDatasource.saveSessionId(session.$id);

      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel>> register(
      RegisterModel registerModel) async {
    try {
      await _remoteDatasoure.createAccount(registerModel);

      final Session session = await _remoteDatasoure.login(LoginModel(
          email: registerModel.email, password: registerModel.password));

      _authlocalDatasource.saveSessionId(session.$id);

      await _remoteDatasoure.saveAccount(session.userId, registerModel);

      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel?>> autoLogin() async {
    try {
      //Get session id from Local datasource
      final String? sessionId = await _authlocalDatasource.getSessionId();

      //if null return Right(null)
      if (sessionId == null) return const Right(null);

      //else getSession
      final Session session = await _remoteDatasoure.getSessionId(sessionId);

      // should pass user id
      //get User Data
      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      //return Auth User Model
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> logout() async {
    try {
      final String? sessionId = await _authlocalDatasource.getSessionId();

      if (sessionId != null) {
        await _remoteDatasoure.deleteSession(sessionId);
        await _authlocalDatasource.deleteSession();
      }

      return const Right(unit);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }
}
