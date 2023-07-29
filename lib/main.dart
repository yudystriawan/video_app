import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_app/features/search/data/datasources/hive/query_model.dart';
import 'package:video_app/shared/widgets/bottom_navigation_bar.dart';
import 'package:video_app/shared/widgets/icon.dart';

import 'core/utils/bloc_observer.dart';
import 'core/utils/util.dart';
import 'features/video/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'features/video/presentation/bloc/video_player/video_player_bloc.dart';
import 'features/video/presentation/pages/video_detail_page.dart';
import 'injection.dart';
import 'routes/router.dart';

Future<void> main() async {
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
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: _appRouter.config(),
            title: 'Video App Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: (context, child) {
              final height = MediaQuery.of(context).size.height;
              context
                  .read<MiniPlayerBloc>()
                  .add(MiniPlayerEvent.initialized(min: 76.w, max: height));

              return Scaffold(
                body: SafeArea(
                  child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                    buildWhen: (p, c) => p.currentVideo != c.currentVideo,
                    builder: (context, state) {
                      final currentVideo = state.currentVideo;

                      return Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: child!),
                              if (currentVideo != null)
                                BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      height: state.playerMinHeight,
                                    );
                                  },
                                ),
                            ],
                          ),
                          VideoDetailPage(
                            miniplayerController: context
                                .watch<MiniPlayerBloc>()
                                .miniplayerController,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                bottomNavigationBar:
                    BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                  buildWhen: (p, c) => p.playerMinHeight != c.playerMinHeight,
                  builder: (context, state) {
                    if (state.playerMinHeight == 0) return const SizedBox();
                    return ValueListenableBuilder<double>(
                      valueListenable:
                          context.watch<MiniPlayerBloc>().playerExpandProgress,
                      builder:
                          (BuildContext context, double height, Widget? child) {
                        final value = percentageFromValueInRange(
                          min: state.playerMinHeight,
                          max: state.playerMaxHeight,
                          value: height,
                        );

                        var opacity = 1 - value;
                        if (opacity < 0) opacity = 0;
                        if (opacity > 1) opacity = 1;

                        final totalHeight =
                            getHeightBottomNavigationBar(context);

                        return Container(
                          color: Colors.white,
                          height: totalHeight - (totalHeight * value),
                          child: Transform.translate(
                            offset: Offset(0.0, totalHeight * value * 0.5.w),
                            child: Opacity(
                              opacity: opacity,
                              child: const AppBottomNavigationBar(
                                items: [
                                  AppNavigationBarItem(
                                    icon: AppIcon(icon: Icon(Icons.home)),
                                    label: 'Home',
                                  ),
                                  AppNavigationBarItem(
                                    icon: AppIcon(
                                        icon:
                                            Icon(Icons.video_library_outlined)),
                                    label: 'Library',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
