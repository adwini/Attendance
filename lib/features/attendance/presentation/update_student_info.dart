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

class UpdateStudentInfoPage extends StatefulWidget {
  const UpdateStudentInfoPage({super.key, required this.studentInfoModel});
  final StudentInfoModel studentInfoModel;

  @override
  State<UpdateStudentInfoPage> createState() => _UpdateStudentInfoPageState();
}

class _UpdateStudentInfoPageState extends State<UpdateStudentInfoPage> {
  late String _updateStudentId;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _yrLvl = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _course = TextEditingController();
  late StudentInfoBloc _studentInfoBloc;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _studentInfoBloc = BlocProvider.of<StudentInfoBloc>(context);
    widget.studentInfoModel;

    _updateStudentId = widget.studentInfoModel.id;
    // _updateProductName =
    //     TextEditingController(text: widget.groceryItemModel.productName);
    // _updateQuantity =
    //     TextEditingController(text: widget.groceryItemModel.quantity);
    // _updatePrice = TextEditingController(text: widget.groceryItemModel.price);
  }

  @override
  Widget build(BuildContext context) {
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

        leading: const SizedBox(
          height: 10,
          width: 10,
        ),
        // title: const Text('Update Grocery Items'),
      ),
      body: BackgroundHome(
        child: BlocConsumer<StudentInfoBloc, StudentInfoState>(
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
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: SizedBox(
                          width: 10,
                          height: 60,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40),
                          //     border: Border.all(color: Colors.blueGrey)),
                          // child: Image.asset('assets/logo.png'),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Update Student Details',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'First Name');
                        },
                        controller: _firstName,
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal()),
                            labelText: 'First Name'),
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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal()),
                            labelText: 'Last Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'Course');
                        },
                        controller: _course,
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal()),
                            labelText: 'Course'),
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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal()),
                            labelText: 'Year Level'),
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
                                    foregroundColor: textColor),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _updateStudent(context);
                                  }
                                },
                                child: const Text('Update')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: textColor),
                                onPressed: () {
                                  _updateStudent(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
            id: _updateStudentId,
            firstName: _firstName.text,
            lastName: _lastName.text,
            gender: _gender.text,
            course: _course.text,
            year_level: _yrLvl.text),
      ),
    );
  }
}
