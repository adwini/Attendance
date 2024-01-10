part of 'students_info_bloc.dart';

@immutable
sealed class StudentInfoEvent {}

class AddStudentEvent extends StudentInfoEvent {
  final AddStudentModel addStudentModel;

  AddStudentEvent({required this.addStudentModel});
}

class UpdateStudentEvent extends StudentInfoEvent {
  final UpdateStudentModel updateStudentModel;

  UpdateStudentEvent({
    required this.updateStudentModel,
  });
}

class DeleteStudentEvent extends StudentInfoEvent {
  final DeleteStudentModel deleteStudentModel;

  DeleteStudentEvent({
    required this.deleteStudentModel,
  });
}

class GetStudentEvent extends StudentInfoEvent {
  final String titleID;

  GetStudentEvent({required this.titleID});
}
