import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import '../features/search/presentation/pages/search_page.dart';
import '../features/video/presentation/pages/video_detail_page.dart';
import '../features/video/presentation/pages/video_overview_page.dart';
import '../home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: VideoOverviewRoute.page, path: '/videos', initial: true),
      AutoRoute(page: VideoDetailRoute.page, path: '/video'),
      AutoRoute(page: SearchRoute.page),
    ];
  }
}
