class RegisterState {}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState{}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String errorMsg;
  RegisterFailure({required this.errorMsg});
}
