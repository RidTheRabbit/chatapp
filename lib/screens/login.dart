import 'package:chatapp/components/custom_TextField.dart';
import 'package:chatapp/components/custom_wideBTN.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/screens/chat_buble.dart';
import 'package:chatapp/screens/register.dart';
import 'package:chatapp/shared/show_snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                            'Login',
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
                        text: 'Login',
                        onPressed: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await loginUser();
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pushNamed(ChatBubleScreen.id, arguments: email);
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                                isLoading = false;
                              });
                            if (e.code == 'user-not-found') {
                              showSnackBar(context, 'You are not registered yet');
                            } else if (e.code == 'wrong-password') {
                              showSnackBar(context, 'Wrong password');
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
                            'Don\'t have account? ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(RegisterScreen.id);
                              },
                              child: const Text(
                                'Register',
                              )),
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

  

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
