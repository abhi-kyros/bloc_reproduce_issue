import 'package:bloc_issue_reproduce/service/helper.dart';
import 'package:signalr_core/signalr_core.dart';

class SocketHub {
  static Future<HubConnection> connect( {
    Function onReconnecting,
    Function onReconnected,
  }) async {
    return await SignalRHelper().startConnection(
      onReconnecting: onReconnecting,
      onReconnected: onReconnected,
    );
  }

  static Future<void> disconnect(HubConnection hubConnection) async {
    return await SignalRHelper(hubConnection: hubConnection).stopConnection();
  }
}
