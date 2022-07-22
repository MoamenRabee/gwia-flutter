import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/modules/home/cubit/cubit.dart';
import 'package:gwia/modules/home/cubit/states.dart';
import 'package:gwia/shared/themes/colors.dart';
import 'package:gwia/shared/themes/themes.dart';
import 'package:gwia/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  NewMessage({Key? key}) : super(key: key);

  TextEditingController codeController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            MyThemes.isDarkTheme ? MyColors.darkColorBlack : Colors.grey[100],
        appBar: AppBar(
          title: Text("إرسال رسالة"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: codeController,
                          text: 'كود المستخدم',
                          textInputType: TextInputType.number,
                          icon: Icon(
                            Icons.tag,
                            color: Colors.grey,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "قم بإدخال الكود";
                            }
                            return null;
                          },
                          fillColor: MyThemes.isDarkTheme
                              ? MyColors.darkColor
                              : Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: messageController,
                          text: 'الرسالة',
                          maxLines: 5,
                          icon: Icon(
                            Icons.message,
                            color: Colors.grey,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "قم بكتابة الرسالة";
                            }
                            return null;
                          },
                          fillColor: MyThemes.isDarkTheme
                              ? MyColors.darkColor
                              : Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        cubit.isSelectedImage
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image(
                                      image: FileImage(cubit.selectedImage!),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cubit.removeSelectedImage();
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    splashRadius: 5,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            : CustomTextButton(
                                onPressed: () {
                                  cubit.selectImage();
                                },
                                text: 'اختيار صورة',
                                textColor: MyThemes.isDarkTheme
                                    ? Colors.white
                                    : MyColors.darkColorBlack,
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        cubit.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: MyColors.mainColor,
                                ),
                              )
                            : CustomButton(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    cubit.sendNewMessage(
                                      code: codeController.text,
                                      message: messageController.text,
                                      context: context,
                                    );
                                  }
                                },
                                text: 'ارسال',
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
