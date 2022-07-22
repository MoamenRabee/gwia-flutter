import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/functions/functions.dart';
import 'package:gwia/modules/home/cubit/cubit.dart';
import 'package:gwia/modules/home/cubit/states.dart';
import 'package:gwia/services/services.dart';
import 'package:gwia/shared/local/cache_helper.dart';
import 'package:gwia/shared/themes/colors.dart';
import 'package:gwia/shared/themes/themes.dart';
import 'package:gwia/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../shared/screens/image_viewer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    cubit.get_messages();

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<String> favoratesList = CacheHelper.getList(key: "favorates");

        if (cubit.isLoadingGetMessages) {
          return Center(
            child: CircularProgressIndicator(color: MyColors.mainColor),
          );
        } else if (cubit.messages.isEmpty) {
          return Center(
            child: customText(
              text: "لا يوجد رسائل",
              size: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomListViewMessages(
              cubit: cubit,
              favoratesList: favoratesList,
              messages: cubit.messages,
              isMySentMessage: false,
            ),
          );
        }
      },
    );
  }
}
