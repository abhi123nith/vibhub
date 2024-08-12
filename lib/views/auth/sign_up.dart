// ignore_for_file: avoid_print, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibhub/views/home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? username;
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
            "Sign Up",
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
              //First Name
              TextFormField(
                decoration: InputDecoration(
                  prefix: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  label: const Text('Name'),
                  //hintText: 'Please enter your email ',
                ),
                validator: ValidationBuilder().minLength(5).build(),
                onChanged: (value) {
                  username = value.trim();
                },
              ),
              const SizedBox(height: 20),

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
                          UserCredential usercred = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email!, password: password!);

                          if (usercred.user != null) {
                            var data = {
                              'username': username,
                              'email': email,
                              'created_at': DateTime.now(),
                            };
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(usercred.user!.uid)
                                .set(data);
                          }

                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      }
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text(
                  'Already have an account ?',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
