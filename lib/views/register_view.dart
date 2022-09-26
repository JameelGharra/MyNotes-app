import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

import 'package:mynotes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'weak-password':
                    {
                      await showErrorDialog(
                        context,
                        "Weak password.",
                      );
                      break;
                    }
                  case 'email-already-in-use':
                    {
                      await showErrorDialog(
                        context,
                        "The email is already in use!",
                      );
                      break;
                    }
                  case 'invalid-email':
                    {
                      await showErrorDialog(
                        context,
                        "Invalid email!",
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
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login!"),
          )
        ],
      ),
    );
  }
}
