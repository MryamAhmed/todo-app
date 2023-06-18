import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

import '../shared/components/componentes.dart';
class HomeLayout extends StatelessWidget
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..CreateDataBase(),
      
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cu = AppCubit.get(context);
          return Scaffold(
          key:scaffoldKey,
            appBar: AppBar(
              title: Text(
                cu.title[cu.currentIndex],
              )
          ),
            body: ConditionalBuilder(
            condition: state is! AppInsertGetDatabaseLoadingState ,     //
            builder: (context)=> cu.screen[cu.currentIndex],
            fallback:(context) => Center(child: CircularProgressIndicator()) ,
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cu.bottomSheet) {
                  if (formKey.currentState.validate()) {
                    cu.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defultTextFeild(
                                  controller: titleController,
                                  label: 'task title',
                                  type: TextInputType.text,
                                  prefix: Icons.title,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                //////////////////////////////////////////
                                defultTextFeild(
                                  controller: timeController,
                                  label: 'task time',
                                  type: TextInputType.datetime,
                                  prefix: Icons.watch_later_outlined,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defultTextFeild(
                                    controller: dateController,
                                    label: 'task date',
                                    type: TextInputType.datetime,
                                    prefix: Icons.calendar_today,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-30-12'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cu.ChangeBottomSheetState(icon: Icons.edit, isShow: false);
                  });
                  cu.ChangeBottomSheetState(icon: Icons.add, isShow: true);
                }
              },
              child: Icon(cu.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cu.currentIndex,
              onTap: (index) {
                cu.changeIndex(index);
                /*
              setState(() {
                indexx = index;
              });

               */

            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'tasks',

              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.done,
                ),
                label: 'Done',

              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive,
                ),
                label: 'Archived',

              ),
            ],
          ),
        );
        },
      ),
    );
  }


}

