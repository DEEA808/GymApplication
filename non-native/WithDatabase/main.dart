import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gym_view_model.dart';
import 'gym_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final gymViewModel = GymViewModel();

  await gymViewModel.loadGyms();

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