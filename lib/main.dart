import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_app/routes/route_observer.dart';

import 'core/utils/bloc_observer.dart';
import 'features/search/data/datasources/hive/query_model.dart';
import 'features/video/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'features/video/presentation/bloc/video_player/video_player_bloc.dart';
import 'injection.dart';
import 'routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set to potrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // initialized local database
  await Hive.initFlutter();

  // register adapters
  registerTypeAdapters();

  configureDependencies();
  setupBlocObserver();
  runApp(const MyApp());
}

void setupBlocObserver() {
  Bloc.observer = SimpleBlocObserver();
}

// hive's adapters
void registerTypeAdapters() {
  Hive.registerAdapter(QueryModelAdapter());
}

final appRouter = AppRouter();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<VideoPlayerBloc>(),
        ),
        BlocProvider(
          create: (context) => MiniPlayerBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: appRouter.config(
              navigatorObservers: () => [
                MyRouteObserver(),
              ],
            ),
            title: 'Video App Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: (context, child) {
              final height = MediaQuery.of(context).size.height;
              context
                  .read<MiniPlayerBloc>()
                  .add(MiniPlayerEvent.initialized(min: 54.w, max: height));

              return OrientationBuilder(
                builder: (context, orientation) {
                  return child!;
                },
              );
            },
          );
        },
      ),
    );
  }
}
