part of 'socket_bloc.dart';

enum SocketStatus {
  initial,
  loading,
  connect,
  reconnect,
  disconnect,
  failure,
  NoInternetConnection,
  InternetConnected
}

class SocketState extends Equatable {
  const SocketState._({this.status = SocketStatus.initial,this.userID});
  //
  final SocketStatus status;
  final int userID;
  const SocketState.initial() : this._();

  const SocketState.loading() : this._(status: SocketStatus.loading);

  SocketState.connect(userID) : this._(status: SocketStatus.connect,userID:userID);

  SocketState.reconnect(userID) : this._(status: SocketStatus.reconnect,userID:userID);

  SocketState.disconnect(userID) : this._(status: SocketStatus.disconnect,userID:userID);
  SocketState.no_connection(userID) : this._(status: SocketStatus.disconnect,userID:userID);

  const SocketState.failure() : this._(status: SocketStatus.failure);

  // const SocketState({this.status=SocketStatus.initial,this.userID});
  //
  // final int userID;
  //
  // SocketState copyWith({int userID,SocketStatus status}) {
  //   return SocketState(userID: userID ?? this.userID,status:status??this.status);
  // }

  @override
  List<Object> get props => [status,userID];
}
