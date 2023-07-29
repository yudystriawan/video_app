import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/video/presentation/bloc/video_loader/video_loader_bloc.dart';
import 'features/video/presentation/pages/video_overview_page.dart';
import 'injection.dart';

@RoutePage()
class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({
    Key? key,
    this.initialKeyword,
  }) : super(key: key);

  final String? initialKeyword;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: VideoOverviewPage(),
      // bottomNavigationBar: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      //   buildWhen: (p, c) => p.playerMinHeight != c.playerMinHeight,
      //   builder: (context, state) {
      //     if (state.playerMinHeight == 0) return const SizedBox();
      //     return ValueListenableBuilder<double>(
      //       valueListenable:
      //           context.watch<MiniPlayerBloc>().playerExpandProgress,
      //       builder: (BuildContext context, double height, Widget? child) {
      //         final value = percentageFromValueInRange(
      //           min: state.playerMinHeight,
      //           max: state.playerMaxHeight,
      //           value: height,
      //         );

      //         var opacity = 1 - value;
      //         if (opacity < 0) opacity = 0;
      //         if (opacity > 1) opacity = 1;

      //         return SizedBox(
      //           height: kBottomNavigationBarHeight -
      //               kBottomNavigationBarHeight * value,
      //           child: Transform.translate(
      //             offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
      //             child: Opacity(
      //               opacity: opacity,
      //               child: OverflowBox(
      //                 maxHeight: kBottomNavigationBarHeight,
      //                 child: BottomNavigationBar(
      //                   currentIndex: 0,
      //                   selectedItemColor: Colors.blue,
      //                   items: const <BottomNavigationBarItem>[
      //                     BottomNavigationBarItem(
      //                         icon: Icon(Icons.home), label: 'Feed'),
      //                     BottomNavigationBarItem(
      //                         icon: Icon(Icons.library_books),
      //                         label: 'Library'),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<VideoLoaderBloc>()..add(const VideoLoaderEvent.fetched()),
      child: this,
    );
  }
}
