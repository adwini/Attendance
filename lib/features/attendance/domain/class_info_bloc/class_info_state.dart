// ignore_for_file: prefer_const_constructors_in_immutables

part of 'class_info_bloc.dart';

@immutable
class ClassInfoState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final List<ClassInfoModel> classList;
  final bool isEmpty;
  final bool isUpdated;
  final bool isDeleted;
  final bool isClassAdded;

  ClassInfoState(
      {required this.stateStatus,
      this.errorMessage,
      required this.classList,
      required this.isEmpty,
      required this.isUpdated,
      required this.isDeleted,
      required this.isClassAdded});

  factory ClassInfoState.initial() => ClassInfoState(
      stateStatus: StateStatus.initial,
      classList: const [],
      isEmpty: false,
      isUpdated: false,
      isDeleted: false,
      isClassAdded: false);

  ClassInfoState copyWith(
      {StateStatus? stateStatus,
      String? errorMessage,
      List<ClassInfoModel>? classList,
      bool? isEmpty,
      bool? isUpdated,
      bool? isDeleted,
      bool? isClassAdded}) {
    return ClassInfoState(
        stateStatus: stateStatus ?? this.stateStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        classList: classList ?? this.classList,
        isEmpty: isEmpty ?? this.isEmpty,
        isUpdated: isUpdated ?? this.isUpdated,
        isDeleted: isDeleted ?? this.isDeleted,
        isClassAdded: isClassAdded ?? this.isClassAdded);
  }
}
