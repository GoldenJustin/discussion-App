// import 'package:flutter/material.dart';
// import 'package:kimbweta_app/api/api_service.dart';
// import 'package:kimbweta_app/models/login_model.dart';
// import 'package:kimbweta_app/screens/progressHUD.dart';
//
// class ValidationScreen extends StatefulWidget {
//   const ValidationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ValidationScreen> createState() => _ValidationScreenState();
// }
//
// class _ValidationScreenState extends State<ValidationScreen> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   bool hidePassword = true;
//   LoginRequestModel? requestModel;
//   bool isApiCallProcess = false;
//
//   @override
//   void initState(){
//     super.initState();
//    requestModel = LoginRequestModel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ProgressHUD(child: _uiSetup(context),
//         inAsyncCall: isApiCallProcess,
//       opacity: 0.3,
//     );
//   }
//
//   @override
//   Widget _uiSetup(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Theme.of(context).primaryColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(vertical:  30.0, horizontal: 20.0),
//                   margin: EdgeInsets.symmetric(vertical: 85.0, horizontal: 20.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Theme.of(context).hintColor.withOpacity(0.2),
//                         offset: Offset(0,10),
//                         blurRadius: 20
//                       )
//                     ]
//                   ),
//                   child: Form(
//                     key: globalFormKey,
//                     child: Column(
//                       children: [
//                         SizedBox(height: 25,),
//                         Text(
//                           "login",style: Theme.of(context).textTheme.headlineMedium,
//                         ),
//                         SizedBox(height: 20,),
//                         TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           onSaved: (input)=> requestModel!.email = input ,
//                           validator: (input)=> !input!.contains("@") ? "Email Id should be valid!"
//                               : null,
//                           decoration: InputDecoration(
//                             hintText: "Email Adress",
//                             enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Theme.of(context).primaryColor.withOpacity(0.2)
//                                 ),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).primaryColor
//                               ),
//                             ),
//                             prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor,)
//                           ),
//                         ),
//                         SizedBox(height: 20,),
//                         TextFormField(
//                           keyboardType: TextInputType.text,
//                           onSaved: (input)=> requestModel!.password = input,
//                           validator: (input)=> input!.length < 3 ?"Password should have atleatst 3 characters"
//                               : null,
//                           obscureText: hidePassword,
//                           decoration: InputDecoration(
//                               hintText: "Password",
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Theme.of(context).primaryColor.withOpacity(0.2)
//                                 ),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Theme.of(context).primaryColor
//                                 ),
//                               ),
//
//                               prefixIcon: Icon(Icons.password, color: Theme.of(context).primaryColor,),
//                               suffixIcon: InkWell(
//                                 onTap: (){
//                                   setState(() {
//                                     hidePassword = !hidePassword;
//                                   });
//                                 },
//                                 child: Icon(
//                                  hidePassword ?  Icons.visibility_off : Icons.visibility,
//                                     color: Theme.of(context).primaryColor.withOpacity(0.4)
//                                 ),
//                               )
//                           ),
//                         ),
//                          SizedBox(height: 20,),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: StadiumBorder()
//                           ),
//                             onPressed: (){
//                             if(validateAndSave()){
//                               setState(() {
//                                 isApiCallProcess = true;
//                               });
//                               APIService apiService = APIService();
//                               apiService.login(requestModel!).then((value){
//                                 setState(() {
//                                 isApiCallProcess = false;
//                                 });
//
//                                   if(value.token!.isNotEmpty){
//                              final snackBar =      SnackBar(
//                                         content: Text("Login Successful"));
//                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//                                   } else{
//                                     final snackBar = SnackBar(
//                                         content: Text('${value.error}'));
//                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);                                  }
//                               });
//
//                               print(requestModel!.toJson());
//                             }
//                             },
//                             child: Text("Login"),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         )
//       ),
//     );
//   }
//
//   bool validateAndSave(){
//      final form = globalFormKey.currentState;
//      if(form!.validate()){
//        form.save();
//        return true;
//      }
//      return false;
//   }
// }
