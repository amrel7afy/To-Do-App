import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/modules/counter/cubit/cubit.dart';
import 'package:to_do_app/modules/counter/cubit/states.dart';

class Counter extends StatelessWidget {
  const Counter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context)=>CounterCubit(),
      child: BlocConsumer<CounterCubit,CounterStates>(
        listener: (context,state){
            if (state is CounterMinusState)print('minusState ${state.counter}');
            if(state is CounterPlusState)print('plusState ${state.counter}');
        },
        builder: (context,state)=>Scaffold(
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Container(
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                      onTap: (){
                   CounterCubit.getCubit(context).minus();
                      },
                      child:  Icon(Icons.add)),
                )

                ,
                Text('${CounterCubit.getCubit(context).counter}')
                ,Container(
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                      onTap: (){
                        CounterCubit.getCubit(context).plus();
                      },
                      child: Icon(Icons.add)),
                ),

              ],
            ),
          ),
        ),

      ),
    );
  }
}

