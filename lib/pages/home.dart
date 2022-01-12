import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 2),
    Band(id: '3', name: 'Slayer', votes: 4),
    Band(id: '4', name: 'Bon Jovi', votes: 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bandas', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) {
          return _bandTile(bands[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: addNewband,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        debugPrint('Direction: $direction');
        debugPrint('id: ${band.id}');
        bands.remove(band);
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
        // ignore: avoid_print
        onTap: () {
          setState(() {
            band.votes += 1;
            debugPrint('${band.votes}');
            // print(band.votes);
          });
        },
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  addNewband() {
    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
            );
          });
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
    // ignore: avoid_print
    print(name);
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
