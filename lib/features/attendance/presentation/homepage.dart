// ignore_for_file: unused_local_variable

import 'package:attendance_practice/core/components/background_home.dart';
import 'package:attendance_practice/features/attendance/domain/students_info_bloc/students_info_bloc.dart';
import 'package:attendance_practice/features/attendance/domain/class_info_bloc/class_info_bloc.dart';
import 'package:attendance_practice/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/dependency_injection/di_container.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:attendance_practice/features/auth/domain/models/auth_user.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/add_class.model.dart';
import 'package:attendance_practice/features/attendance/domain/models/Class.Model/delete_class.model.dart';
import 'package:attendance_practice/features/attendance/presentation/student.dart';
import 'package:attendance_practice/features/attendance/presentation/update_class_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.authUserModel});
  final AuthUserModel authUserModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ClassInfoBloc _classInfoBloc;
  late AuthBloc _authBloc;

  // late TextEditingController _firstName;
  // late TextEditingController _lastName;
  // late TextEditingController _email;
  late String userId;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _classInfo = TextEditingController();
  final TextEditingController _subjectCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _classInfoBloc = BlocProvider.of<ClassInfoBloc>(context);

    userId = widget.authUserModel.userId;
    _authBloc.add(AuthAutoLoginEvent());
    _classInfoBloc.add(GetClassInfoEvent(userId: userId));

    // _firstName = TextEditingController(text: widget.authUserModel.firstName);
    // _lastName = TextEditingController(text: widget.authUserModel.lastName);
    // _email = TextEditingController(text: widget.authUserModel.email);
  }

  final DIContainer diContainer = DIContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return BlocConsumer<ClassInfoBloc, ClassInfoState>(
          bloc: _classInfoBloc,
          listener: _classListener,
          builder: (context, classInfoState) {
            if (classInfoState.isUpdated) {
              return Container(
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                _classInfoBloc.add(GetClassInfoEvent(userId: userId));
                return Future<void>.delayed(const Duration(milliseconds: 1));
              },
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                  title: Text('Class List',
                      style: GoogleFonts.kanit(fontSize: 23.0)),
                  actions: <Widget>[
                    IconButton(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.black))
                  ],
                ),
                body: BackgroundHome(
                  child: Builder(builder: (context) {
                    if (classInfoState.stateStatus == StateStatus.loading) {
                      return Container(
                        color: Colors.transparent,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (classInfoState.isEmpty) {
                      return SizedBox(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Image.asset(
                              "assets/images/emptyOrange.png",
                            ),
                            // child: Text(
                            //   'Add Subject',
                            //   style: TextStyle(fontSize: 15),
                            // ),
                          ),
                        ),
                      );
                    }
                    if (classInfoState.isDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Subject deleted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                      itemCount: classInfoState.classList.length,
                      itemBuilder: (context, index) {
                        final classList = classInfoState.classList[index];

                        //Convert createdAt dateTime from appwrite to DD/MM/YY format
                        String titleDate = classList.createdAt!;
                        String formattedDate = DateFormat('EEE, M/d/y')
                            .format(DateTime.parse(titleDate));

                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Confirmation'),
                                  content: Text(
                                      'Are you sure you want to delete ${classList.title}?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          _deleteTitleGrocery(context,
                                              classList.id, classList.title);
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
                                  builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<AuthBloc>(
                                          create: (BuildContext context) =>
                                              diContainer.authBloc,
                                        ),
                                        BlocProvider<ClassInfoBloc>(
                                          create: (BuildContext context) =>
                                              diContainer.classInfoBloc,
                                        ),
                                        BlocProvider<StudentInfoBloc>(
                                            create: (BuildContext context) =>
                                                diContainer.studentInfoBloc)
                                      ],
                                      child: StudentPage(
                                        classInfoModel: classList,
                                      )),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                elevation: 4,
                                // color: Colors.white60,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Text(
                                    style: GoogleFonts.kanit(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w400),
                                    classList.title,
                                  ),
                                  subtitle: Text(
                                    classList.subjectCode,

                                    style: GoogleFonts.kanit(fontSize: 18.0),
                                    // style: const TextStyle(fontSize: 17.0),
                                  ),

                                  // subtitle: Text(formattedDate),
                                  // trailing: SelectFormField(
                                  //   type: SelectFormFieldType
                                  //       .dropdown, // or can be dialog
                                  //   initialValue: 'circle',
                                  //   icon: Icon(Icons.format_shapes),
                                  //   labelText: 'Shape',
                                  //   items: _items,
                                  //   onChanged: (val) => print(val),
                                  //   onSaved: (val) => print(val),
                                  // ),

                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                            value: _classInfoBloc,
                                            child: UpdateClassInfoPage(
                                              classInfoModel: classList,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 255, 136, 34),
                  onPressed: () {
                    _displayAddDialog(context);
                  },
                  child: const Icon(Icons.add, color: textColor),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _classListener(BuildContext context, ClassInfoState classInfoState) {
    if (classInfoState.stateStatus == StateStatus.error) {
      Container(
          color: Colors.transparent,
          child: const Center(child: CircularProgressIndicator()));
      SnackBarUtils.defualtSnackBar(classInfoState.errorMessage, context);
    }
  }

  void _logout() {
    _authBloc.add(AuthLogoutEvent());

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<AuthBloc>(
                    create: (BuildContext context) => diContainer.authBloc,
                  ),
                ], child: const LoginScreen())),
        ModalRoute.withName('/'));
  }

  Future _displayAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              scrollable: true,
              title: const Text('Add Class Details'),
              content: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Subject Title');
                    },
                    controller: _classInfo,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: "Enter your subject name",
                        labelText: 'Subject Title'),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Subject Code');
                    },
                    controller: _subjectCode,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: "Enter your subject code",
                        labelText: 'Subject Code'),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                  ),
                  child: const Text('ADD'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addClassInfo(context);
                      Navigator.of(context).pop();
                      _classInfo.clear();
                      _subjectCode.clear();
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
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
        });
  }

  void _addClassInfo(BuildContext context) {
    _classInfoBloc.add(
      AddClassInfoEvent(
        addClassInfoModel: AddClassInfoModel(
          title: _classInfo.text,
          subjectCode: _subjectCode.text,
          userId: userId,
        ),
      ),
    );
  }

  void _deleteTitleGrocery(
      BuildContext context, String id, String title) async {
    _classInfoBloc.add(DeleteClassInfoEvent(
        deleteClassInfoModel: DeleteClassInfoModel(id: id)));

    Navigator.of(context).pop();
  }
}
