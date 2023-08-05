import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import '../features/search/presentation/pages/search_page.dart';
import '../features/shorts/presentations/pages/shorts_overview_page.dart';
import '../features/subscriptions/presentations/pages/subscriptions_overview_page.dart';
import '../features/user/presentations/pages/library_page.dart';
import '../features/video/presentation/pages/video_detail_page.dart';
import '../features/video/presentation/pages/video_full_screen_page.dart';
import '../features/video/presentation/pages/video_overview_page.dart';
import '../home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: HomeRoute.page,
        initial: true,
        children: [
          AutoRoute(page: VideoOverviewRoute.page, initial: true),
          AutoRoute(page: SearchRoute.page),
          AutoRoute(page: VideoFullScreenRoute.page),
          AutoRoute(page: ShortsOverviewRoute.page),
          AutoRoute(page: SubscriptionsOverviewRoute.page),
          AutoRoute(page: LibraryRoute.page),
        ],
      ),
    ];
  }
}
