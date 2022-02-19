import 'package:bloc_issue_reproduce/service/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';

typedef CallBackFromRepoChatList = void Function(List<dynamic> response);
class HomeRepository {





  Future<bool> sendRegisterToSocket(
      HubConnection hubConnection,
      int userID,

      ) async {
    await SignalRHelper(hubConnection: hubConnection).invoke(
        "RegisterUserOnSignalR",args: <dynamic>[userID]
    );
    return true;
  }

  Future<bool> disconnectRegisterUserToSocket(
      HubConnection hubConnection,
      ) async {
    await SignalRHelper(hubConnection: hubConnection).invoke(
        "OnDisconnectedAsync"
    );
    return true;
  }


}
