import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_event.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_state.dart';
import 'package:wal/pages/sign_up/sign_up_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar(),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Lottie Animation (Sign Up theme)
                    Center(
                      child: Lottie.network(
                        "https://assets2.lottiefiles.com/packages/lf20_q5pk6p1k.json",
                        height: 150.h,
                      ),
                    ),
                    buildHeaderText(),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reusableText("First Name"),
                          buildTextField(
                            "Enter your first name",
                            "text",
                            "user",
                            (value) {
                              context
                                  .read<SignUpBloc>()
                                  .add(FirstNameEvent(value));
                            },
                          ),
                          reusableText("Last Name"),
                          buildTextField(
                            "Enter your last name",
                            "text",
                            "user",
                            (value) {
                              context
                                  .read<SignUpBloc>()
                                  .add(LastNameEvent(value));
                            },
                          ),
                          reusableText("Email"),
                          buildTextField(
                            "Enter your email address",
                            "email",
                            "email",
                            (value) {
                              context.read<SignUpBloc>().add(EmailEvent(value));
                            },
                          ),
                          reusableText("Password"),
                          buildTextField(
                            "Enter your password",
                            "password",
                            "lock",
                            (value) {
                              context
                                  .read<SignUpBloc>()
                                  .add(PasswordEvent(value));
                            },
                            isPassword: true,
                          ),
                          reusableText("Confirm Password"),
                          buildTextField(
                            "Confirm your password",
                            "password",
                            "lock",
                            (value) {
                              context
                                  .read<SignUpBloc>()
                                  .add(ConfirmPasswordEvent(value));
                            },
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    buildSignUpButton("Sign Up", () {
                      SignUpController(context: context).handleSignUp();
                    }),
                    buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget buildHeaderText() {
    return Container(
      padding: EdgeInsets.only(left: 25.w, top: 10.h),
      child: Text(
        "Create Account",
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget reusableText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 5.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
      ),
    );
  }

  Widget buildTextField(
    String hintText,
    String textType,
    String iconName,
    Function(String) onChanged, {
    bool isPassword = false,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: textType == "email"
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w)),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      ),
    );
  }

  Widget buildSignUpButton(String buttonName, Function() onTap) {
    return Container(
      width: 300.w,
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }

  Widget buildLoginLink() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
