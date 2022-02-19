import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_issue_reproduce/repository/home.dart';
import 'package:bloc_issue_reproduce/repository/socket.dart';
import 'package:bloc_issue_reproduce/service/exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketBloc({
    @required this.socketRepository, this.homeRepository
    // @required this.authenticationRepository,
    // @required this.authenticationBloc,
  })  : assert(socketRepository != null),
        // assert(authenticationRepository != null),
        super(const SocketState.initial()){
    _subscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) async{
          print(state.status);
          if (connectivityResult == ConnectivityResult.wifi) {
            add(SocketConnectRequested());
          } else if (connectivityResult == ConnectivityResult.mobile) {
            add(SocketConnectRequested());
          } else if (connectivityResult == ConnectivityResult.none) {
            add(SocketNoInternetConnectionRequested());
          }
        });
  }
  StreamSubscription _subscription;
  final SocketRepository socketRepository;
  final HomeRepository homeRepository;
  // final AuthenticationRepository authenticationRepository;
  // final AuthenticationBloc authenticationBloc;


  @override
  Stream<SocketState> mapEventToState(SocketEvent event) async* {
    if (event is SocketConnectRequested) {
      yield SocketState.initial();
      yield* _mapSocketConnectRequestedToState();
    } else if (event is SocketDisconnectRequested) {
      yield SocketState.initial();
      yield* _mapSocketDisconnectRequestedToState(state);
    } else if (event is SocketRegisterUser){
      yield* _mapSocketConnectRegister(state);
    } else if (event is RemoveUserFromSocket){
      yield* _mapRemoveSocketConnectedRegister(state);
    } else if (event is SocketNoInternetConnectionRequested){
      yield  SocketState.no_connection(1);
    }
  }

  Stream<SocketState> _mapSocketConnectRequestedToState() async* {
    // yield const SocketState.loading();
    yield const SocketState.loading();
    int _userID=1;
    try {
      // final credit = await authenticationRepository.getCredit();
      await socketRepository.connect(
        onReconnecting: () async* {

          yield SocketState.reconnect(_userID);
        },
        onReconnected: () async* {
          yield SocketState.connect(_userID);
        },
      );
      yield SocketState.connect(_userID);
      // registerUser(state.userID);
    } on NoTokenException {
      print('kir to unsaved token');
      // authenticationBloc.add(const UnauthorizedRequested());
    } on Exception {
      // authenticationBloc.add(const UnauthorizedRequested());
      yield SocketState.failure();
    }
  }

  Stream<SocketState> _mapSocketDisconnectRequestedToState(
      SocketState state) async* {
    if (state.status != SocketStatus.connect) {
      return;
    }
    // await socketRepository.disconnect();
    homeRepository.disconnectRegisterUserToSocket(socketRepository.hubConnection);
    yield SocketState.disconnect(1);
    // yield state.copyWith(status: SocketStatus.disconnect);
  }

  Stream<SocketState> _mapSocketConnectRegister(SocketState state) async* {
    await homeRepository.sendRegisterToSocket(socketRepository.hubConnection,1);

  }



  Stream<SocketState> _mapRemoveSocketConnectedRegister(SocketState state) async* {
    await homeRepository.disconnectRegisterUserToSocket(socketRepository.hubConnection);

  }




  @override
  Future<void> close() {
    print("Bloc is closed in socketBloc");
    _subscription.cancel();
    return super.close();
  }


}