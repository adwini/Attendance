import 'package:attendance_practice/core/components/background_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/attendance/domain/students_info_bloc/students_info_bloc.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/add_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/delete_student.model.dart';
import 'package:attendance_practice/features/attendance/domain/class_info_bloc/class_info_bloc.dart';
import 'package:attendance_practice/features/attendance/presentation/update_student_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, required this.classInfoModel});
  final ClassInfoModel classInfoModel;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late StudentInfoBloc _studentInfoBloc;

  late ClassInfoBloc _classInfoBloc;

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _yrLvl = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String studentId;
  late String classInfo;

  @override
  void initState() {
    super.initState();
    //get ID from groceryTitleModel
    studentId = widget.classInfoModel.id;

    _classInfoBloc = BlocProvider.of<ClassInfoBloc>(context);
    _classInfoBloc.add(GetClassInfoEvent(userId: studentId));

    //kani gi gamit para sa title kay di makita ang value sa id ingani-on kani pasabot sa ubos
    classInfo = widget.classInfoModel.title;

    _studentInfoBloc = BlocProvider.of<StudentInfoBloc>(context);
    _studentInfoBloc.add(GetStudentEvent(titleID: studentId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassInfoBloc, ClassInfoState>(
      bloc: _classInfoBloc,
      listener: _classInfoListener,
      builder: (context, state) {
        //kani pasabot sa babaw
        // final title =
        //     state.titleGroceryList.where((e) => e.id == groceryId).first.title;
        if (state.stateStatus == StateStatus.loading) {
          return Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.isUpdated) {
          Navigator.pop(context);
          SnackBarUtils.defualtSnackBar(
              'Student successfully updated!', context);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 60.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 0.00,
            titleTextStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            title: Text(
              '$classInfo Students',
              style: GoogleFonts.kanit(fontSize: 23.0),
            ),
          ),
          body: BackgroundHome(
            child: BlocConsumer<StudentInfoBloc, StudentInfoState>(
              listener: _studentListener,
              builder: (context, studentState) {
                if (studentState.stateStatus == StateStatus.loading) {
                  return Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (studentState.isEmpty) {
                  return SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Image.asset(
                          "assets/images/emptyOrange.png",
                        ),
                      ),
                    ),
                  );
                }
                if (studentState.isDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () {
                    _studentInfoBloc.add(GetStudentEvent(titleID: studentId));

                    return Future<void>.delayed(
                        const Duration(milliseconds: 1));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    itemCount: studentState.studentList.length,
                    itemBuilder: (context, index) {
                      final studentList = studentState.studentList[index];

                      // String titleDate = studentList.createdAt!;
                      // String formattedDate = DateFormat('EEE, M/d/y')
                      //     .format(DateTime.parse(titleDate));

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete ${studentList.lastName}?'),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        _deleteStudent(context, studentList.id);
                                      },
                                      child: const Text('Delete')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'))
                                ],
                              );
                            },
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.delete), Text('Delete')],
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: _studentInfoBloc,
                                  child: UpdateStudentInfoPage(
                                    studentInfoModel: studentList,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 4,
                              // color: Colors.white60,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${studentList.firstName} ${studentList.lastName}',
                                  style: GoogleFonts.kanit(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  "${studentList.course} ${studentList.year_level} ",
                                  style: GoogleFonts.kanit(fontSize: 18.0),
                                ),

                                // trailing: Checkbox(
                                //     value: studentList.isPresent,
                                //     onChanged: (bool? newIsChecked) {
                                //       _checkListener(
                                //           context, item.id, newIsChecked ?? false);
                                //     }),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              _displayAddDialog(context);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
  // void _checkListener(BuildContext context, String id, bool isPresent) {
  //   _studentInfoBloc.add(
  //     AddStudentEvent(
  //       addStudentModel: AddStudentModel(
  //         titleId: id,
  //         isPresent: isChecked,
  //       ),
  //     ),
  //   );
  // }

  //TODO: Check the student if present or not using checkbox and add listener
  void _addStudent(BuildContext context) {
    _studentInfoBloc.add(AddStudentEvent(
        addStudentModel: AddStudentModel(
            titleId: studentId,
            firstName: _firstName.text,
            lastName: _lastName.text,
            gender: _gender.text,
            course: _course.text,
            year_level: _yrLvl.text)));
  }

  void _studentListener(
      BuildContext context, StudentInfoState studentInfoState) {
    if (studentInfoState.stateStatus == StateStatus.error) {
      Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
      SnackBarUtils.defualtSnackBar(studentInfoState.errorMessage, context);
    }
  }

  void _classInfoListener(BuildContext context, ClassInfoState classInfoState) {
    if (classInfoState.stateStatus == StateStatus.error) {
      Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
      SnackBarUtils.defualtSnackBar(classInfoState.errorMessage, context);
    }
  }

  Future _displayAddDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            scrollable: true,
            title: const Text('Add Attendance'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'First Name');
                    },
                    controller: _firstName,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Last Name');
                    },
                    controller: _lastName,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Degree Program');
                    },
                    controller: _course,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: 'Degree Program'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Year Level');
                    },
                    controller: _yrLvl,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Year Level'),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textColor,
                ),
                child: const Text('ADD'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addStudent(context);
                    Navigator.of(context).pop();
                    _firstName.clear();
                    _lastName.clear();
                    _gender.clear();
                    _yrLvl.clear();
                    _course.clear();
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textColor,
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, String id) {
    _studentInfoBloc.add(
        DeleteStudentEvent(deleteStudentModel: DeleteStudentModel(id: id)));
    Navigator.of(context).pop();
  }
}
