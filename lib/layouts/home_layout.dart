import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/app_cubit.dart';
import 'package:to_do_app/shared/cubit/app_state.dart';
import 'package:to_do_app/shared/reusable_components.dart';


class HomeLayout extends StatelessWidget
{
  int iconShow=0;
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleEditingController=TextEditingController();
  var dateEditingController=TextEditingController();
  var timeEditingController=TextEditingController();

  HomeLayout({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
// النقطتين دول كأنك اخدت اوبجكت من ال AppCubit عشان انا عاوز اكريت الداتا بيز وهو بيعمل البلوك
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child:BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AppInsertDatabaseState)Navigator.pop(context);
        },
        builder: (context,state){
          AppCubit cubit=AppCubit.getCubit(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton:
            //removeFloatingActionButton?
            FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetIsShown) {
                  if (formKey.currentState.validate()) {
                   cubit. insertDatabase(title: titleEditingController.text,
                        date: dateEditingController.text,
                        time: timeEditingController.text).then((value) {
                     // titleEditingController.clear();
                     // timeEditingController.clear();
                     // dateEditingController.clear();
                     //cubit.isBottomSheetIsShown = false;
                    });
                  }
                } else {
                  scaffoldKey.currentState.showBottomSheet(
                        (context) =>
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextField(

                                labelText: 'Task Title',
                                prefixIcon: Icons.title,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Oops field is empty';
                                  }
                                  return null;
                                },
                                textEditingController: titleEditingController),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultTextField(
                              textEditingController: timeEditingController,
                              onTap: (){
                                showTimePicker(context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeEditingController.text=value.format(context).toString();
                                  print(value.format(context).toString());
                                });
                              },
                              labelText: 'Pick Time',
                              prefixIcon: Icons.watch_later_outlined,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Oops field is empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultTextField(
                                onTap: (){
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2050-05-03')
                                  ).then((value) {
                                    dateEditingController.text=DateFormat.yMMMd().format(value);
                                  }).catchError((onError){});
                                },
                                labelText: 'Pick Date',
                                prefixIcon: Icons.calendar_today,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Oops field is empty';
                                  }
                                  return null;
                                },
                                textEditingController: dateEditingController),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(false,Icons.edit);

                  });
                  cubit.changeBottomSheetState(true, Icons.check);
                }

                // insertDatabase();
              },
              child: Icon(cubit.fabIcon),
            )
            //  :null
            ,
            body: cubit.screens[cubit.currentIndex],
            appBar: AppBar(
              title:  Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_sharp), label: 'Archive'),
              ],
            ),
          );
        },
      ) ,
    );
  }

  Future<String> getName() async {
    return 'Amr El7afy';
  }
}



