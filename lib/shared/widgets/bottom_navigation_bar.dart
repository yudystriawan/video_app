import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'icon.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    Key? key,
    this.currentIndex = 0,
    required this.items,
    this.selectedColor,
  }) : super(key: key);

  final int currentIndex;
  final List<AppNavigationBarItem> items;
  final Color? selectedColor;

  static double height = 56.w;

  @override
  Widget build(BuildContext context) {
    final selectedColor = this.selectedColor ?? Theme.of(context).primaryColor;

    return Container(
      height: height,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map(
          (e) {
            final selectedItem = items[currentIndex];
            final isSelected = selectedItem == e;

            Widget icon = e.icon;
            if (icon is AppIcon) {
              icon = AppIcon(
                icon: icon.icon,
                color: isSelected ? selectedColor : icon.color,
                onTap: icon.onTap,
                size: icon.size,
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  icon,
                  Text(
                    e.label,
                    style: TextStyle(
                      color: isSelected ? selectedColor : null,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
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
  final String label;

  const AppNavigationBarItem({
    required this.icon,
    required this.label,
  });

  @override
  List<Object> get props => [icon, label];
}

getHeightBottomNavigationBar(BuildContext context) {
  final bottomHeight = AppBottomNavigationBar.height;
  final bottomPadding = MediaQuery.of(context).padding.bottom.w;

  return bottomPadding + bottomHeight;
}
