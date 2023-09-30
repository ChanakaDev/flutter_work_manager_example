// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';

sendData() {
  var text = "Running";

  while(true){
    print(text);
  }
}

// Giving a task name to uniquely identify the task
const taskName = "first-task";

// Function to run in background
void callbackDispatcher() {
  // Execute task with (taskName and inputData)
  Workmanager().executeTask((taskName, inputData) {
    // Switch case to run all the list of background tasks you have
    switch (taskName) {
      case "first-task":
        sendData();
        break;
      default:
        print("Hello from switch case default");
    }

    // Inform back that background task run successfully
    return Future.value(true);
  });
}

void main() async {
  // Ensure initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize workmanager
  await Workmanager().initialize(
    callbackDispatcher, // calling the function to run in background
    isInDebugMode: true, // Show notification whenever the operation perform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    //call in init state;
    initAutoStart();
  }

  //initializing the autoStart with the first build.
  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      // var test = await (isAutoStartAvailable as FutureOr<bool>);
      // print(test);
      //if available then navigate to auto-start setting page.
      //if (test)
        await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Creating a unique identifier
            var uniqueIdentifier = DateTime.now().second.toString();

            // // A perriodic task
            // await Workmanager().registerPeriodicTask(
            //   uniqueIdentifier, taskName, // The task name you defined before
            //   frequency: const Duration(seconds: 15),
            //   // constraints: Constraints(
            //   //   networkType: NetworkType.connected,
            //   // ),
            //   initialDelay: const Duration(seconds: 15),
            // );

            // A oneOffTask
            await Workmanager().registerOneOffTask(
              uniqueIdentifier,
              taskName,
              // // Constraint to run the task
              // constraints: Constraints(
              //   networkType: NetworkType.connected,
              // ),
            );
          },
          child: const Text("Run background task"),
        ),
      ),
    );
  }
}
