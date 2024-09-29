part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String token;

  const LoginSuccess({required this.token});

}

final class LoginFailed extends LoginState {
  final String errorMsg;

  const LoginFailed({required this.errorMsg});
}

//logout
class LogoutSuccess extends LoginState {}

final class LogoutLoading extends LoginState {}

class LogoutFailed extends LoginState {
  final String errorMsg;

  const LogoutFailed({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
