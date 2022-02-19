part of 'network_bloc.dart';

@immutable
abstract class NetworkState {}


class ConnectionInitial extends NetworkState {}
class ConnectionWifii extends NetworkState {}

class ConnectionInternet extends NetworkState {}

class ConnectionFailure extends NetworkState {}