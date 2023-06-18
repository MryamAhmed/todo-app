import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/componentes.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer <AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state){},
      builder: (BuildContext context, AppStates state){
        var tasks = AppCubit.get(context).Archivedtasks;
        return taskBuilder(tasks: tasks);
      },
    );




  }
}
