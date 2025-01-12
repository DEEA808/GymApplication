import 'package:flutter/material.dart';
import 'package:gym_app_flutter/sync_helper.dart';
import 'package:provider/provider.dart';

import 'gym_view_model.dart';
import 'gym_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final gymViewModel = GymViewModel();

  await gymViewModel.loadGyms();

  final SyncHelper syncHelper = SyncHelper();
  syncHelper.monitorConnectivity();

  runApp(
    ChangeNotifierProvider(
      create: (context) => gymViewModel,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GymListScreen(),
    );
  }
}
