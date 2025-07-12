import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:task_manager/constants/utils.dart';
import 'package:task_manager/cubit/auth_cubit.dart';
import 'package:task_manager/home/pages/addnewtask.dart';
import 'package:task_manager/home/widgets/date_selector.dart';
import 'package:task_manager/home/widgets/task_card.dart';


class Homepage extends StatefulWidget {
  static MaterialPageRoute route()=> MaterialPageRoute(builder: (context)=> const Homepage());
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime seleectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;// current authicated user infooo
   // context.read<TasksCubit>().getAllTasks(token: user.user.token); //fetch 
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        
      //  await context.read<TasksCubit>().syncTasks(user.user.token);
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text("My Tasks"),
          actions: [
          IconButton(
            onPressed: () {
             Navigator.push(context, AddNewTaskPage.route());
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          )
        ],
      ),
      body:Column(
        children: [
          DateSelector(selectedDate: seleectedDate, onTap: (date){
            setState(() {
              seleectedDate = date;
            });
          }),
            // Expanded(
            //         child: ListView.builder(
            //             itemCount: 10,
            //             itemBuilder: (context, index) {
            //               final task = tasks[index];
            //               return Row(
            //                 children: [ 
            //                   Expanded(
            //                     child: TaskCard(
            //                       color: task.color,
            //                       headerText: task.title,
            //                       descriptionText: task.description,
            //                     ),
            //                   ),Container(
            //                     height: 10,
            //                     width: 10,
            //                     decoration: BoxDecoration(
            //                       color: strengthenColor(
            //                         task.color,
            //                         0.69,
            //                       ),
            //                       shape: BoxShape.circle,
            //                     ),
            //                   ),Padding(
            //                     padding: const EdgeInsets.all(12.0),
            //                     child: Text(
            //                       DateFormat.jm().format(task.dueAt),
            //                       style: const TextStyle(
            //                         fontSize: 17,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               );
            //             }),
            //       ),
              ],
            ),
          );
        }
      }