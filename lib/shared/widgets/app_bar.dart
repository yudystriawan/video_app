import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/icon.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
    required this.title,
    this.trailing,
    this.leading,
  }) : super(key: key);

  final Widget title;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final hasParent = context.router.canPop();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          height: 48.w,
          child: Row(
            children: [
              if (hasParent) ...[
                leading ??
                    AppIcon(
                      icon: const Icon(Icons.arrow_back),
                      onTap: () => context.router.pop(),
                    ),
                SizedBox(
                  width: 12.w,
                ),
              ],
              Expanded(
                child: title,
              ),
              if (trailing != null) ...{
                SizedBox(
                  width: 12.w,
                ),
                trailing!,
              },
            ],
          ),
        );
      },
    );
  }
}
