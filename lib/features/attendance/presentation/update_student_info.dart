import 'package:attendance_practice/core/components/background_home.dart';
import 'package:attendance_practice/features/attendance/domain/students_info_bloc/students_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/student.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Students.Model/update_student.model.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateStudentInfoPage extends StatefulWidget {
  const UpdateStudentInfoPage({super.key, required this.studentInfoModel});
  final StudentInfoModel studentInfoModel;

  @override
  State<UpdateStudentInfoPage> createState() => _UpdateStudentInfoPageState();
}

class _UpdateStudentInfoPageState extends State<UpdateStudentInfoPage> {
  late StudentInfoBloc _studentInfoBloc;

  late String _studentIdController;

  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _yrLvl;
  late TextEditingController _course;

  final degreeList = ["BSCS", "BSIT", "BSBA", "BSA", "BSHM"];
  final yearList = ["1st Year", "2nd Year", "3rd Year", "4th Year"];

  // ignore: unused_field
  late String _updatedAt;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _studentInfoBloc = BlocProvider.of<StudentInfoBloc>(context);
    _firstName = TextEditingController(text: widget.studentInfoModel.firstName);
    _lastName = TextEditingController(text: widget.studentInfoModel.lastName);
    _yrLvl = TextEditingController(text: widget.studentInfoModel.year_level);
    _course = TextEditingController(text: widget.studentInfoModel.course);

    _studentIdController = widget.studentInfoModel.id;
    _updatedAt = widget.studentInfoModel.createdAt ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentInfoBloc, StudentInfoState>(
      bloc: _studentInfoBloc,
      listener: _studentListener,
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: BackgroundHome(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white30,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "EDIT STUDENT",
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.libreBaskerville().fontFamily,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2661FA)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 15, left: 15, bottom: 10),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return Guard.againstEmptyString(
                                    val, 'First name');
                              },
                              controller: _firstName,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'First name',
                                  labelStyle: GoogleFonts.dmSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 10, left: 15, bottom: 10),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return Guard.againstEmptyString(
                                    val, 'Last name');
                              },
                              controller: _lastName,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Last name',
                                  labelStyle: GoogleFonts.dmSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 10, left: 15, bottom: 10),
                            child: DropdownButtonFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  labelText: 'Degree Program',
                                  labelStyle: GoogleFonts.dmSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                              value: _course.text,
                              items: degreeList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _course.text = val as String;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 10, left: 15, bottom: 10),
                            child: DropdownButtonFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  labelText: 'Year Level',
                                  labelStyle: GoogleFonts.dmSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                              value: _yrLvl.text,
                              items: yearList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _yrLvl.text = val as String;
                                });
                              },
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: textColor,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _updateStudent(context);
                                        }
                                      },
                                      child: Text('Update',
                                          style: GoogleFonts.dmSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: textColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel',
                                          style: GoogleFonts.dmSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _studentListener(BuildContext context, StudentInfoState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
      return;
    }

    if (state.isUpdated) {
      Navigator.pop(context);
      SnackBarUtils.defualtSnackBar(' Successfully updated!', context);
      return;
    }
  }

  void _updateStudent(BuildContext context) {
    _studentInfoBloc.add(
      UpdateStudentEvent(
        updateStudentModel: UpdateStudentModel(
           
            id: _studentIdController,
            firstName: _firstName.text,
            lastName: _lastName.text,
            course: _course.text,
            year_level: _yrLvl.text),
      ),
    );
  }
}
