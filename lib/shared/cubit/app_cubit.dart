import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/modules/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks.dart';
import 'package:to_do_app/modules/new_tasks.dart';
import 'package:to_do_app/shared/cubit/app_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialAppState());
  bool isBottomSheetIsShown = false;
  IconData fabIcon = Icons.edit;
  Database database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];
  List<Widget> screens = [
    const NewTask(),
    const DoneTask(),
    const ArchivedTasks()
  ];
  List <String> titles=[
    'New Tasks','done Tasks','Archived Tasks'
  ];
  int currentIndex = 0;

  //////////////////////////////////////////////////////////////////////////////

  static AppCubit getCubit(context)=>BlocProvider.of(context);
  void createDatabase(){
     openDatabase(
        'to_do.db',version: 1,
        onCreate: (database,version){
          print('database is created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )').then((value) {
            print('table is created');
            throw ('!!!!!!!!!');
          }).catchError((onError){
            print('$onError Oops');
          });
        },
        onOpen: (database){
          print('database is opened');

          getAllFromDataBase(database);}
    ).then((value) {
      database=value;
      emit(AppCreateDatabaseState());
     });
  }
  Future insertDatabase({@required String title, @required String date, @required String time,})async{
    return await database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
            getAllFromDataBase(database);
            emit(AppInsertDatabaseState());
            print(value);}).catchError((onError){print('$onError');});
      return null;
    });

  }
  //  ليه باعتين داتا بيز براميتر لو شيلناه فانت كدا عاوز تأكسس الداتا بيز اللي هيا دي()database=await openDatabase
  //ودي لسه هتيجي لانها await فهتديلك null
  //ليه خليت النوع بتاعها future دا عشان عاوز اخليها .then فوق
  // وعملت return علطلول عشان اقدر أأكسيس الليست من مكان تاني
  void getAllFromDataBase(database){
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
     database.rawQuery('SELECT * FROM tasks').then((value){
      emit(AppGetAllDatabaseState());
      print('get from database');

   value.forEach((element){
     print('aaaaaaaaaaa');
     if(element['status']== 'new'){
       newTasks.add(element);
     }else  if(element['status']=='done'){
       doneTasks.add(element);
     }else {
       archivedTasks.add(element);
     }
   });

    });
  }
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavIndexStates());
  }
  void changeBottomSheetState(bool showBottomSheet,IconData fab){
    isBottomSheetIsShown=showBottomSheet;
    fabIcon=fab;
    emit(AppChangeBottomSheetState());
  }
  void updateDateBase({@required String status,@required int id}) {
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],).then((value){
          getAllFromDataBase(database);
          emit(AppUpdateDatabaseState());

    });
  }
  void deleteDatabase({@required int id})async{
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getAllFromDataBase(database);
      emit(AppDeleteDatabaseState());});
  }
}