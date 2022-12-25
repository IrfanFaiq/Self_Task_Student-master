part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class CreateUser extends UserEvent{
  final UserModel userModel;
  final String email;
  const CreateUser(this.userModel, this.email);

  @override
  List<Object?> get props => [userModel];
}

class UpdateUser extends UserEvent{
  final UserModel userModel;
  final String email;
  const UpdateUser(this.userModel, this.email);

  @override
  List<Object?> get props => [userModel];
}

class GetUser extends UserEvent{
  final String email;
  const GetUser(this.email);
  @override
  List<Object?> get props => [email];
}
