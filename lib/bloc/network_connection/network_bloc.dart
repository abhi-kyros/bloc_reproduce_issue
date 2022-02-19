import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc({@required this.connectivity}) : super(ConnectionInitial());

  StreamSubscription _subscription;
  final Connectivity connectivity;

  @override
  Stream<NetworkState> mapEventToState(
    NetworkEvent event,
  ) async* {
    if (event is ListenConnection) {

      _subscription =
          connectivity.onConnectivityChanged.listen((connectivityResult) {
            if (connectivityResult == ConnectivityResult.wifi) {
              add(ConnectionChanged(ConnectionWifii()));
            } else if (connectivityResult == ConnectivityResult.mobile) {
              add(ConnectionChanged(ConnectionInternet()));
            } else if (connectivityResult == ConnectivityResult.none) {
              add(ConnectionChanged(ConnectionFailure()));
            }
          });

    }
    if (event is ConnectionChanged) yield event.connection;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
