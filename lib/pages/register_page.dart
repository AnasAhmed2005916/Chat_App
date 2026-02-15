import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static String id = "RegisterPage";
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // static => you can access by the class
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();
  // create a key => used in form
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                      ' REGISTER',
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
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await RegisterUser(context);
                          Navigator.pushNamed(context, ChatPage.id);
                        } on FirebaseAuthException catch (error) {
                          showSnackBarFromFirebase(context, error);
                        } catch (error) {
                          ShowSnackBar(context, error);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        print('Error message');
                      }
                    },
                    text: 'REGISTER',
                  ),

                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'already have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'LOGIN',
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
      ),
    );
  }

  void ShowSnackBar(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text('$error')),
    );
  }

  void showSnackBarFromFirebase(
    BuildContext context,
    FirebaseAuthException error,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error: ${error.code}'),
      ),
    );
  }

  Future<void> RegisterUser(BuildContext context) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('Success')),
    );
  }
}
