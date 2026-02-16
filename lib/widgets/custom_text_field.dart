import 'package:chat_app/pages/cubits/eye%20cubit/eye_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.hintText,
    this.obsecureText = false,
    required this.controller,
  });
  String? hintText;
  final bool obsecureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EyeCubit, bool>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'field is required';
            }
            return null;
          },
          obscureText: obsecureText ? state : false,
          decoration: InputDecoration(
            suffixIcon: obsecureText
                ? IconButton(
                    onPressed: () {
                      context.read<EyeCubit>().toggleEyeIcon();
                    },
                    icon: Icon(state ? Icons.visibility_off : Icons.visibility , color: Colors.white,),
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
