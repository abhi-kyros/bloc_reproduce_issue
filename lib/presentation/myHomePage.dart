import 'package:bloc_issue_reproduce/bloc/socket/socket_bloc.dart';
import 'package:bloc_issue_reproduce/repository/home.dart';
import 'package:bloc_issue_reproduce/repository/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final socketRepository = SocketRepository();
  final homeRepository = HomeRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SocketBloc(
            socketRepository: socketRepository,
            homeRepository: homeRepository,
          ),
      child: BlocConsumer<SocketBloc, SocketState>(
        listener: (context, state) {

          switch (state.status) {
            case SocketStatus.connect:
              {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Socket has been connected!'),
                    ),
                  );
                // if (BlocProvider.of<HomeBloc>(context).state.status == HomeStatus.initial) {

                BlocProvider.of<SocketBloc>(context)
                    .add(SocketRegisterUser());

              }
              break;
            case SocketStatus.NoInternetConnection:
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('No internet connection'),
                  ),
                );
              break;
            case SocketStatus.disconnect:
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Socket has been disconnected!'),
                  ),
                );
              break;
            case SocketStatus.failure:
            // BlocProvider.of<HomeBloc>(context)
            //     .add(const GetChatListRequested());

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Failure due to connecting to socket!'),
                  ),
                );
              break;
            case SocketStatus.failure:
            // BlocProvider.of<HomeBloc>(context)
            //     .add(const GetChatListRequested());


              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Failure due to connecting to socket!'),
                  ),
                );
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Scaffold(appBar:AppBar(
            title: Text("Task Demo"),
          ),body: Container());
        },
      ),
    );
  }
}
