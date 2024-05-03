import 'package:chatapp/components/custom_TextField.dart';
import 'package:chatapp/components/custom_wideBTN.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/shared/show_snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String get id => 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgColor,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: screenHeight,
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Image.asset(
                        'assets/images/scholar.png',
                      ),
                      const Text(
                        'Scholar Chat',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                            fontStyle: FontStyle.italic,
                            fontSize: 30),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter The Email';
                          }
                          return null;
                        },
                        text: 'Email',
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter The Password';
                          }
                          return null;
                        },
                        text: 'Password',
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomWideBTN(
                        text: 'Register',
                        onPressed: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                  isLoading = true;
                                });
                              await registerUser();
                              setState(() {
                                  isLoading = false;
                                });
                              showSnackBar(context, 'Account Created Succefully, Login Now');
                              Navigator.of(context).pop();
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                                  isLoading = false;
                                });
                            if (e.code == 'weak-password') {
                              showSnackBar(context,'your password is weak');
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(context, 'Email Already Used');
                            }
                          } catch (e) {
                            setState(() {
                                  isLoading = false;
                                });
                            showSnackBar(context, 'Unknown error was occured');
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Login')),
                        ],
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
