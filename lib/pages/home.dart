import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 2),
    // Band(id: '3', name: 'Slayer', votes: 4),
    // Band(id: '4', name: 'Bon Jovi', votes: 3)
  ];

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bandas', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? const Icon(Icons.offline_bolt,
                      color: Colors.green, size: 30)
                  : const Icon(Icons.offline_bolt, color: Colors.red, size: 30))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) {
                return _bandTile(bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: addNewband,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        debugPrint('Direction: $direction');
        debugPrint('id: ${band.id}');
        socketService.socket.emit('delete-band', {'id': band.id});
        // bands.remove(band);
      },
      background: Container(
        color: Colors.red,
        child: ListTile(
          leading: const Icon(Icons.restore_from_trash_sharp),
          title: Text('Delete ${band.name}'),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100]),
        title: Text(band.name, style: const TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  addNewband() {
    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('New Band Name: '),
                content: TextField(
                  controller: textEditingController,
                ),
                actions: [
                  MaterialButton(
                      child: const Text('Add'),
                      onPressed: () => addBandList(textEditingController.text),
                      textColor: Colors.blue,
                      elevation: 5)
                ],
              ));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text('New Band Name: '),
              content: CupertinoTextField(controller: textEditingController),
              actions: [
                CupertinoDialogAction(
                    child: const Text('Add'),
                    isDefaultAction: true,
                    onPressed: () => addBandList(textEditingController.text))
              ],
            );
          });
    }
  }

  void addBandList(String name) {
    // print(name);
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('create-band', {'name': name});
      // setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    return (dataMap.isNotEmpty)
        ? SizedBox(
            width: double.infinity,
            height: 200,
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              emptyColor: Colors.black,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
              ),
            ))
        : const SizedBox();
  }
}
