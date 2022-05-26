import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/modules/counter/counter.dart';
import 'package:to_do_app/shared/bloc_observer.dart';

import 'layouts/home_layout.dart';

void main(){
  Bloc.observer=SimpleBlocObserver();
  runApp(const MyApp(
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeLayout(),
    );
  }
}
