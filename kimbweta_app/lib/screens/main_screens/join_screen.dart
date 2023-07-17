import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimbweta_app/components/our_material_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../components/custom_input_field.dart';
import '../../components/loading_component.dart';
import '../../components/snackbar.dart';
import '../../constants/constants.dart';
import '../../models/discussion_group.dart';
import '../background_screens/joined_discussion_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  var userData, next;
  bool checkStatus = false;
  List<JoinGroup_Item>? join_group_data;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    //listenNotifications();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
    print(userData);
    fetchJoinGroupData();
  }

  fetchJoinGroupData() async {
    String url = 'joined_group/' + userData['user']['id'].toString();
    // var customer = userData['id'].toString();
    // if (next != null) {
    //   url = url_format(next);
    // }
    var res = await CallApi().authenticatedGetRequest(url, context: context);

    // print(res);
    if (res != null) {
      var body = json.decode(res.body);
      print(body);

      var theJoinGroups = body;
      List<JoinGroup_Item> _join_group_items = [];
      // if (next != null) {
      //   _join_group_items = join_group_data!;
      // }

      for (var field in theJoinGroups) {
        JoinGroup_Item join_group_items = JoinGroup_Item(
          field['id'].toString(),
          field['name'].toString(),
          field['code'].toString(),
          field['description'].toString(),
          field['created_at'].toString(),
        );
        _join_group_items.add(join_group_items);
      }

      print('---------------MY JOINED GROUP ITEMS--------------------');
      print('------------------${_join_group_items.length}------------');
      print('------------------------------------------------');

      // setState(() {
      //   loading = false;
      // });

      setState(() {
        checkStatus = true;
        join_group_data = _join_group_items;
      });
    } else {
      showSnack(context, 'No network');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (checkStatus == false) {
      return const LoadingComponent();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Log out",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: (join_group_data!.length == 1)
            ? Text(
                '[ You are in  ${join_group_data!.length} Group]',
                style: const TextStyle(
                    fontFamily: 'Montserrat2',
                    color: kDiscussionDescriptionColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            : Text(
                '[  You are in  ${join_group_data!.length}  Groups  ]',
                style: const TextStyle(
                    fontFamily: 'Montserrat2',
                    color: kDiscussionDescriptionColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 2.0),
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

              ///Displays the discussions created
              child: join_group_Component(),
            ),
          )
        ],
      ),

      /// Michael Michael modified FBA
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          // selectFile();
          _join_Group_Dialog(context);
        },
        label: const Text('Join Group'),
        backgroundColor: kMainThemeAppColor,
      ),
    );
  }

  join_group_Component() {
    print("----------------");
    print(join_group_data!.length);
    if (join_group_data == null) {
      return Center(
        child: Text('No Network or Connection...'),
      );
    } else if (join_group_data != null && join_group_data?.length == 0) {
      // No Data
      return const Center(
          child: Text(
        'No Group Joined Yet!',
        style: TextStyle(color: kMainWhiteColor),
      ));
    } else {
      return ListView.builder(
          itemCount: join_group_data!.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            int reverseIndex = join_group_data!.length - 1 - index;

            return Card(
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              elevation: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinedDiscussionScreen(
                          gpId: join_group_data![reverseIndex].id,
                          name: join_group_data![reverseIndex].name,
                          code: join_group_data![reverseIndex].code,
                          description:
                              join_group_data![reverseIndex].description,
                          created_at:
                              join_group_data![reverseIndex].created_at),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    join_group_data![reverseIndex].name,
                    style: const TextStyle(
                      color: kMainWhiteColor,
                      letterSpacing: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${join_group_data![reverseIndex].description}',
                    style: const TextStyle(
                        color: Colors.white24,
                        fontFamily: 'Montserrat2',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 9),
                  ),
                  // trailing: Text('00:00'),
                  leading: Image.asset('images/group_logo.png'),
                ),
              ),
            );
          });
    }
  }

  ///Our Pop Dialog
  _join_Group_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Form(
              child: Column(
                children: [
                  CustomInputField(
                    controller: codeController,
                    hintText: 'Enter Group Code',
                    textInputAction: TextInputAction.next,
                  ),
                  // _contentServices(context),

                  const SizedBox(
                    height: 2,
                  ),

                  OurMaterialButton(
                      label: 'Join',
                      onPressed: () {
                        _joinGroup_API();
                        fetchJoinGroupData();
                        setState(() {
                          _scrollController.animateTo(
                            0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  ///Function to join a crated group
  _joinGroup_API() async {
    var data = {
      'user_id': userData['user']['id'],
      'code': codeController.text,
      // 'created_by': userData['user']['id'],
      // 'type': 'driver',
    };

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'join_group');
    if (res == null) {
      // setState(() {
      //   _isLoading = false;
      //   // _not_found = true;
      // });
      // showSnack(context, 'No Network!');
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        showSnack(context, 'Group Joined Successfully');
        codeController.clear;
        // descriptionController.clear;

        setState(() {});
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
