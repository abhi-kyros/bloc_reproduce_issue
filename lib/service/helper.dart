import 'dart:convert';

import 'package:signalr_core/signalr_core.dart';

import 'exception.dart';

export 'package:signalr_core/signalr_core.dart';

typedef SocketResponseCallBack = void Function(Map<String, dynamic> response);
typedef SocketResponseListCallBack = void Function(List<dynamic> response);
typedef SocketResponseAccessToken = void Function(bool response);
typedef SocketResponseAckCallBack = void Function(String response);

class HubMethod {
  HubMethod(this.methodName, this.methodFunction);

  final String methodName;
  final MethodInvocationFunc methodFunction;
}

abstract class SignalRBase {
  Future<HubConnection> startConnection({
    Function onReconnecting,
    Function onReconnected,
  });

  Future<void> stopConnection();

  void on(String methodName, MethodInvocationFunc responseCallBack);

  void off(String methodName, {MethodInvocationFunc responseCallBack});

  Future<Map<String, dynamic>> invoke(String methodName, {List<dynamic> args});
}

class SignalRHelper implements SignalRBase {
  SignalRHelper({this.hubConnection});

  HubConnection hubConnection;

  @override
  Future<HubConnection> startConnection({
    Function onReconnecting,
    Function onReconnected,
  }) async {
    final hubConnection = HubConnectionBuilder()
        .withUrl(
          Uri.http("192.168.1.27:82", '/chatviewhub').toString(),
          // Uri.http(serverUrl, '/chatviewhub?token=$constAccessToken').toString(),
          HttpConnectionOptions(
              // accessTokenFactory: () async => constAccessToken,
              logging: (level, message) => print(message),
              ),
        )
        .withAutomaticReconnect()
        .build()
          ..onreconnecting((exception) => onReconnecting())
          ..onreconnected((connectionId) => onReconnected());
    hubConnection.serverTimeoutInMilliseconds = 10 * 60 * 60 * 1000;
    hubConnection.keepAliveIntervalInMilliseconds = 10 * 60 * 60 * 1000;
    await hubConnection.start();
    return hubConnection;
  }

  @override
  Future<void> stopConnection() async {
    assert(hubConnection != null);
    hubConnection=null;
  }

  @override
  void on(
    String methodName,
    MethodInvocationFunc responseCallBack,
  ) {
    assert(hubConnection != null);
    hubConnection.on(methodName, responseCallBack);
  }

  @override
  void off(
    String methodName, {
    MethodInvocationFunc responseCallBack,
  }) {
    assert(hubConnection != null);
    hubConnection.off(methodName, method: responseCallBack);
  }

  @override
  Future<Map<String, dynamic>> invoke(String methodName,
      {List<dynamic> args}) async {
    assert(hubConnection != null);
    try {
      return await hubConnection.invoke(methodName, args: args)
          as Map<String, dynamic>;
    } on FormatException {
      throw SocketResponseException(methodName);
    }
  }



  static MethodInvocationFunc toSocketFunction(
      String methodName, SocketResponseCallBack responseCallBack) {
    return (arguments) {
      try {
        if (arguments.isEmpty) {
          throw SocketEmptyResponseException(methodName);
        }
        final response = arguments.first;
        responseCallBack(response);
      } on FormatException {
        throw SocketResponseException(methodName);
      }
    };
  }

  static MethodInvocationFunc toSocketFunctionSingleResponse(String methodName, SocketResponseAckCallBack responseCallBack) {
    return (arguments) {
      try {
        if (arguments.isEmpty) {
          throw SocketEmptyResponseException(methodName);
        }
        final response = arguments.first as String;
        responseCallBack(arguments.first);
      } on FormatException {
        throw SocketResponseException(methodName);
      }
    };
  }


  static MethodInvocationFunc toSocketFunctionList(
      String methodName, SocketResponseListCallBack responseCallBack) {
    return (arguments) {
      try {
        if (arguments.isEmpty) {
          throw SocketEmptyResponseException(methodName);
        }
        List<dynamic> response = jsonDecode(arguments.first.trim());
        responseCallBack(response);
      }catch(e){
        print(e.toString());
      }

      // on FormatException {
      //   throw SocketResponseException(methodName);
      // }
    };
  }

  static MethodInvocationFunc toSocketAccessToken(
      String methodName, SocketResponseAccessToken responseCallBack) {
    return (arguments) {
      try {
        if (arguments.isEmpty) {
          throw SocketEmptyResponseException(methodName);
        }
        // List<dynamic> response = jsonDecode(arguments.first.trim());
        responseCallBack(arguments.first.trim());
      }catch(e){
        print(e.toString());
      }

      // on FormatException {
      //   throw SocketResponseException(methodName);
      // }
    };
  }


}
