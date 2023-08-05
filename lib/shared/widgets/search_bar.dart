import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/search/presentation/bloc/search/search_bloc.dart';
import 'app_bar.dart';
import 'icon.dart';

class MySearchBar extends HookWidget {
  const MySearchBar({
    Key? key,
    this.initialText,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.trailing,
    this.autoFocus = false,
    this.readOnly = false,
  }) : super(key: key);

  final String? initialText;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final Widget? trailing;
  final bool autoFocus;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialText);

    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        if (state.isEditing) {
          controller.text = state.keyword;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: state.keyword.length));
        }
      },
      child: MyAppBar(
        title: TextField(
          controller: controller,
          autofocus: autoFocus,
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
            suffixIcon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.text.isEmpty) return const SizedBox();

                return AppIcon(
                  icon: const Icon(Icons.close),
                  onTap: () {
                    controller.clear();
                    onClear?.call();
                  },
                );
              },
            ),
            suffixIconColor: Colors.grey,
          ),
          cursorHeight: 16.w,
          maxLines: 1,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          readOnly: readOnly,
          onTap: onTap,
        ),
        trailing: trailing,
      ),
    );
  }
}
