import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/app_bar.dart';

import '../../../../injection.dart';
import '../../../../routes/router.dart';
import '../../../../shared/widgets/icon.dart';
import '../bloc/video_loader/video_loader_bloc.dart';
import '../widgets/video_list_widget.dart';

@RoutePage()
class VideoOverviewPage extends StatelessWidget implements AutoRouteWrapper {
  const VideoOverviewPage({
    Key? key,
    this.initialKeyword,
  }) : super(key: key);

  final String? initialKeyword;

  @override
  Widget build(BuildContext context) {
    final hasInitialKeyword = initialKeyword?.isNotEmpty ?? false;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  MyAppBar(
                    title: initialKeyword?.isNotEmpty ?? false
                        ? GestureDetector(
                            onTap: () => context.pushRoute(
                                SearchRoute(inititalKeyword: initialKeyword)),
                            child: Container(
                              height: 24.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: Colors.grey.shade200,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      initialKeyword ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  AppIcon(
                                    icon: const Icon(Icons.close),
                                    onTap: () =>
                                        context.pushRoute(SearchRoute()),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Text('Video'),
                    trailing: Row(
                      children: [
                        AppIcon(
                          icon: const Icon(Icons.notifications_none_outlined),
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        AppIcon(
                          icon: const Icon(Icons.search),
                          onTap: () => context.pushRoute(SearchRoute()),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 12.w,
                    endIndent: 12.w,
                  ),
                  if (!hasInitialKeyword)
                    SizedBox(
                      height: 48.w,
                    )
                ],
              ),
              const VideoListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<VideoLoaderBloc>()
            ..add(VideoLoaderEvent.fetched(query: initialKeyword)),
        ),
      ],
      child: this,
    );
  }
}
