import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repo _mahakumbhRepository;

  LoginBloc({required Repo trinityRepository})
      : _mahakumbhRepository = trinityRepository,
        super(LoginInitial()) {
    on<LoadLogin>(_loadLogin);
    on<LoggedOut>(_onLoggedOut);
  }

  FutureOr<void> _loadLogin(LoadLogin event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await _mahakumbhRepository.postLogin(event: event);
      print('response:: $response');
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        print('decodedResponse $decodedResponse');
        var map = jsonDecode(decodedResponse);
        final token = map['token'];
        emit(LoginSuccess(token: token));
      } else {
        String decodedResponse = utf8.decode(response.bodyBytes);
        print('decodedResponse $decodedResponse');
        var map = jsonDecode(decodedResponse);
        emit(LoginFailed(
            errorMsg:
                map['message'] ?? "Invalid Username and Password.."));
      }
    } catch (e) {
      print(e);
      emit(const LoginFailed(errorMsg: "Something went wrong!"));
    }
  }

  //logout
  FutureOr<void> _onLoggedOut(LoggedOut event, Emitter<LoginState> emit) async {
    emit(LogoutLoading());
    try {
      final response = await _mahakumbhRepository.logout();
      if (response) {

        emit(LogoutSuccess());
      } else {
        emit(const LogoutFailed(errorMsg: "Failed to logout"));
      }
    } catch (e) {
      emit(const LogoutFailed(errorMsg: "Something went wrong!"));
      throw Exception(e);
    }
  }

}
