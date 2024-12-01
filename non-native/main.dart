import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gym_list_screen.dart';
import 'gym_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GymViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management',
      home: GymListScreen(),
    );
  }
}