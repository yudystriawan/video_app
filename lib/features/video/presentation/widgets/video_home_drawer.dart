import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/widgets/toast.dart';

class VideoHomeDrawer extends StatelessWidget {
  const VideoHomeDrawer({
    Key? key,
    required this.onMenuTapped,
  }) : super(key: key);

  final Function(VoidCallback? callback) onMenuTapped;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Video'),
            SizedBox(
              height: 24.w,
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.trending_up),
              title: const Text('Trending'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(
                    context,
                    title: const Text('trending tapped'),
                    trailing: const Text('UNDO'),
                  );
                });
              },
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.music_note),
              title: const Text('Music'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(context, title: const Text('music tapped'));
                });
              },
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.movie_outlined),
              title: const Text('Movies'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(context, title: const Text('movies tapped'));
                });
              },
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.games_outlined),
              title: const Text('Gaming'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(context, title: const Text('gaming tapped'));
                });
              },
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.newspaper_outlined),
              title: const Text('News'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(context, title: const Text('news tapped'));
                });
              },
            ),
            DrawerMenuItemWidget(
              leading: const Icon(Icons.sports_baseball_outlined),
              title: const Text('Sports'),
              onTap: () {
                onMenuTapped.call(() {
                  showToast(context, title: const Text('sports tapped'));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerMenuItemWidget extends StatelessWidget {
  const DrawerMenuItemWidget({
    Key? key,
    this.leading,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final Widget? leading;
  final Widget title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(
                  width: 12.w,
                )
              ],
              Expanded(child: title),
            ],
          ),
        ),
      ),
    );
  }
}
