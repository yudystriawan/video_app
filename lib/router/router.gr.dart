// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    VideoOverviewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VideoOverviewPage(),
      );
    },
    VideoDetailRoute.name: (routeData) {
      final args = routeData.argsAs<VideoDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: VideoDetailPage(
          key: args.key,
          miniplayerController: args.miniplayerController,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
  };
}

/// generated route for
/// [VideoOverviewPage]
class VideoOverviewRoute extends PageRouteInfo<void> {
  const VideoOverviewRoute({List<PageRouteInfo>? children})
      : super(
          VideoOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'VideoOverviewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [VideoDetailPage]
class VideoDetailRoute extends PageRouteInfo<VideoDetailRouteArgs> {
  VideoDetailRoute({
    Key? key,
    required MiniplayerController miniplayerController,
    List<PageRouteInfo>? children,
  }) : super(
          VideoDetailRoute.name,
          args: VideoDetailRouteArgs(
            key: key,
            miniplayerController: miniplayerController,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoDetailRoute';

  static const PageInfo<VideoDetailRouteArgs> page =
      PageInfo<VideoDetailRouteArgs>(name);
}

class VideoDetailRouteArgs {
  const VideoDetailRouteArgs({
    this.key,
    required this.miniplayerController,
  });

  final Key? key;

  final MiniplayerController miniplayerController;

  @override
  String toString() {
    return 'VideoDetailRouteArgs{key: $key, miniplayerController: $miniplayerController}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
