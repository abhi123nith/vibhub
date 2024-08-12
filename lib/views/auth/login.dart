// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibhub/views/auth/sign_up.dart';
import 'package:vibhub/views/home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
              child: Text(
            "Login",
            style: TextStyle(fontFamily: GoogleFonts.ibmPlexSans().fontFamily),
          )),
        ),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              //Email
              TextFormField(
                decoration: InputDecoration(
                  prefix: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  label: const Text('Email'),
                  //  hintText: 'Please enter your email ',
                ),
                validator: ValidationBuilder().email().maxLength(50).build(),
                onChanged: (value) {
                  email = value.trim();
                },
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefix: const Icon(Icons.lock_open),
                  suffix: const Icon(Icons.remove_red_eye),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  label: const Text('Password'),
                  //hintText: 'Please enter your password '
                ),
                validator:
                    ValidationBuilder().maxLength(15).minLength(6).build(),
                onChanged: (value) {
                  password = value.trim();
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      if (key.currentState?.validate() ?? false) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );
                          if (mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'wrong-password') {
                            print('The password  is wrong.');
                          }

                          if (e.code == 'user-not-found') {
                            print('User not found.');
                          }
                        } catch (e) {
                          // ignore: duplicate_ignore
                          // ignore: avoid_print
                          print(e);
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUp()));
                  },
                  child: const Text('Create an account ?'))
            ],
          ),
        ),
      ),
    );
  }
}
