import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Logging in..',
        ));
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
        if (user.isEmailVerified) {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        } else {
          emit(const AuthStateNeedsVerification(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
    // log out
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    // register
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          await provider.createUser(
            email: event.email,
            password: event.password,
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    // email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state); // we are going to stay in the same state of email
      },
    );
  }
}
