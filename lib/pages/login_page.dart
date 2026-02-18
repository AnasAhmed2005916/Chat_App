import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubits/chat%20cubit/chat_cubit.dart';
import 'package:chat_app/pages/cubits/login%20cubit/login_cubit.dart';
import 'package:chat_app/pages/cubits/login%20cubit/login_state.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text('Success Login'),
              ),
            );
            context
                .read<ChatCubit>()
                .getMessages(); // get all messages before navigate to chat page
            Navigator.pushNamed(context, ChatPage.id, arguments: email.text);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMsg),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 55),
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(kLogo),
                    ),

                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        textAlign: TextAlign.left,
                        ' LOGIN',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(hintText: 'Email', controller: email),
                    SizedBox(height: 20),
                    CustomTextField(
                      hintText: 'Password',
                      controller: password,

                      obsecureText: true,
                    ),
                    SizedBox(height: 50),
                    CustomButton(
                      text: 'LOGIN',
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          context.read<LoginCubit>().LoginUser(
                            email: email.text,
                            pass: password.text,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'don\'t have an account?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'REGISTER',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void LoginError(BuildContext context, Object error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$error')));
  }

  void LoginErrorFirebase(BuildContext context, FirebaseAuthException e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text('Error: ${e.code}')),
    );
  }
}

/*
firebase => flutter fire

anasahmed666@gmail.com
anasahmed444@666
 
 
  */
