import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import '../features/video/presentation/pages/video_detail_page.dart';
import '../features/video/presentation/pages/video_overview_page.dart';
import '../home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, path: '/'),
      AutoRoute(page: VideoOverviewRoute.page, path: '/videos'),
      AutoRoute(page: VideoDetailRoute.page, path: '/video'),
    ];
  }
}
