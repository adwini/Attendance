import 'package:attendance_practice/core/components/background_home.dart';
import 'package:attendance_practice/features/attendance/domain/class_info_bloc/class_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/update_class.model.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateClassInfoPage extends StatefulWidget {
  const UpdateClassInfoPage({super.key, required this.classInfoModel});
  final ClassInfoModel classInfoModel;

  @override
  State<UpdateClassInfoPage> createState() => _UpdateClassInfoPageState();
}

class _UpdateClassInfoPageState extends State<UpdateClassInfoPage> {
  late ClassInfoBloc _classInfoBloc;

  late String _titleIDController;

  late TextEditingController _classInfo;
  late TextEditingController _subjectCode;

  late String _updatedAt;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _classInfoBloc = BlocProvider.of<ClassInfoBloc>(context);
    _subjectCode =
        TextEditingController(text: widget.classInfoModel.subjectCode);

    _classInfo = TextEditingController(text: widget.classInfoModel.title);

    _titleIDController = widget.classInfoModel.id;
    _updatedAt = widget.classInfoModel.createdAt!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassInfoBloc, ClassInfoState>(
      bloc: _classInfoBloc,
      listener: _updateClassListener,
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
          // appBar: AppBar(
          //   backgroundColor: primaryColor,
          //   titleSpacing: 00.0,
          //   centerTitle: true,
          //   toolbarHeight: 60.2,
          //   toolbarOpacity: 0.8,
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         bottomRight: Radius.circular(25),
          //         bottomLeft: Radius.circular(25)),
          //   ),
          //   elevation: 0.00,
          //   titleTextStyle: const TextStyle(
          //       fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          //   leading: const SizedBox(
          //     height: 10,
          //     width: 10,
          //   ),
          //   title: const Text('Update Subject'),
          // ),
          body: BackgroundHome(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.only(top: 70),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 15, top: 90, left: 15, bottom: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'Subject');
                        },
                        controller: _classInfo,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Subject name',
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'Subject Code');
                        },
                        controller: _subjectCode,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Subject Code',
                            labelStyle: GoogleFonts.dmSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic)),
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
                                    _updateClassInfo(context);
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
        );
      },
    );
  }

  void _updateClassListener(BuildContext context, ClassInfoState state) {
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

//update is working but when Navigator.pop(context) is compiled
//it gets an error, *Unexpected Null value*
//without telling what file is getting null value
  void _updateClassInfo(BuildContext context) {
    _classInfoBloc.add(
      UpdateClassInfoEvent(
        updateClassInfoModel: UpdateClassInfoModel(
            id: _titleIDController,
            title: _classInfo.text,
            updatedAt: _updatedAt,
            subjectCode: _subjectCode.text),
      ),
    );
  }
}
