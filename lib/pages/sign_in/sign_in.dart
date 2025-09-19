// sign_in.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_event.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_state.dart';
import 'package:wal/pages/sign_in/sign_in_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar(),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildThirdPartyLogin(context),
                          Center(
                            child: reusableText(
                                "Or use your email account to login"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60.h),
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                reusableText("Email"),
                                buildTextField(
                                  "Enter your email address",
                                  "email",
                                  "user",
                                  (value) {
                                    context
                                        .read<SignInBloc>()
                                        .add(EmailEvent(value));
                                  },
                                ),
                                reusableText("Password"),
                                buildTextField(
                                  "Enter your password",
                                  "password",
                                  "lock",
                                  (value) {
                                    context
                                        .read<SignInBloc>()
                                        .add(PasswordEvent(value));
                                  },
                                ),
                              ],
                            ),
                          ),
                          forgotPassword(),
                          buildLogInAndRegButton("Log In", "login", () {
                            SignInController(context: context)
                                .handleSignIn("email");
                          }),
                          buildLogInAndRegButton("Register", "register", () {
                            Navigator.of(context).pushNamed("/register");
                          }),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Example AppBar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Sign In",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Example reusableText
  Widget reusableText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
      ),
    );
  }

  // 🔹 Example TextField builder
  Widget buildTextField(
    String hintText,
    String type,
    String iconName,
    Function(String)? onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
      child: TextField(
        obscureText: type == "password" ? true : false,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            type == "email" ? Icons.email : Icons.lock,
            color: Colors.grey,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  // 🔹 Example forgot password widget
  Widget forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 25.w, bottom: 20.h),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/forgot_password");
        },
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  // 🔹 Example login/register button
  Widget buildLogInAndRegButton(
    String buttonText,
    String type,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: type == "login" ? Colors.blue : Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  // 🔹 Example third-party login placeholder
  Widget buildThirdPartyLogin(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, bottom: 20.h),
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () {
          // e.g., Google login
        },
        icon: const Icon(Icons.g_mobiledata, color: Colors.white),
        label: const Text("Sign in with Google"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}
