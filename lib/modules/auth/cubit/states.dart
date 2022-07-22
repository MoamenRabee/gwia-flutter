abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthChooseAvatarState extends AuthStates {}

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  late String error;
  RegisterErrorState(this.error);
}

class ChangeAvatarLoadingState extends AuthStates {}

class ChangeAvatarSuccessState extends AuthStates {}

class ChangeAvatarErrorState extends AuthStates {
  late String error;
  ChangeAvatarErrorState(this.error);
}

class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpErrorState extends AuthStates {
  late String error;
  SignUpErrorState(this.error);
}

class SignOutLoadingState extends AuthStates {}

class SignOutSuccessState extends AuthStates {}

class SignOutErrorState extends AuthStates {
  late String error;
  SignOutErrorState(this.error);
}
