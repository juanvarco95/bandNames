import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // final socketEmit = socketService.socket.emit('emitir-mensjaje');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          print('object');
          socketService.socket.emit('emitir-mensaje', 'Juan');
          // socketService.socket.emit('emitir-otro-mensaje', 'Juan Miguel');
          // socketService.socket.emit('Culo', 'Culo');
        },
      ),
    );
  }
}
