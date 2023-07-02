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
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    VideoOverviewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VideoOverviewPage(),
      );
    },
    VideoPlayerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VideoPlayerScreen(),
      );
    },
    VideoDetailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VideoDetailPage(),
      );
    },
  };
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
/// [VideoPlayerScreen]
class VideoPlayerRoute extends PageRouteInfo<void> {
  const VideoPlayerRoute({List<PageRouteInfo>? children})
      : super(
          VideoPlayerRoute.name,
          initialChildren: children,
        );

  static const String name = 'VideoPlayerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [VideoDetailPage]
class VideoDetailRoute extends PageRouteInfo<void> {
  const VideoDetailRoute({List<PageRouteInfo>? children})
      : super(
          VideoDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'VideoDetailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
