import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/functions/functions.dart';
import 'package:gwia/modules/home/cubit/cubit.dart';
import 'package:gwia/modules/home/cubit/states.dart';
import 'package:gwia/shared/screens/image_viewer.dart';
import '../../services/services.dart';
import '../../shared/themes/colors.dart';
import '../../shared/themes/themes.dart';
import '../../shared/widgets/widgets.dart';

class SendMessagesScreen extends StatelessWidget {
  const SendMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    cubit.get_send_messages();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (cubit.isLoadingGetSendMessages) {
          return Center(
            child: CircularProgressIndicator(color: MyColors.mainColor),
          );
        } else if (cubit.send_messages.isEmpty) {
          return Center(
            child: customText(
              text: "لا يوجد رسائل مرسلة",
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
              favoratesList: [],
              messages: cubit.send_messages,
              isMySentMessage: true,
            ),
          );
        }
      },
    );
  }
}
