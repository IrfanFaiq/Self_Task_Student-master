part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
  @override
  List<Object> get props => [];
}

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
  @override
  List<Object> get props => [];
}

// When the user signing in with google this event is called and the [AuthRepository] is called to sign in the user
class GoogleSignInRequested extends AuthEvent {@override
List<Object> get props => [];}

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends AuthEvent {@override
List<Object> get props => [];}

class CreateUserAccount extends AuthEvent{
  final UserModel userModel;
  final String email;
  CreateUserAccount(this.userModel, this.email);

  @override
  List<Object?> get props => [userModel, email];
}
