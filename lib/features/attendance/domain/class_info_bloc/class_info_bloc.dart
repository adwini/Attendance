import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/features/attendance/data/repository/class_info_reposiroty.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/add_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/delete_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/update_class.model.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'class_info_event.dart';
part 'class_info_state.dart';

class ClassInfoBloc extends Bloc<ClassInfoEvent, ClassInfoState> {
  ClassInfoBloc(ClassInfoRepository classInfoRepository)
      : super(ClassInfoState.initial()) {
    on<AddClassInfoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await classInfoRepository.addClassInfoRepo(event.addClassInfoModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (addClassInfo) {
        emit(state.copyWith(isClassAdded: true));
        emit(state.copyWith(isClassAdded: false));

        // final currentClassList = state.classList;
        // emit(state.copyWith(
        //   stateStatus: StateStatus.loaded,
        //   classList: [
        //     ...currentClassList,
        //     ClassInfoModel(
        //       id: addClassInfo,
        //       //give data to GroceryTitleModel => createdAt variable

        //       createdAt: DateTime.timestamp().toIso8601String(),
        //       title: event.addClassInfoModel.title,
        //       subjectCode: event.addClassInfoModel.subjectCode,
        //     ),
        //   ],
        //   isEmpty: false,
        // ));
      });
    });
    on<GetClassInfoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<ClassInfoModel>> result =
          await classInfoRepository.getClassInfoRepo(event.userId!);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (getClassInfoList) {
        if (getClassInfoList.isNotEmpty) {
          emit(state.copyWith(
            classList: getClassInfoList,
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

    on<UpdateClassInfoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result = await classInfoRepository
          .updateClassInfoRepo(event.updateClassInfoModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (updateClassInfoList) {
        final currentClassInfoList = state.classList;
        final int index = currentClassInfoList.indexWhere(
          (element) => element.id == event.updateClassInfoModel.id,
        );
        final currentTitleGroceryModel = currentClassInfoList[index];
        currentClassInfoList.replaceRange(
          index,
          index + 1,
          [
            ClassInfoModel(
              id: currentTitleGroceryModel.id,
              createdAt: event.updateClassInfoModel.updatedAt,
              title: event.updateClassInfoModel.title,
              subjectCode: event.updateClassInfoModel.subjectCode,
            )
          ],
        );
        emit(state.copyWith(
            stateStatus: StateStatus.loaded,
            classList: [
              ...currentClassInfoList,
            ],
            isUpdated: true));
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<DeleteClassInfoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result = await classInfoRepository
          .deleteClassInfoRepo(event.deleteClassInfoModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (deleteClassInfolist) {
        final currentClassInfoList = state.classList;
        currentClassInfoList.removeWhere(
            (ClassInfoModel e) => e.id == event.deleteClassInfoModel.id);
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          classList: [
            ...currentClassInfoList,
          ],
          isUpdated: true,
          isDeleted: true,
        ));
        if (currentClassInfoList.isEmpty) {
          emit(state.copyWith(isEmpty: true));
        }
        emit(state.copyWith(isUpdated: false, isDeleted: false));
      });
    });
  }
}
