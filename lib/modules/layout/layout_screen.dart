import 'package:gwia/modules/home/cubit/cubit.dart';
import 'package:gwia/modules/home/cubit/states.dart';
import 'package:gwia/modules/layout/cubit/cubit.dart';
import 'package:gwia/modules/layout/cubit/states.dart';
import 'package:gwia/shared/themes/colors.dart';
import 'package:gwia/shared/themes/themes.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../functions/functions.dart';
import '../home/new_message.dart';

TextEditingController codeController = TextEditingController();

class LayoutScreen extends StatelessWidget {
  LayoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset(
                "assets/images/logo.png",
                width: 130.0,
              ),
            ),
            body: cubit.screens[cubit.bottomNavigationBarIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                NavigatorTo(context, NewMessage());
              },
              tooltip: 'رسالة جديدة',
              backgroundColor:
                  MyThemes.isDarkTheme ? MyColors.darkColorBlack : Colors.white,
              child: Icon(
                Icons.forward_to_inbox,
                color: MyThemes.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
              tabBuilder: (index, taped) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cubit.bottomNavigationBarItems[index].values.first,
                      size: 20,
                      color: taped ? MyColors.mainColor : Colors.grey,
                    ),
                    Text(
                      cubit.bottomNavigationBarItems[index].keys.first,
                      style: TextStyle(
                          fontSize: 12,
                          color: taped ? MyColors.mainColor : Colors.grey),
                    )
                  ],
                );
              },
              itemCount: cubit.bottomNavigationBarItems.length,
              backgroundColor:
                  MyThemes.isDarkTheme ? MyColors.darkColorBlack : Colors.white,
              elevation: 2,
              activeIndex: cubit.bottomNavigationBarIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.defaultEdge,
              leftCornerRadius: 25,
              rightCornerRadius: 25,
              splashRadius: 0,
              splashSpeedInMilliseconds: 300,
              onTap: (index) {
                cubit.changeBottomNavigationBarIndex(index);
              },
            ),
          ),
        );
      },
    );
  }
}
