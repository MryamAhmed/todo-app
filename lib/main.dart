import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/blocobserver.dart';

import 'layout/layout.dart';

void main() {
  runApp(MyApp()); // بتاخد براميتر من نوع widget والكلاس دا يعتبر من موع ويدجت لنه ب  ياكستنت من StatelessWidget الي بتاكستنت من ويدجت
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget
{
  @override
  Widget build (BuildContext context)
  {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}