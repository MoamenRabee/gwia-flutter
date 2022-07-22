import 'package:flutter/material.dart';
import 'package:gwia/models/message_model.dart';
import 'package:gwia/shared/themes/themes.dart';

import '../../functions/functions.dart';
import '../../modules/home/cubit/cubit.dart';
import '../../services/services.dart';
import '../screens/image_viewer.dart';
import '../themes/colors.dart';

Text customText(
    {required String text,
    double? size,
    Color? color,
    int? maxLines,
    FontWeight? fontWeight}) {
  return Text(
    text,
    style: TextStyle(
      color: color ?? (MyThemes.isDarkTheme ? Colors.white : Colors.black),
      fontSize: size,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines ?? 5,
    overflow: TextOverflow.ellipsis,
  );
}

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    required this.controller,
    required this.text,
    required this.icon,
    required this.validator,
    this.isPassword,
    this.textInputType,
    this.fillColor,
    this.maxLines,
  });

  TextEditingController controller;
  String text;
  Icon icon;
  bool? isPassword;
  String? Function(String?)? validator;
  TextInputType? textInputType;
  Color? fillColor;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines ?? 1,
      obscureText: isPassword ?? false,
      validator: validator,
      style:
          TextStyle(color: MyThemes.isDarkTheme ? Colors.white : Colors.black),
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        label: Text(text),
        labelStyle: TextStyle(color: Colors.grey),
        fillColor: fillColor ?? Colors.white,
        filled: true,
        prefixIcon: icon,
        focusColor: MyColors.mainColor,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  });

  void Function()? onPressed;
  String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: MyColors.mainColor,
        minWidth: double.infinity,
        height: 60.0,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.textColor,
  });

  void Function()? onPressed;
  String text;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomListViewMessages extends StatelessWidget {
  CustomListViewMessages({
    Key? key,
    required this.messages,
    required this.favoratesList,
    required this.cubit,
    required this.isMySentMessage,
  }) : super(key: key);

  List<MessageModel> messages;
  List<String> favoratesList;
  HomeCubit cubit;
  bool isMySentMessage;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        String date = messages[index].created_date.toString().substring(0, 10);

        String time = messages[index].created_date.toString().substring(11, 16);

        return Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: MyThemes.isDarkTheme
                ? MyColors.darkColorBlack
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          child: Column(
            children: [
              if (messages[index].image != null)
                InkWell(
                  onTap: () {
                    NavigatorTo(
                      context,
                      ImageViewerScreen(
                        messageModel: messages[index],
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.white,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: DioHelper.base_link +
                            messages[index].image.toString(),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholderFit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: customText(
                  text: "${messages[index].message}",
                  size: 17,
                ),
              ),
              Divider(
                color: Colors.grey[300],
                height: 5,
                indent: 30,
                thickness: 0.5,
                endIndent: 30,
              ),
              isMySentMessage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: customText(
                            text:
                                "مرسل الى : ${cubit.send_messages[index].receiver_code} | ${cubit.send_messages[index].receiver_username}",
                            color: Colors.grey,
                            size: 12,
                          ),
                        ),
                        customText(
                          text: "$time : $date",
                          color: Colors.grey,
                          size: 12,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customText(
                          text: "$time : $date",
                          color: Colors.grey,
                          size: 14,
                        ),
                        IconButton(
                          constraints: BoxConstraints(maxHeight: 20),
                          splashRadius: 20,
                          onPressed: () {
                            cubit.add_remove_favorate(
                                messageId: messages[index].id.toString());
                          },
                          icon: favoratesList
                                  .contains(messages[index].id.toString())
                              ? Icon(
                                  Icons.favorite,
                                  color: MyColors.mainColor,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: MyColors.mainColor,
                                ),
                          padding: EdgeInsets.all(0),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.0),
      itemCount: messages.length,
    );
  }
}
