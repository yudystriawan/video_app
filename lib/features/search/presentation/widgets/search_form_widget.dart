import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/router.dart';
import '../../../../shared/widgets/icon.dart';
import '../bloc/search/search_bloc.dart';

class SearchFormWidget extends HookWidget {
  const SearchFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
        constraints: BoxConstraints(
          maxHeight: 28.w,
        ),
        suffixIcon: BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (p, c) => p.keyword != c.keyword,
          builder: (context, state) {
            final keyword = state.keyword;
            if (keyword.isEmpty) return const SizedBox();
            return AppIcon(
              icon: const Icon(Icons.close),
              onTap: () {
                controller.clear();
                context
                    .read<SearchBloc>()
                    .add(const SearchEvent.keywordChanged(''));
              },
            );
          },
        ),
        suffixIconColor: Colors.grey,
      ),
      cursorHeight: 16.w,
      maxLines: 1,
      onChanged: (value) =>
          context.read<SearchBloc>().add(SearchEvent.keywordChanged(value)),
      onSubmitted: (value) {
        context.read<SearchBloc>().add(const SearchEvent.submitted());
        context.router.popAndPush(VideoOverviewRoute(initialKeyword: value));
      },
    );
  }
}
