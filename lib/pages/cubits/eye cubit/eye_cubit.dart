import 'package:flutter_bloc/flutter_bloc.dart';

class EyeCubit extends Cubit<bool> {
  EyeCubit() : super(true);
  void toggleEyeIcon() => emit(!state);
}
