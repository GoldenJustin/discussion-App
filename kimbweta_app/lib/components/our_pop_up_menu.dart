import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../screens/authentication_screens/sign_in_screen.dart';
import 'whiteboard.dart';

class OurPopOutMenu extends StatefulWidget {
  const OurPopOutMenu({
    super.key,
  });

  @override
  State<OurPopOutMenu> createState() => _OurPopOutMenuState();
}

class _OurPopOutMenuState extends State<OurPopOutMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
            },
          ),
        ),
        // PopupMenuItem(
        //   child: ListTile(
        //     leading: const Icon(Icons.file_copy),
        //     title: const Text('Group file uploads'),
        //     onTap: (){
        //       Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (context) => All_DocumentsScreen(
        //         widget.id,
        //         widget.name,
        //         widget.code,
        //         widget.description,
        //         widget.created_at,
        //       )));
        //     },
        //   ),
        // ),



      ],
    );
  }
}











