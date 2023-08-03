import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavigationBar extends HookWidget {
  const AppBottomNavigationBar({
    Key? key,
    this.currentIndex = 0,
    required this.items,
    this.selectedColor,
    this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final List<AppNavigationBarItem> items;
  final Color? selectedColor;
  final Function(int index)? onTap;

  static double height = 48.w;

  @override
  Widget build(BuildContext context) {
    final selectedColor = this.selectedColor ?? Theme.of(context).primaryColor;
    final currentIndex = useState(this.currentIndex);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map(
          (e) {
            final selectedItem = items[currentIndex.value];
            final isSelected = selectedItem == e;
            final getItemIndex = items.indexWhere((element) => element == e);

            Widget icon = e.icon;
            if (icon is Icon) {
              icon = Icon(
                icon.icon,
                size: icon.size,
                color: isSelected ? selectedColor : icon.color,
              );
            }

            Widget? activeIcon = e.activeIcon;
            if (activeIcon is Icon) {
              activeIcon = Icon(
                activeIcon.icon,
                size: activeIcon.size,
                color: isSelected ? selectedColor : activeIcon.color,
              );
            }

            return SizedBox(
              width: 75.w,
              height: 38.w,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: GestureDetector(
                  onTap: () {
                    currentIndex.value = getItemIndex;
                    onTap?.call(currentIndex.value);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isSelected ? activeIcon ?? icon : icon,
                      if (e.label != null && e.label!.isNotEmpty)
                        Text(
                          e.label!,
                          style: TextStyle(
                            color: isSelected ? selectedColor : null,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class AppNavigationBarItem extends Equatable {
  final Widget icon;
  final Widget? activeIcon;
  final String? label;

  const AppNavigationBarItem({
    required this.icon,
    this.activeIcon,
    this.label,
  });

  @override
  List<Object?> get props => [icon, label];
}

getHeightBottomNavigationBar(BuildContext context) {
  final bottomHeight = AppBottomNavigationBar.height;
  final bottomPadding =
      MediaQueryData.fromView(View.of(context)).padding.bottom.w;

  return bottomPadding + bottomHeight;
}
