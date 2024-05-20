import 'dart:async';

import 'package:drone_app/drone_status.pb.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    Timer? _timer;

  DroneStatus droneStatus = DroneStatus();

    @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDroneStatus();
    });
  }

  void _updateDroneStatus() {
    int alt = random.nextInt(5) + 30;
    setState(() {
      droneStatus = DroneStatus(
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
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         _item(
              'Speed: ${droneStatus.speedKmh} km/h'
            ),
         Row(
           children: [
             _item(
                  'Alt (AGL): ${droneStatus.altAboveGround} m'
                ),
             _item(
                  'Alt (ASL): ${droneStatus.altAboveSea} m'
                ),
           ],
         ),
         _item("Suction active: ${droneStatus.suctionActive}", color: droneStatus.suctionActive ? Colors.green : Colors.red),
         const Gap(24),
         _item("Proximity Status:\n\n${droneStatus.proximity}")
        ],
      ),
    );
  }

Widget _item(String content, {Color color = Colors.grey})
{
double  width = color == Colors.grey ? 1 : 4;
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
