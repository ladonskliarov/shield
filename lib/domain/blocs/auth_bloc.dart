import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/repositories/auth_repository.dart';

sealed class AuthEvent extends Equatable {}

class SendLoginEvent extends AuthEvent {
  final String email, password;
  SendLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInEvent extends AuthEvent {
  SignInEvent({required this.uid});
  final String uid;

  @override
  List<Object?> get props => [uid];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

sealed class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends AuthState {
  AuthenticatedState({required this.uid});
  final String uid;

  @override
  List<Object?> get props => [uid];
}

class UnauthenticatedState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    _userSubscription = authRepository.authStateChanges.listen((user) async {
      if (user != null) {
        add(SignInEvent(uid: user.uid));
      } else {
        add(SignOutEvent());
      }
    });

    on<SendLoginEvent>((event, emit) async {
      await authRepository.signIn(event.email, event.password);
    });

    on<SignInEvent>((event, emit) => emit(AuthenticatedState(uid: event.uid)));

    on<SignOutEvent>((event, emit) async {
      await authRepository.signOut();
      emit(UnauthenticatedState());
    });

  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
