import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/app_cubit.dart';

Widget defaultTextField({
  @required String labelText,
  @required IconData prefixIcon,
  @required TextEditingController textEditingController,
  Function validate,
  Function onTap
}
    ) =>TextFormField(
  validator: validate,
  onTap: onTap,
  controller: textEditingController,
  decoration: InputDecoration(

    labelText: labelText,
    border: const OutlineInputBorder(),
    prefixIcon:Icon( prefixIcon),
  ),
);



Widget taskItem(Map model, context)=>Dismissible(
  key: Key(model['id'].toString()),onDismissed: (d){
    AppCubit.getCubit(context).deleteDatabase(id: model['id']);
},
  child:Padding(
  
    padding: const EdgeInsets.all(10.0),
  
    child: Row(
  
      children:  [
  
         CircleAvatar(
  
          radius: 40.0,
  
          child: Text('${model['time']}',style: const TextStyle(fontWeight: FontWeight.bold),),
  
        ),
  
        const SizedBox(width: 10.0,),
  
        Column(
  
          mainAxisSize: MainAxisSize.min,
  
          children:  [
  
            Text('${model['title']}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 21),),
  
            Text('${model['date']}',style: const TextStyle(color: Colors.grey),),
  
          ],
  
        ),
  
        const Expanded(child: SizedBox()),
  
        AppCubit.getCubit(context).currentIndex==1?Container():
  
        IconButton(onPressed: (){
  
          AppCubit.getCubit(context).updateDateBase(status: 'done',id: model['id']);
  
        }, icon: const Icon(Icons.check_box,color: Colors.green,)),
  
        const SizedBox(width: 10.0,),
  
        AppCubit.getCubit(context).currentIndex==2?Container():
  
        IconButton(onPressed: (){
  
          AppCubit.getCubit(context).updateDateBase(status: 'archived',id: model['id']);
  
        }, icon: const Icon(Icons.archive_sharp,color: Colors.black45,)),
  
      ],),
  
  ),
);