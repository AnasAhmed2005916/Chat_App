import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 55,),
                CircleAvatar(radius: 70, backgroundImage: AssetImage(kLogo)),

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
                CustomTextField(
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Password',
                  onChanged: (data) {
                    password = data;
                  },
                  obsecureText: true,
                ),
                SizedBox(height: 50),
                CustomButton(
                  text: 'LOGIN',
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await LoginSuccess(context);
                        Navigator.pushNamed(
                          context,
                          ChatPage.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        LoginErrorFirebase(context, e);
                      } catch (error) {
                        LoginError(context, error);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      print('Error Message');
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

  Future<void> LoginSuccess(BuildContext context) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('Success')),
    );
  }
}


/*
firebase => flutter fire

anasahmed666@gmail.com
anasahmed444@666
 
 
  */