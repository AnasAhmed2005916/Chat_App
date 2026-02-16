import 'package:chat_app/pages/cubits/login%20cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> LoginUser({required String email, required String pass}) async {
    emit(LoginLoading());
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(errorMsg: 'User Not Found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginFailure(errorMsg: 'Wrong Password'));
      }
    } catch (ex) {
      emit(LoginFailure(errorMsg: 'Something went wrong'));
    }
  }
}
