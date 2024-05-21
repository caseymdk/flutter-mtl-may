import 'dart:async';
import 'dart:typed_data';
import 'package:drone_app/drone_status_class.dart';
import 'package:http/http.dart' as http;
//import 'package:drone_app/drone_status.pb.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:gap/gap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Drone Control Interface\n(Friendly drone - Not the 🇺🇸 kind)',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var random = Random();

  DroneStatus _droneStatus = DroneStatus();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
//      fetchDroneStatus();
      _updateDroneStatus();
    });
  }

/*   Future<void> fetchDroneStatus() async {
    final response =
        await http.get(Uri.parse('https://ilgfr7cwt5lpfl6oyf56whixee0xrmvx.lambda-url.ca-central-1.on.aws/'));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final droneStatus = DroneStatus.fromBuffer(Uint8List.fromList(bytes));
      setState(() {
        _droneStatus = droneStatus;
      });
    } else {
      throw Exception('Failed to load drone status');
    }
  } */

  void _updateDroneStatus() {
    int alt = random.nextInt(5) + 30;
    setState(() {
      _droneStatus = DroneStatus(
        generalStatus: DroneStatus_Status.ALL_OK,
        speedKmh: random.nextInt(10) + 5,
        altAboveGround: alt,
        altAboveSea: alt + 692,
        suctionActive: random.nextInt(3) == 2 ? true : false,
        proximity: DroneStatus_ProximityStatus(
          left: random.nextInt(7) == 6 ? true : false,
          right: random.nextInt(7) == 6 ? true : false,
          front: random.nextInt(3) == 2 ? true : false,
          back: random.nextInt(10) == 9 ? true : false,
          top: random.nextInt(10) == 9 ? true : false,
          bottom: random.nextInt(10) == 9 ? true : false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Gap(32),
          _item('Status: ${_droneStatus.generalStatus}',
              color: _droneStatus.generalStatus == DroneStatus_Status.ALL_OK ? Colors.green : Colors.red),
          _item('Speed: ${_droneStatus.speedKmh} km/h'),
          Row(
            children: [
              _item('Alt (AGL): ${_droneStatus.altAboveGround} m'),
              _item('Alt (ASL): ${_droneStatus.altAboveSea} m'),
            ],
          ),
          _item("Suction active: ${_droneStatus.suctionActive}",
              color: _droneStatus.suctionActive ?? false ? Colors.green : Colors.red),
          const Gap(50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                  ),
                  bottom: BorderSide(color: Colors.grey),
                  left: BorderSide(color: Colors.grey),
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _item("Proximity Status:", color: Colors.blue),
                      Wrap(
                        children: [
                          _item("Front: ${_droneStatus.proximity?.front}",
                              color: _droneStatus.proximity?.front ?? false ? Colors.red : Colors.green),
                          _item("Back: ${_droneStatus.proximity?.back}",
                              color: _droneStatus.proximity?.back ?? false ? Colors.red : Colors.green),
                          _item("Left: ${_droneStatus.proximity?.left}",
                              color: _droneStatus.proximity?.left ?? false ? Colors.red : Colors.green),
                          _item("Right: ${_droneStatus.proximity?.right}",
                              color: _droneStatus.proximity?.right ?? false ? Colors.red : Colors.green),
                          _item("Top: ${_droneStatus.proximity?.top}",
                              color: _droneStatus.proximity?.top ?? false ? Colors.red : Colors.green),
                          _item("Bottom: ${_droneStatus.proximity?.bottom}",
                              color: _droneStatus.proximity?.bottom ?? false ? Colors.red : Colors.green)
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String content, {Color color = Colors.grey}) {
    double width = color == Colors.grey ? 1 : 4;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: color, width: width),
            bottom: BorderSide(color: color, width: width),
            left: BorderSide(color: color, width: width),
            right: BorderSide(color: color, width: width),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
