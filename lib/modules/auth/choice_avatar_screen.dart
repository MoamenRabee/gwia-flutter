import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/functions/functions.dart';
import 'package:gwia/modules/auth/cubit/cubit.dart';
import 'package:gwia/modules/auth/cubit/states.dart';
import 'package:gwia/modules/layout/layout_screen.dart';
import 'package:gwia/shared/themes/colors.dart';
import 'package:gwia/shared/widgets/widgets.dart';
import '../../models/avatar_model.dart';

class ChoiceAvatarScreen extends StatelessWidget {
  const ChoiceAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthCubit cubit = AuthCubit.get(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.darkColorBlack,
          title: Image.asset(
            "assets/images/logo.png",
            width: 150.0,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.darkColorBlack,
                MyColors.darkColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "اختار صورتك",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      "اختار الصورة الشخصية الخاصة بك ...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: avatars.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            cubit.selectAvatar(avatarName: avatars[index].name);
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border:
                                      cubit.chooseAvatar == avatars[index].name
                                          ? Border(
                                              right: BorderSide(
                                                  width: 3,
                                                  color: Colors.green),
                                              left: BorderSide(
                                                  width: 3,
                                                  color: Colors.green),
                                              top: BorderSide(
                                                  width: 3,
                                                  color: Colors.green),
                                              bottom: BorderSide(
                                                  width: 3,
                                                  color: Colors.green),
                                            )
                                          : null,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Image.asset(avatars[index].path),
                              ),
                              if (cubit.chooseAvatar == avatars[index].name)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    cubit.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: MyColors.mainColor,
                            ),
                          )
                        : CustomButton(
                            text: "تأكيد",
                            onPressed: () {
                              cubit.changeAvatarImage(context);
                            },
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
