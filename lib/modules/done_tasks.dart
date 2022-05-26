import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/app_cubit.dart';
import 'package:to_do_app/shared/cubit/app_state.dart';
import 'package:to_do_app/shared/reusable_components.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder: (context,state){
      AppCubit cubit=AppCubit.getCubit(context);
      return
        cubit.doneTasks.length==0 ? Center(child: Text('No Tasks Today'
        ,style: TextStyle(
            fontSize: 25,fontWeight: FontWeight.bold
        ),)):
      ListView.separated(
          itemBuilder: (context, index) => taskItem(AppCubit.getCubit(context).doneTasks[index],context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[400],
            padding: const EdgeInsetsDirectional.only(start: 10.0),
          ),
          itemCount:cubit.doneTasks.length);
    }, listener:(context,state){} )
    ;
  }

}

