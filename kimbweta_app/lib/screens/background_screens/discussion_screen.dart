import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kimbweta_app/components/our_material_icon_button.dart';
import 'package:kimbweta_app/screens/background_screens/document_view_screen.dart';
import 'package:kimbweta_app/screens/background_screens/all_documents_screen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../api/api.dart';
import '../../components/our_pop_up_menu.dart';
import '../../components/snackbar.dart';
import '../../constants/constants.dart';
import '../authentication_screens/sign_in_screen.dart';

class DiscussionScreen extends StatefulWidget {
  final String? gpId, name, code, description, created_at;

  DiscussionScreen({
    this.gpId,
    this.name,
    this.code,
    this.description,
    this.created_at,
  });

  static String id = 'Discussion';

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  var userData;
  var rootid;
  var result;
  var status;

  var fileName;
  File? file;

  // late FilePickerResult result;
  // PlatformFile? pickedFile;

  // bool isApiCallProcess = false;
  // @override
  // Widget build(BuildContext context) {
  //   return ProgressHUD(child: _uiSetup(context),
  //     inAsyncCall: isApiCallProcess,
  //     opacity: 0.3,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),

        ///Side Drawer
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  title: Text('TOOLS:'),
                  onTap: null,
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()),
                        (route) => false);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.file_copy),
                  title: const Text('Group file uploads'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => All_DocumentsScreen(
                              id: widget.gpId,
                              name: widget.name,
                              code: widget.code,
                              description: widget.description,
                              created_at: widget.created_at,
                            )));
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueGrey,
                Colors.black,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///It should be active when document/whiteboard have been accessed
                ///Button for picking a file
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: OurMaterialIconButton(
                      icon: const Icon(
                        Icons.file_present,
                        color: kMainWhiteColor,
                      ),
                      label: 'Pick A file',
                      onPressed: () {
                        // A f(x) that enable a file to be picked
                        pickAFile();
                        // setState(() {
                        //   Navigator.push(context, MaterialPageRoute(
                        //     builder: (context)=>DocumentViewScreen(
                        //       path: selectedFile,
                        //       // docName:pickedFile!.name
                        //     ),
                        //   ),
                        //   );
                        // });
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),

                ///Button for uploading a file
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: OurMaterialIconButton(
                      icon: const Icon(
                        Icons.upload_file,
                        color: kMainWhiteColor,
                      ),
                      label: 'Upload file',
                      onPressed: () {
                        selectFileToUploadFile();
                      },
                    )),

                ///Test Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Function for picking a file
  void pickAFile() async {
    ///My code (They did work perfectly but likely to test efficiency)
    // // Clear the cache directory before picking another file
    //
    // //Here we are picking a file
    // result = (await FilePicker.platform.pickFiles())!;
    // // print('XXXXX>>>>>>${result.files.single.path}<<<<<XXXXX');
    //
    // if (result != null) {
    //   try {
    //     //Here we are storing the adress of picked file into a cache
    //     selectedFile = File(result.files.single.path!);
    //       // print('>>>>>>>>>xxxxxxxx>>>>>>>>>${selectedFile}');
    //
    //   } catch (e) {
    //     print('Error occurred: $e');
    //   }
    //
    // } else {
    //   Navigator.pop(context);
    // }

    ///Michael Michael codes (With my modifications)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      file = File(result.files.single.path!);

      // List<File> files = result.paths.map((path) => File(path!)).toList();
      // print(result.files.single.path);
      print('>>>>PRINTING FILE:>>>$file');

      setState(() {
        // file = File(path);
        // uploadFilePhaseZero();
      });

      print("file============$file");
      print("path============${file!.path}");
      // print("file============"+file!);

      // uploadFilePhaseOneDio();

      //   Navigator.of(this.context).push(
      //       MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));
      // }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentViewScreen(file: file),
        ),
      );
    } else {
      showSnack(context, 'Nothing was selected!');
    }

    Future<void> clearCacheDirectory() async {
      // Get the cache directory path
      Directory cacheDir = await getTemporaryDirectory();

      // Get all the files in the cache directory
      List<FileSystemEntity> files = cacheDir.listSync(recursive: true);

      // Delete each file in the cache directory
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
  }

  ///Function for uploading a file
  void selectFileToUploadFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) {
      return;
    } else {
      file = File(result.files.single.path!);
      // List<File> files = result.paths.map((path) => File(path!)).toList();
      // print(result.files.single.path);
      print(file);

      setState(() {
        // file = File(path);
        uploadFile();
      });

      print("file============" + file.toString());
      print("path============" + file!.path.toString());
      // print("file============"+file!);

      // uploadFilePhaseOneDio();
    }
    if (file!.path == null) {}
  }

  uploadFile() async {
    final filename = path.basename(file!.path);
    print('file path============> ${filename}');

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file!.path,
        filename: filename,

        // contentType:  MediaType("image", "jpg"), //add this
      ),
      'group_id': widget.gpId,
    });

    var res =
        await CallApi().authenticatedUploadRequest(formData, 'upload_file');
    if (res == null) {
      // setState(() {
      //   _isLoading = false;
      //   // _not_found = true;
      // });
      // showSnack(context, 'No Network!');
      print('Uploadh============> NULL');
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        showSnack(context, 'File Uploaded Successfully');

        setState(() {});
      } else if (res.statusCode == 400) {
        print('hhh');

      } else {}
    }
  }
}
