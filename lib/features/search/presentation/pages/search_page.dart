import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../../routes/router.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../bloc/search/search_bloc.dart';
import '../widgets/list_history_widget.dart';

@RoutePage()
class SearchPage extends StatelessWidget implements AutoRouteWrapper {
  const SearchPage({
    Key? key,
    this.inititalKeyword,
  }) : super(key: key);

  final String? inititalKeyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MySearchBar(
              initialText: inititalKeyword,
              onChanged: (value) => context
                  .read<SearchBloc>()
                  .add(SearchEvent.keywordChanged(value)),
              onSubmitted: (value) {
                context.read<SearchBloc>().add(const SearchEvent.submitted());
                context.router
                    .popAndPush(VideoOverviewRoute(initialKeyword: value));
              },
              onClear: () => context
                  .read<SearchBloc>()
                  .add(const SearchEvent.keywordChanged('')),
              autoFocus: true,
            ),
            const Expanded(
              child: ListHistoryWidget(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SearchBloc>()..add(SearchEvent.initialized(inititalKeyword)),
      child: this,
    );
  }
}
