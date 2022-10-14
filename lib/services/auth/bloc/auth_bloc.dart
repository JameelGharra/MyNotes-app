import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/cloud/sharing_service/cloud_sharing_storage.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';
import 'package:mynotes/services/cloud/user_administration/users_administration.dart';

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
        UserData().userId = user.id;
        UserData().userEmail = user.email;
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
          final createdUser = await provider.createUser(
            email: event.email,
            password: event.password,
          );
          await UsersAdministration().createUser(
            userId: createdUser.id,
            email: createdUser.email,
          );
          await SharingStorage().createSharingForUser(userId: createdUser.id);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    // register directing
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(
          const AuthStateRegistering(exception: null, isLoading: false),
        );
      },
    );
    // email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state); // we are going to stay in the same state of email
      },
    );
    // forgot password (reset)
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          haveSentEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          // the user just wanted to go to the forgot pass screen
          return;
        }
        // the user wants to actually send forgot password email request
        emit(const AuthStateForgotPassword(
          exception: null,
          haveSentEmail: false,
          isLoading: true,
        ));
        // locals to know if email was sent or not
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          exception = e;
          didSendEmail = false;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          haveSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
  }
}
