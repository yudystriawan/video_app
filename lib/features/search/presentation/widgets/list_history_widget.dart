import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/routes/router.dart';
import 'package:video_app/shared/widgets/icon.dart';

import '../bloc/search/search_bloc.dart';

class ListHistoryWidget extends StatelessWidget {
  const ListHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (p, c) => p.histories != c.histories,
      builder: (context, state) {
        final histories = state.histories;

        return ListView.separated(
          padding: EdgeInsets.all(12.w),
          itemCount: histories.size,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8.w,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final history = histories[index];
            return InkWell(
              onLongPress: () => context
                  .read<SearchBloc>()
                  .add(SearchEvent.historyRemoved(history)),
              onTap: () => context.router
                  .popAndPush(VideoOverviewRoute(initialKeyword: history)),
              child: Row(
                children: [
                  const AppIcon(
                    icon: Icon(Icons.history),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: Text(
                      history,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  AppIcon(
                    icon: const Icon(Icons.arrow_outward),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
