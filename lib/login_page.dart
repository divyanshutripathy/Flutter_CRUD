import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String uname = "";
  String pass = "";
  String error = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Google auth
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: uname, password: pass);
        setState(() {
          changeButton = !changeButton;
        });
        await Future.delayed(const Duration(seconds: 1));
        // ignore: use_build_context_synchronously
        await Navigator.pushNamed(context, "/home");
        setState(() {
          changeButton = !changeButton;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            error = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            error = 'Wrong password provided for that user.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset("assets/images/log.png",
                  fit: BoxFit.cover, height: 200),
              // Instead of Padding, can even insert code in it
              // Can also use padding in the below text
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome! $uname",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "$error",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // For text field we have text field and text form field, but form field has an advantage.
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          uname = value;
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: "Username", labelText: "Enter Username"),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Username cannot be empty!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password", labelText: "Enter Password"),
                      onChanged: (value) => setState(() {
                        pass = value;
                      }),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Password cannot be empty!";
                          } else if (value.length < 6) {
                            return "Password cannot be shorted than 6 chars!";
                          }
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Material(
                borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
                color: Colors.brown,
                // InkWell is like <a> tag for the button, gives us onTap,
                // But it also gives us animations, by default, the ripple effect,
                // Only works properly when predecessor is Material
                child: InkWell(
                  onTap: () => handleLogin(context),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: 50,
                    width: changeButton ? 50 : 150,
                    alignment: Alignment.center,
                    child: changeButton
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, "/");
              //   },
              //   style: TextButton.styleFrom(
              //       backgroundColor: const Color.fromARGB(236, 137, 131, 105),
              //       minimumSize: const Size(150, 40)),
              //   child: const Text("Login"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
