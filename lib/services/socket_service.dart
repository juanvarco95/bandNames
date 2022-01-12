import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io('http://192.168.0.8:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    socket.on('disconnect', (_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
