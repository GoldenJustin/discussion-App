import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimbweta_app/constants/constants.dart';
import 'package:kimbweta_app/screens/screen_tabs.dart';
import 'package:kimbweta_app/screens/authentication_screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../components/link_button.dart';
import '../../components/our_material_button.dart';
import '../../components/our_text_field.dart';
import '../../components/snackbar.dart';

class SignInScreen extends StatefulWidget {
  static String id = '/signIn';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool obsecureText = true;
  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  ///Text Controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Container(
          width: double.infinity,

          ///For background gardient
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey,
                  Colors.black,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),

          child: Form(
            key: globalFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Text field for username
                OurTextField(
                  hintText: 'username',
                  obscuredText: false,
                  prefixIcon: const Icon(
                    Icons.person_2,
                    color: kMainWhiteColor,
                  ),
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Field should not be empty";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                ///Text field for password
                OurTextField(
                    hintText: 'Enter password',
                    obscuredText: obsecureText,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: kMainWhiteColor,
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obsecureText = !obsecureText;
                          });
                        },
                        child: obsecureText
                            ? const Icon(
                                Icons.visibility_off,
                                color: kMainWhiteColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: kMainWhiteColor,
                              )),
                    controller: userPasswordController,
                    keyboardType: TextInputType.text,
                    // onChanged: (input) {
                    //   password = input!;
                    //   return null;
                    // },
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Enter password";
                      }
                      if (input.length < 6) {
                        return "Password should have at least 6 characters";
                      }
                      return null;
                    }),

                ///sign In button
                OurMaterialButton(
                  label: 'Sign In',
                  onPressed: () {
                    if (validateAndSave()) {
                      _login();
                      setState(() {});
                    }
                  },
                ),

                ///Don't have an account button
                LinkButton(
                  normaltext: 'Don\'t have an account?',
                  linkedText: 'Sign Up',
                  onTap: () {
                    Navigator.pushNamed(context, SignUpScreen.id);
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _login() async {

    var data = {
      'username': userNameController.text,
      'password': userPasswordController.text,
    };

    print('--------------DATA REQUIRED TO LOGIN------------');
    print(data);
    print('------------------------------------------------');


    ///Sending the request to the login API function.
    var res = await CallApi().authenticatedPostRequest(data, 'auth/login');


    if (res != null){

      var body = json.decode(res!.body);


      if (body['msg'] == 'success') {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString("user", json.encode(body));
        localStorage.setString("token", json.encode(body['token']));


        Navigator.pushNamed(context, ScreenTabs.id);
      } else if (body['msg'] == 'Fail') {

        showSnack(context, body['reason']);


      } else {}
    } else
    {
      print('------------------------------------------------');
      print('SIGN RESPONSE IS NULL');
      print('------------------------------------------------');
    }


    // ignore: avoid_print
  }
}
