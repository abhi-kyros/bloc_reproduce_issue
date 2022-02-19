import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc_issue_reproduce/hub/socket.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:http/http.dart' as http;

class SocketRepository {
  HubConnection _hubConnection;

  HubConnection get hubConnection {
    assert(_hubConnection != null,
        'First use `connect` method to initial connection!');
    return _hubConnection;
  }

  Future<void> connect({
    Function onReconnecting,
    Function onReconnected,
  }) async {
    _hubConnection ??= await SocketHub.connect(
      onReconnecting: onReconnecting,
      onReconnected: onReconnected,
    );
  }

  Future<void> disconnect() async {
    assert(_hubConnection != null,
        'First use `connect` method to initial connection!');
    await SocketHub.disconnect(_hubConnection);
    // await SocketHub.disconnect(_hubConnection);
  }

}
