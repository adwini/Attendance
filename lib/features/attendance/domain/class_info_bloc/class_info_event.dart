part of 'class_info_bloc.dart';

@immutable
sealed class ClassInfoEvent {}

class AddClassInfoEvent extends ClassInfoEvent {
  final AddClassInfoModel addClassInfoModel;

  AddClassInfoEvent({required this.addClassInfoModel});
}

class UpdateClassInfoEvent extends ClassInfoEvent {
  final UpdateClassInfoModel updateClassInfoModel;

  UpdateClassInfoEvent({required this.updateClassInfoModel});
}

class DeleteClassInfoEvent extends ClassInfoEvent {
  final DeleteClassInfoModel deleteClassInfoModel;

  DeleteClassInfoEvent({required this.deleteClassInfoModel});
}

class GetClassInfoEvent extends ClassInfoEvent {
  final String? userId;
  final StateStatus stateStatus;

  GetClassInfoEvent({
    required this.stateStatus,
    this.userId,
  });
}
