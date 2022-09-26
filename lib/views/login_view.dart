import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Email'),
            controller: _email,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Password'),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'invalid-email':
                    {
                      await showErrorDialog(
                        context,
                        'You have given an invalid email.',
                      );
                      break;
                    }
                  case 'user-not-found':
                    {
                      await showErrorDialog(
                        context,
                        'User not found in the database.',
                      );
                      break;
                    }
                  case 'wrong-password':
                    {
                      await showErrorDialog(
                        context,
                        'You provided a wrong password.',
                      );
                      break;
                    }
                  default:
                    {
                      await showErrorDialog(
                        context,
                        'Error -> ${e.code}',
                      );
                    }
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not registered yet, register!"),
          )
        ],
      ),
    );
  }
}
