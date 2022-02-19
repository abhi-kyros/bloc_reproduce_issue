part of 'socket_bloc.dart';


abstract class SocketEvent {
  const SocketEvent();

  // @override
  // List<Object> get props => [];
}

class SocketConnectRequested extends SocketEvent {
  const SocketConnectRequested();
  @override
  List<Object> get props => [];
}

class SocketDisconnectRequested extends SocketEvent {
  const SocketDisconnectRequested();
  @override
  List<Object> get props => [];
}

class SocketNoInternetConnectionRequested extends SocketEvent {
  const SocketNoInternetConnectionRequested();
  @override
  List<Object> get props => [];
}

class SocketRegisterUser extends SocketEvent{
  const SocketRegisterUser();

  @override
  List<Object> get props => [];
}

class RemoveUserFromSocket extends SocketEvent{
  const RemoveUserFromSocket();

  @override
  List<Object> get props => [];
}
