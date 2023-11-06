import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool isSigningIn = false;
  bool toggleAuthButton = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toggleAuthButton ? 'Sign Up' : 'Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: isSigningIn
                    ? null
                    : () async {
                        try {
                          setState(() {
                            isSigningIn = true;
                          });
                          if (toggleAuthButton) {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          } else {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          }
                        } catch (e) {
                          if (email.text.trim().isEmpty ||
                              password.text.trim().isEmpty) {
                            Toast.show("Please fill all the fields!",
                                duration: 2);
                          } else {
                            Toast.show(e.toString(), duration: 2);
                          }
                          print(e);
                        } finally {
                          setState(() {
                            isSigningIn = false;
                          });
                        }
                      },
                child: Text(toggleAuthButton ? 'Sign Up' : 'Login'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    toggleAuthButton = !toggleAuthButton;
                  });
                },
                child: Text(
                  toggleAuthButton
                      ? 'Already have an account? Login'
                      : "Don't have an account? Sign Up",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
