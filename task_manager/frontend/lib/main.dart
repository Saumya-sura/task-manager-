import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:task_manager/cubit/auth_cubit.dart';
import 'package:task_manager/presentation/pages/signup_page.dart';
void main() {
  runApp(MultiBlocProvider(
    
providers:[
        BlocProvider(
          create: (_) => AuthCubit(),
          
        ),
      ],
      child:const MyApp(),
  ),
      
      );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print("Initializing MyAppState...");
    context.read<AuthCubit>().getUserData();
    print("getUserData called.");
  }
  @override
  Widget build(BuildContext context) {
   
    
      return  MaterialApp(home: SignupPage());
    
  }
}
