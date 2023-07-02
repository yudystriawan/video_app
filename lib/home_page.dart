import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/video_player/presentation/pages/video_overview_page.dart';
import 'features/video_player/presentation/widgets/video_list_widget.dart';
import 'features/video_player/presentation/widgets/video_player.dart';
import 'router/router.dart';

import 'core/utils/util.dart';
import 'features/video_player/presentation/bloc/mini_player/mini_player_bloc.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const playerMinHeight = kBottomNavigationBarHeight;
//     final playerMaxHeight =
//         MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
//     return Scaffold(
//       body: Stack(
//         children: const [
//           HomeScaffold(),
//           VideoPlayer(),
//         ],
//       ),
//       bottomNavigationBar: ValueListenableBuilder(
//         valueListenable: playerExpandProgress,
//         builder: (context, height, child) {
//           final isLandscape =
//               MediaQuery.of(context).orientation == Orientation.landscape;
//           if (isLandscape) {
//             return const SizedBox();
//           }

//           final value = percentageFromValueInRange(
//             min: playerMinHeight,
//             max: playerMaxHeight,
//             value: height,
//           );

//           final mediaQuery = MediaQuery.of(context);

//           final bottomNavHeight =
//               kBottomNavigationBarHeight + mediaQuery.padding.bottom;

//           var opacity = 1 - value;
//           if (opacity < 0) opacity = 0;
//           if (opacity > 1) opacity = 1;

//           return SizedBox(
//             height: bottomNavHeight - bottomNavHeight * value,
//             child: Transform.translate(
//               offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
//               child: Opacity(
//                 opacity: opacity,
//                 child: OverflowBox(
//                   maxHeight: bottomNavHeight,
//                   child: child,
//                 ),
//               ),
//             ),
//           );
//         },
//         child: BottomNavigationBar(
//           currentIndex: 0,
//           selectedItemColor: Colors.blue,
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Feed',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.library_books),
//               label: 'Library',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScaffold extends StatelessWidget {
//   const HomeScaffold({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: const VideoListWidget(),
//       // Column(
//       //   children: [
//       //     ElevatedButton(
//       //       onPressed: () {
//       //         SystemChrome.setPreferredOrientations([
//       //           DeviceOrientation.landscapeLeft,
//       //           DeviceOrientation.landscapeRight
//       //         ]);
//       //       },
//       //       child: const Text('landscape'),
//       //     ),
//       //     ElevatedButton(
//       //       onPressed: () {
//       //         SystemChrome.setPreferredOrientations([
//       //           DeviceOrientation.portraitUp,
//       //         ]);
//       //       },
//       //       child: const Text('potrait'),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    context.read<MiniPlayerBloc>().add(MiniPlayerEvent.initialized(
          min: 72,
          max: height,
        ));

    return VideoOverviewPage();
  }
}
