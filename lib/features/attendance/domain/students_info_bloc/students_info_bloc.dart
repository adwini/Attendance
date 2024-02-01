import 'package:attendance_practice/features/attendance/domain/models/Students.Model/check_student.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/features/attendance/data/repository/students_info_repository.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/add_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/delete_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/student.model.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/update_student.model.dart';

part 'students_info_event.dart';
part 'students_info_state.dart';

class StudentInfoBloc extends Bloc<StudentInfoEvent, StudentInfoState> {
  StudentInfoBloc(StudentInfoRepository studentInfoRepository)
      : super(StudentInfoState.initial()) {
    on<AddStudentEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await studentInfoRepository.addStudentInfoRepo(event.addStudentModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (addStudent) {
        emit(state.copyWith(isStudentAdded: true));
        emit(state.copyWith(isStudentAdded: false));
        // final currentStudentList = state.studentList;
        // emit(
        //   state.copyWith(
        //       stateStatus: StateStatus.loaded,
        //       studentList: [
        //         ...currentStudentList,
        //         StudentInfoModel(
        //             id: addStudent,
        //             firstName: event.addStudentModel.firstName,
        //             lastName: event.addStudentModel.lastName,
        //             course: event.addStudentModel.course,
        //             year_level: event.addStudentModel.year_level,
        //             date: event.addStudentModel.date),
        //       ],
        //       isEmpty: false),
        // );
      });
    });
    on<GetStudentEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: event.stateStatus));
      final Either<String, List<StudentInfoModel>> result =
          await studentInfoRepository.getStudentsInfoRepo(event.titleID);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (getStudentList) {
        if (getStudentList.isNotEmpty) {
          emit(state.copyWith(
            studentList: getStudentList,
            stateStatus: StateStatus.loaded,
            isUpdated: true,
            isEmpty: false,
          ));
        } else {
          emit(state.copyWith(isEmpty: true, stateStatus: StateStatus.loaded));
        }
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<UpdateStudentEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));

      final Either<String, String> result = await studentInfoRepository
          .updateStudentInfoRepo(event.updateStudentModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (updateStudentList) {
        final currentStudentlist = state.studentList;
        final int index = currentStudentlist.indexWhere(
          (element) => element.id == event.updateStudentModel.id,
        );
        currentStudentlist.replaceRange(
          index,
          index + 1,
          [
            StudentInfoModel(
              id: event.updateStudentModel.id,
              date: event.updateStudentModel.date,
              firstName: event.updateStudentModel.firstName,
              lastName: event.updateStudentModel.lastName,
              course: event.updateStudentModel.course,
              year_level: event.updateStudentModel.year_level,
            ),
          ],
        );
        emit(
          state.copyWith(
            stateStatus: StateStatus.loaded,
            studentList: [
              ...currentStudentlist,
            ],
            isUpdated: true,
          ),
        );
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<DeleteStudentEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result = await studentInfoRepository
          .deleteStudentInfoRepo(event.deleteStudentModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (deleteSuccess) {
        final currentDeleteList = state.studentList;
        currentDeleteList.removeWhere(
            (StudentInfoModel e) => e.id == event.deleteStudentModel.id);
        emit(
          state.copyWith(
              stateStatus: StateStatus.loaded,
              studentList: [
                ...currentDeleteList,
              ],
              isDeleted: true),
        );
        if (currentDeleteList.isEmpty) {
          emit(state.copyWith(isEmpty: true));
        }
        emit(state.copyWith(isDeleted: false));
      });
    });

    on<CheckStudentEvent>((event, emit) async {
      final Either<String, Unit> result =
          await studentInfoRepository.checkStudentRepo(event.checkStudentModel);
      result.fold((error) {
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        emit(state.copyWith(isListUpdated: true));
        emit(state.copyWith(isListUpdated: false));
        // final currentStudentList = state.studentList;
        // final int index = currentStudentList.indexWhere(
        //   (element) => element.id == event.checkStudentModel.id,
        // );
        // final currentStudentModel = currentStudentList[index];
        // currentStudentList.replaceRange(index, index + 1, [
        //   StudentInfoModel(
        //     id: currentStudentModel.id,
        //     date: currentStudentModel.date,
        //     firstName: currentStudentModel.firstName,
        //     lastName: currentStudentModel.lastName,
        //     isPresent: currentStudentModel.isPresent,
        //     course: currentStudentModel.course,
        //     year_level: currentStudentModel.year_level,
        //   ),
        // ]);
        // emit(
        //   state.copyWith(
        //     studentList: [
        //       ...currentStudentList,
        //     ],
        //   ),
        // );
      });
    });
  }
}
