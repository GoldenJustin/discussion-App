import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimbweta_app/components/our_material_button.dart';
import 'package:kimbweta_app/components/our_round_button.dart';
import 'package:kimbweta_app/components/our_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../components/custom_input_field.dart';
import '../../components/loading_component.dart';
import '../../components/snackbar.dart';
import '../../constants/constants.dart';
import '../background_screens/discussion_screen.dart';
import 'package:kimbweta_app/models/discussion_group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userData, next;
  bool checkStatus = false;

  var deleting_id;

  List<MyGroup_Item>? my_group_data;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

    print('-------PRINTING USER DATA-----------------------');
    print(userData);
    print('------------------------------------------------');

    fetchMyGroupData();
    // fetchJoinGroupData();
  }

  ///Function to delete a group
  _delete_Group_API(var groupId) async {
    print(
        '---------------------------GROUP ID SENT:: ${groupId}--------------------');
    print(
        '---------------------------SENT RUN TYPE:: ${groupId.runtimeType}--------------------');
    String url = 'delete_group/${groupId}';

    var res = await CallApi().authenticatedDeleteRequest(url, context: context);
    if (res != null) {
      print(
          '---------------------------REQUEST SENT:: ${res.statusCode}--------------------');

      try {
        if (res.statusCode == 200) {
          print(
              '------------------------>>>>>>---REQUEST SENT:: ${res.body}--------------------');
          fetchMyGroupData();
        } else {
          print('---------------------------STATUS CODE--------------------');
          print('NULLLLL');
          print('----------------------------------------------------------');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  ///function to fetch group data from the server
  fetchMyGroupData() async {
    String url = 'created_group/' + userData['user']['id'].toString();
    // var customer = userData['id'].toString();
    // if (next != null) {
    //   url = url_format(next);
    // }
    var res = await CallApi().authenticatedGetRequest(url, context: context);

    // print(res);
    if (res != null) {
      var body = json.decode(res.body);
      print('-------PRINTING BODY OF FETCHING GROUP DATA--------');
      print(body);
      print('---------------------------------------------------');

      var theGroups = body;
      List<MyGroup_Item> _my_group_items = [];

      // if (next != null) {
      //   _my_group_items = my_group_data!;
      // }

      for (var field in theGroups) {
        MyGroup_Item group = MyGroup_Item(
          field['id'].toString(),
          field['name'].toString(),
          field['code'].toString(),
          field['description'].toString(),
          field['created_at'].toString(),
        );
        _my_group_items.add(group);
      }

      print('---------------MY CREATED GROUP ITEMS--------------------');
      print(_my_group_items.length);
      print('------------------------------------------------');
      // setState(() {
      //   loading = false;
      // });

      setState(() {
        checkStatus = true;
        my_group_data = _my_group_items;
      });
    } else {
      showSnack('No network', context);
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
        title: Text(
          '[ ${my_group_data!.length} - Groups Created ]',
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
              child: my_group_Component(),
            ),
          )
        ],
      ),

      /// FBA
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _add_Group_Dialog(context, null);
        },
        label: const Text('Group'),
        icon: const Icon(Icons.add),
        backgroundColor: kMainThemeAppColor,
      ),
    );
  }

  my_group_Component() {
    if (my_group_data == null) {
      // print(my_group_data);
      // print("---------------------");
      return const Center(
        child: Text('No Network or Connection...'),
      );
    } else if (my_group_data != null && my_group_data?.length == 0) {
      // No Data
      return const Center(
        child: Text('No Group created Yet!',
            style: TextStyle(color: kMainWhiteColor)),
      );
      ;
    } else {
      return ListView.builder(
          itemCount: my_group_data!.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            int reverseIndex = my_group_data!.length - 1 - index;
            return Card(
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              elevation: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscussionScreen(
                          gpId: my_group_data![reverseIndex].id,
                          name: my_group_data![reverseIndex].name,
                          code: my_group_data![reverseIndex].code,
                          description: my_group_data![reverseIndex].description,
                          created_at: my_group_data![reverseIndex].created_at),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    my_group_data![reverseIndex].name,
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
                    'Code for others to join: ${my_group_data![reverseIndex].code}',
                    style: const TextStyle(
                        color: Colors.white24,
                        fontFamily: 'Montserrat2',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 9),
                  ),
                  leading: Image.asset('images/group_logo.png'),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: kMainThemeAppColor,
                    ),
                    onPressed: () {
                      deleting_id = my_group_data![reverseIndex].id;

                      _add_Group_Dialog(context, deleting_id);
                      // _delete_Group_API(my_group_data![reverseIndex].id);
                    },
                  ),
                ),
              ),
            );
          });
    }
  }

  ///Our Pop Dialog
  void _add_Group_Dialog(BuildContext context, String? gpId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            // title: const Text('Add Group'),
            content: Form(
              child: (gpId != null) ? Column(
                children: [
                  const Text(
                    'Thia action will remove everyone else. Are you sure?',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,

                    ),
                  ),
                  OurMaterialButton(
                      label: 'Remove',
                      onPressed: () {
                        _delete_Group_API(gpId);
                        setState(() {
                          _scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                        Navigator.pop(context);

                      })
                ],
              ) : Column(
                children: [
                  const Text(
                    'Create Group',
                    style: TextStyle(
                        color: kMainThemeAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputField(
                    controller: groupNameController,
                    hintText: 'Group Name',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomInputField(
                    controller: descriptionController,
                    hintText: 'Description',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OurMaterialButton(
                      label: 'Create',
                      onPressed: () {
                        _create_Group_API();
                        fetchMyGroupData();
                        setState(() {
                          _scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(
                        //     builder: (context)=> DiscussionScreen(
                        //         gpId: my_group_data,
                        //         name:my_group_data![index].name,
                        //         code:my_group_data![index].code,
                        //         description:my_group_data![index].description,
                        //         created_at:my_group_data![index].created_at
                        //     )));
                      })
                ],
              )
            ),
          );
        });
  }

  ///Function to create a group
  _create_Group_API() async {
    var data = {
      'name': groupNameController.text,
      'description': descriptionController.text,
      'created_by': userData['user']['id'],
      'type': 'driver',
    };

    var res = await CallApi().authenticatedPostRequest(data, 'create_group');
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
        showSnack(context, 'Group Created Successfully');
        groupNameController.clear;
        descriptionController.clear;

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
