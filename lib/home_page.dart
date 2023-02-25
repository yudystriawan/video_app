import 'package:flutter/material.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_player.dart';

import 'core/utils/util.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const playerMinHeight = kBottomNavigationBarHeight;
    final playerMaxHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: const [
          HomeScaffold(),
          VideoPlayer(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerExpandProgress,
        builder: (context, height, child) {
          final value = percentageFromValueInRange(
            min: playerMinHeight,
            max: playerMaxHeight,
            value: height,
          );

          final mediaQuery = MediaQuery.of(context);

          final bottomNavHeight =
              kBottomNavigationBarHeight + mediaQuery.padding.bottom;

          var opacity = 1 - value;
          if (opacity < 0) opacity = 0;
          if (opacity > 1) opacity = 1;

          return SizedBox(
            height: bottomNavHeight - bottomNavHeight * value,
            child: Transform.translate(
              offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
              child: Opacity(
                opacity: opacity,
                child: OverflowBox(
                  maxHeight: bottomNavHeight,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        color: Colors.amber,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
