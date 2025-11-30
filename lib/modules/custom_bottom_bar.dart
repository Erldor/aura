import 'package:flutter/material.dart';
import 'package:messenger/data/app_theme.dart';
import 'package:messenger/views/main_page.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  Widget bottomBarButton(IconData icon, String iconText, int buttonIndex, int pageIndex)
  {
    return Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, child: Column(mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Icon(icon, size: 40, color: pageIndex == buttonIndex ? AppTheme.mainYellowColor : AppTheme.mainTextColor,),
        Text(iconText, style: TextStyle(color: pageIndex == buttonIndex ? AppTheme.mainYellowColor : AppTheme.mainTextColor, fontWeight: FontWeight.w400),)
      ],
    ),
    onTap: () {
      currentPageIndex.value = buttonIndex;
    },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageIndex,
      builder: (context, pageIndex, child) {
        return Container(height: 100, width: double.infinity, decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: AppTheme.bottomNavigationColor
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          bottomBarButton(Icons.chat, "Чаты", 0, pageIndex),
          VerticalDivider(thickness: 0.5, indent: 20, color: AppTheme.mainTextColor,),
          bottomBarButton(Icons.person, "Профиль", 1, pageIndex),
        ],),
        );
      }
    );
  }
}