import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunnerapp/bloc/bloc/homebloc/home_bloc.dart';
import 'package:tunnerapp/bloc/bloc/tunnerbloc/tuner_bloc.dart';
import 'package:tunnerapp/bloc/cubit/theme_cubit/theme_cubit.dart';
import 'package:tunnerapp/bloc/cubit/tunningsCubit/tunnings_cubit.dart';
import 'package:tunnerapp/helper/constants.dart';
import 'package:tunnerapp/view/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: AppColors.deepTeal, // status bar color
    ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(), // Add HomeBloc here
        ),
        BlocProvider(
          create: (context) => TunningsCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..lightmode(true),
        ),
        BlocProvider(
          create: (context) => TunerBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'TunnerApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
