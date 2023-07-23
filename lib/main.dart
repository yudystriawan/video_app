import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/injection.dart';
import 'package:video_app/routes/router.dart';

import 'core/utils/bloc_observer.dart';
import 'features/video_player/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'features/video_player/presentation/bloc/video_player/video_player_bloc.dart';

void main() {
  configureDependencies();
  setupBlocObserver();
  runApp(const MyApp());
}

void setupBlocObserver() {
  Bloc.observer = SimpleBlocObserver();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VideoPlayerBloc(),
        ),
        BlocProvider(
          create: (context) => MiniPlayerBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        title: 'Video App Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height;
          context
              .read<MiniPlayerBloc>()
              .add(MiniPlayerEvent.initialized(min: 72, max: height));
          return child!;
        },
      ),
    );
  }
}
