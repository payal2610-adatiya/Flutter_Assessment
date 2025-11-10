part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}
