import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validated/validated.dart' as validate;

import '../../shared/themes/colors.dart';
import '../../shared/widgets/widgets.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthCubit cubit = AuthCubit.get(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/logo.png",
            width: 130.0,
          ),
          backgroundColor: MyColors.darkColorBlack,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
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
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Container(
                    width: 500.0,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "إنشاء حساب",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "إنشاء حساب جديد عن طريق البريد الإلكترونى ...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            controller: usernameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "أكتب اسم المستخدم";
                              }
                              if (val.length < 6) {
                                return "الحد الأدنى 6 حروف";
                              }
                              return null;
                            },
                            textInputType: TextInputType.text,
                            icon: Icon(Icons.alternate_email),
                            text: "اسم المستخدم",
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            controller: passwordController,
                            validator: (val) {
                              if (val!.length < 6) {
                                return "الحد الأدنى 6 حروف";
                              }
                              return null;
                            },
                            icon: Icon(Icons.lock),
                            text: "كلمة المرور",
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            controller: confirmPasswordController,
                            validator: (val) {
                              if (val!.length < 6) {
                                return "الحد الأدنى 6 حروف";
                              }
                              if (passwordController.text != val) {
                                return "كلمتان السر غير متشابهان";
                              }
                              return null;
                            },
                            icon: Icon(Icons.lock),
                            text: "كلمة المرور",
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          cubit.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: MyColors.mainColor,
                                  ),
                                )
                              : CustomButton(
                                  text: "إنشاء الحساب",
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.registerWithEmailAndPassword(
                                        context: context,
                                        username: usernameController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "هل لديك حساب ؟",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              CustomTextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: "تسجيل الدخول",
                                textColor: MyColors.mainColor,
                              )
                            ],
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
      ),
    );
  }
}
