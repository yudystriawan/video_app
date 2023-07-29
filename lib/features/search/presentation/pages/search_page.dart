import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/search/presentation/widgets/list_history_widget.dart';
import 'package:video_app/features/search/presentation/widgets/search_form_widget.dart';
import 'package:video_app/injection.dart';
import 'package:video_app/shared/widgets/app_bar.dart';

import '../bloc/search/search_bloc.dart';

@RoutePage()
class SearchPage extends StatelessWidget implements AutoRouteWrapper {
  const SearchPage({
    Key? key,
    this.inititalKeyword,
  }) : super(key: key);

  final String? inititalKeyword;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              title: SearchFormWidget(),
            ),
            Expanded(
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
          getIt<SearchBloc>()..add(const SearchEvent.fetched()),
      child: this,
    );
  }
}
