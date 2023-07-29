import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/routes/router.dart';
import 'package:video_app/shared/widgets/icon.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 338.w,
      height: 48.w,
      child: Row(
        children: [
          const Expanded(
            child: Text('VideoApp'),
          ),
          SizedBox(
            width: 12.w,
          ),
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
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
