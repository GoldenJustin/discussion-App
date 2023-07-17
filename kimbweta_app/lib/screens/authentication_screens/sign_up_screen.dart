import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimbweta_app/constants/constants.dart';
import 'package:kimbweta_app/screens/authentication_screens/sign_in_screen.dart';
import '../../api/api.dart';
import '../../components/link_button.dart';
import '../../components/our_material_button.dart';
import '../../components/our_text_field.dart';
import 'package:kimbweta_app/components/progressHUD.dart';
import '../../components/snackbar.dart';


class SignUpScreen extends StatefulWidget {
  static String id = 'signUp';

  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  // bool isApiCallProcess = false;

  ///Text Controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  bool obsecureText = true;


  // @override
  // void initState() {
  //   super.initState();
  //   registerRequestModel = RegisterRequestModel();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return ProgressHUD(child: _uiSetup(context),
  //     inAsyncCall: isApiCallProcess,
  //     opacity: 0.3,
  //   );
  // }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Container(
          width: double.infinity,

          ///For background gradient
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
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),

            child: Form(
              key: globalFormKey,
              child: ListView(
                children: [

                  ///Text field for userName
                  OurTextField(
                    hintText: 'User Name',
                    obscuredText: false,
                    prefixIcon: const Icon(
                      Icons.person_2,
                      color: kMainWhiteColor,
                    ),
                    controller: userNameController,

                    // onChanged: (input) {
                    //   userName = input!;
                    //   return null;
                    // },
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Field should not be empty";
                      }

                      if (input.contains("<") ||
                          input.contains(">") ||
                          input.contains("/")) {
                        return "Special characters not required!";
                      }
                    },
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ///Text field for email
                  OurTextField(
                    hintText: 'email',
                    obscuredText: false,
                    prefixIcon: const Icon(
                      Icons.email_sharp,
                      color: kMainWhiteColor,
                    ),
                    controller: userEmailController,
                    keyboardType: TextInputType.emailAddress,
                    // onChanged: (input) {
                    //   email = input!;
                    // },
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Field should not be empty";
                      }

                      if (!input.contains("@")) {
                        return "Email should be valid";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ///Text field for password
                  OurTextField(
                      hintText: 'Create password',
                      obscuredText: obsecureText,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: kMainWhiteColor,
                      ),
                      suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              obsecureText = !obsecureText;
                            });
                          },
                          child: obsecureText ? const Icon(Icons.visibility_off, color: kMainWhiteColor,) : const Icon(Icons.visibility, color: kMainWhiteColor,)),
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

                  const SizedBox(
                    height: 20,
                  ),

                  ///Text field for confirm password
                  // OurTextField(
                  //     hintText: 'Confirm Password',
                  //     obscuredText: true,
                  //     icon: const Icon(
                  //       Icons.lock_outline,
                  //       color: kMainWhiteColor,
                  //     ),
                  //     onChanged: (input) {
                  //       _confirmPassword = input!;
                  //     },
                  //     validator: (input) {
                  //       if (input!.isEmpty) {
                  //         return "Required password for match";
                  //       }
                  //       if (input != password) {
                  //         return 'Password do not match';
                  //       }
                  //       return null;
                  //     }),

                  ///Text field for Phone number
                  OurTextField(
                      hintText: 'Enter Phone number',
                      obscuredText: false,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: kMainWhiteColor,
                      ),
                      keyboardType: TextInputType.phone,
                      controller: userPhoneController,
                      // onChanged: (input) {
                      //   _confirmPassword = input!;
                      // },
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Required NUMBER for match";
                        }
                        return null;
                      }),


                  ///Button For registering
                  OurMaterialButton(label: 'Sign Up', onPressed: (){
                    if(validateAndSave()){
                      if (validateAndSave()) {
                        _register();
                        setState(() {
                        });

                      }
                    }
                  },),

                  ///Have an account? button
              LinkButton(normaltext: 'Have an account?', linkedText: 'Sign In', onTap: (){
                Navigator.pushNamed(context, SignInScreen.id);
              },),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
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

  ///function that assigns the validated inputs into the registerRequest
  // void _sendRegisterRequest() {
  //   registerRequestModel!.userName = userName;
  //   registerRequestModel!.email = email;
  //   registerRequestModel!.password = password;
  // }



  void _register() async{

    var data = {
      'username': userNameController.text,
      'email': userEmailController.text,
      'password': userPasswordController.text,
      'phone': userPhoneController.text,
      // 'type': 'driver',

    };

    print('xxxxxxxx-------AWESOMEEEEEEEEEEEEEEEEEEE------xxxxxxxxx');
    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'auth/register');

    if (res == null) {
      // setState(() {
      //   _isLoading = false;
      //   // _not_found = true;
      // });
      // showSnack(context, 'No Network!');
    }
    else {
      var body = json.decode(res!.body);
      print(body);
      setState(() {
      });

      if (res.statusCode == 200) {
        // SharedPreferences localStorage = await SharedPreferences.getInstance();
        // // localStorage.setString("token", body['token']);
        // localStorage.setString("user", json.encode(body));
        // localStorage.setString("token", json.encode(body['access']));
        // localStorage.setString("phone_number", userNumberController.text);


        Navigator.pushNamed(context, SignInScreen.id);
        showSnack(context, 'You Have registered!');


      } else if (res.statusCode == 400) {
        print('hhh');
        // setState(() {
        //   _isLoading = false;
        //   _not_found = true;
        // });
      } else {}
    }
  }


}

