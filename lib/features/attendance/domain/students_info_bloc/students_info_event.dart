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

class CheckStudentEvent extends StudentInfoEvent {
  final CheckStudentModel checkStudentModel;

  CheckStudentEvent({required this.checkStudentModel});
}

class GetStudentEvent extends StudentInfoEvent {
  final String titleID;
  final StateStatus stateStatus;

  GetStudentEvent({required this.titleID, required this.stateStatus});
}
