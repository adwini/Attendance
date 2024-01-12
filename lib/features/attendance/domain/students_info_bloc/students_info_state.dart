// ignore_for_file: prefer_const_constructors_in_immutables

part of 'students_info_bloc.dart';

@immutable
class StudentInfoState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final List<StudentInfoModel> studentList;
  final bool isEmpty;
  final bool isUpdated;
  final bool isDeleted;

  StudentInfoState({
    required this.studentList,
    this.errorMessage,
    required this.stateStatus,
    required this.isEmpty,
    required this.isUpdated,
    required this.isDeleted,
  });

  factory StudentInfoState.initial() => StudentInfoState(
        studentList: const [],
        stateStatus: StateStatus.initial,
        isEmpty: false,
        isUpdated: false,
        isDeleted: false,
      );

  StudentInfoState copyWith({
    List<StudentInfoModel>? studentList,
    StateStatus? stateStatus,
    String? errorMessage,
    bool? isEmpty,
    bool? isUpdated,
    bool? isDeleted,
  }) {
    return StudentInfoState(
      studentList: studentList ?? this.studentList,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmpty: isEmpty ?? this.isEmpty,
      isUpdated: isUpdated ?? this.isUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
  
}
