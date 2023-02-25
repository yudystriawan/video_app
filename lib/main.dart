import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/video_player/presentation/bloc/video_player/video_player_bloc.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerBloc(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Video App Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
        ),
        home: const HomePage(),
      ),
    );
  }
}
