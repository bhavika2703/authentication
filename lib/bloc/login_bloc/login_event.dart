// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoadLogin extends LoginEvent {
  final String user;
  final String password;

  const LoadLogin({
    required this.user,
    required this.password,

  });

  @override
  List<Object> get props => [user, password, ];
}

class LoggedOut extends LoginEvent {}
