import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../modules/archived tasks/archivedTasks.dart';
import '../../modules/done tasks/doneTasks.dart';
import '../../modules/new tasks/newTasks.dart';


class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppinitialState());
  static AppCubit get(context)=> BlocProvider.of(context);


  var currentIndex = 0;
  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> title = [
    'New',
    'done',
    'archived',
  ];


  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavbarState());
  }

  bool bottomSheet= false;
  IconData icon= Icons.edit;

  void ChangeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
})
  {
    bottomSheet = isShow;
    icon = icon;
    emit(AppChangeBottomSheetState());
  }

  Database database;
  List<Map>Newtasks = [];
  List<Map>Donetasks = [];
  List<Map>Archivedtasks = [];


  void CreateDataBase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      //1
      onCreate: (database, version) // database is an obj from database which created
      {
        print('database created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT ,time TEXT ,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when created table ${error.toString()}');
        });
      },
      //2
      onOpen: (database) {

        getDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

   insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
     await database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")'
      )
          .then((value)
      {
        print('$value inserted done');
        emit(AppInsertDatabaseState());

        getDatabase(database);
      })
          .catchError((error)
      {
        print('error when inserted  ${error.toString()}');
      });
      return null;
    });
  }

  void getDatabase(database)async
  {
    Newtasks=[];
    Donetasks=[];
    Archivedtasks=[];

    emit(AppInsertGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element){
         if(element['status']=='new')
           Newtasks.add(element);
         else if(element['status'] == 'done')
           Donetasks.add(element);
         else
           Archivedtasks.add(element);

       });
       emit(AppGetDatabaseState());
     });
  }


  void update({
    @required String state,
    @required int id,
})async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['${state}', id],
     ).then((value) {
       getDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }


  void deleteData({
    @required String statues,
    @required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]
    ).then((value){
      getDatabase(database);
      emit(AppInsertGetDatabaseLoadingState());
    });
  }

}