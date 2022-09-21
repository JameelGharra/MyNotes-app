import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Column(
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
              final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);

              print(userCredential);
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case 'user-not-found':
                  {
                    print('User not found.');
                    break;
                  }
                case 'wrong-password':
                  {
                    print("Wrong password.");
                    break;
                  }
              }
            }
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
