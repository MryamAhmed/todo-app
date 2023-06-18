import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defultTextFeild ({
  @required TextEditingController controller,
  @required TextInputType  type,
  @required String label,
  IconData prefix,
  @required Function  validate,
  Function  onTap,
  bool isPasswordd = false,     //for avscure
  IconData suffix,
  Function suffixPressed,

}) => TextFormField(

  controller: controller,
  keyboardType:type,
  obscureText: isPasswordd,
  decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      prefixIcon: Icon(
          prefix
      ),

      suffixIcon: suffix !=null ? IconButton(
        onPressed:suffixPressed,
        icon:Icon(
            suffix
        ),
      ) : null

  ),
  validator: validate,
  onTap: onTap ,

);



Widget buildTaskIteam(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id:model['id'] , );
  },
  child:Padding( //

      padding: const EdgeInsets.all(20),

      child: Row(

        children: [

          CircleAvatar(

            radius: 30,

            child: Text('${model['time']}'),

          ),

          SizedBox(

            width: 20,

          ),

          Expanded(

            child: Column(

              mainAxisSize:MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  '${model['title']}',

                  style:TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                Text(

                  '${model['date']}',

                  style:TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

          SizedBox(

            width: 20,

          ),

          IconButton(

              onPressed: (){

                AppCubit.get(context).update(

                  state: 'done',

                  id: model['id'],

                );

              },

              icon: Icon(Icons.check_box),

            color: Colors.green,

          ),

          IconButton(

              onPressed: (){

                AppCubit.get(context).update(state: 'archived', id: model['id'],);

              },

              icon: Icon(Icons.archive),

            color: Colors.black26,

          )



        ],

      ),

    ),
);




Widget taskBuilder({
  @required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0 ,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskIteam(tasks[index],context),
    separatorBuilder: (context, index) => Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No tasks yet plese add some tasks ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ) ,
);