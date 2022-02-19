import 'package:bloc/bloc.dart';
import 'package:bloc_issue_reproduce/presentation/myHomePage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/network_connection/network_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(connectivity: Connectivity()));
}

class MyApp extends StatelessWidget {
  const MyApp({this.connectivity,Key key}) : super(key: key);

  final Connectivity connectivity;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(providers:
      [
      BlocProvider<NetworkBloc>(create: (context)=> NetworkBloc(connectivity: connectivity)..add(ListenConnection())),
      ],child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("Observer: $transition");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    print("Error:---- $error");
    super.onError(bloc, error, stackTrace);
  }
}