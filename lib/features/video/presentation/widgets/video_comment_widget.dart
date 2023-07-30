import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/circle_container.dart';
import 'package:video_app/shared/widgets/icon.dart';

class VideoCommentWidget extends StatelessWidget {
  const VideoCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Comments'),
              SizedBox(
                width: 4.w,
              ),
              const Text('99')
            ],
          ),
          SizedBox(
            height: 4.w,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleContainer(
                      size: 24.w,
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    const Expanded(
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 18.w,
              ),
              const AppIcon(
                icon: Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
