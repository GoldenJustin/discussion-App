import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:kimbweta_app/components/whiteboard.dart';
import 'package:path/path.dart';

import '../../constants/constants.dart';
class DocumentViewScreen extends StatefulWidget {

  File? file;
  // String? docName;

  DocumentViewScreen({super.key, required this.file});

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  PDFViewController? controller;
  int pages = 0;
  int indexPage = 0;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       // title: Text(widget.docName.toString()),
  //       title: Text('Document Name'),
  //
  //       ///Side Drawer
  //       actions: [
  //         IconButton(onPressed: (){}, icon: const Icon(Icons.screen_share)),
  //         PopupMenuButton(itemBuilder: (BuildContext context)=><PopupMenuEntry>[
  //
  //           PopupMenuItem(
  //             child: ListTile(
  //               leading: const Icon(Icons.draw_outlined),
  //               title: const Text('whiteBoard'),
  //               onTap: (){
  //                 Navigator.pushNamed(context, WhiteboardScreen.id);
  //
  //               },
  //             ),
  //           ),
  //         ],
  //         )
  //       ],
  //     ),
  //    //  body: Center(
  //    //    child:
  //    // widget.file != null
  //    //      ? SfPdfViewer.file(widget.path!)
  //    //      : Text('An Error Occured Try Again'),
  //    //  )
  //
  //
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file!.path);
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(name,
          style: const TextStyle(fontSize: 20),
        ),
        actions: pages >= 2
            ? [
          Center(child: Text(text, style: const TextStyle(fontSize: 12),)),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              final page = indexPage == 0 ? pages : indexPage - 1;
              controller!.setPage(page);
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 32),
            onPressed: () {
              final page = indexPage == pages - 1 ? 0 : indexPage + 1;
              controller!.setPage(page);
            },
          ),

    PopupMenuButton(itemBuilder: (BuildContext context)=><PopupMenuEntry>[
      const PopupMenuItem(
        child: ListTile(
          title: Text('TOOLS:'),
          onTap: null,
        ),
      ),
      PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: const Text('whiteBoard'),
                  onTap: ()=>Navigator.pushNamed(context, WhiteboardScreen.id)
                ),
              ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.draw_rounded),
          title: const Text('Annotations'),
          onTap: (){

          },
        ),
      ),
            ],)
        ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file!.path,
        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          // selectFile();
          // _add_Group_Dialog(context);
        },
        label: const Text('Screen Share'),
        icon: const Icon(Icons.screen_share),
        backgroundColor: kMainThemeAppColor,
      ),
    );
  }
}
