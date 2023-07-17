import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:kimbweta_app/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/scribble.dart';

class WhiteboardScreen extends StatefulWidget {
  static String id = 'whiteboard';

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whiteboard'),
        leading: IconButton(
          icon: const Icon(Icons.save),
          tooltip: "Save to Image",
          onPressed: () {
            // _saveImage(context);

            saveAndDisplayImage(context);

          }
        ),
        actions: [
          // IconButton(onPressed: (){
          //   Navigator.pop(context);
          // },
          //   icon: Icon(Icons.screen_share), tooltip: 'close',),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.clear),
            tooltip: 'close',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: Stack(
            children: [
              Scribble(
                notifier: notifier,
                drawPen: true,
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildColorToolbar(context),
                    const Divider(
                      height: 32,
                    ),
                    _buildStrokeToolbar(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAndDisplayImage(BuildContext context) async {
    final image = await notifier.renderImage();
    _saveImage(context, image.buffer.asUint8List());
  }
///Old image save function
  // Future<void> _saveImage(BuildContext context) async {
  //   final image = await notifier.renderImage();
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Your Image"),
  //       content: Image.memory(
  //         image.buffer.asUint8List(),
  //       ),
  //     ),
  //   );
  // }

  ///New Image save function
  Future<void> _saveImage(BuildContext context, Uint8List imageBytes) async {
    // Get the directory where the image will be saved
    // Directory appDir = await getApplicationDocumentsDirectory();
    Directory? picturesDir = await getExternalStorageDirectory();
    String fileName = "your_image.png"; // Customize the file name and extension as needed

    // Create a new file in the app directory
    File imageFile = File('${picturesDir!.path}/$fileName');

    // Write the image bytes to the file
    await imageFile.writeAsBytes(imageBytes);

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Image Saved"),
        content:  Text("Your image has been saved inside '${imageFile.path.toString()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: state.map(
                  drawing: (s) => Color(s.selectedColor),
                  erasing: (_) => Colors.transparent,
                ),
                border: state.map(
                  drawing: (_) => null,
                  erasing: (_) => Border.all(width: 1),
                ),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUndoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildRedoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 20.0,
          ),
          _buildPointerModeSwitcher(context,
              penMode:
                  state.allowedPointersMode == ScribblePointerMode.penOnly),
          const Divider(
            height: 20.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
          _buildColorButton(context,
              color: Colors.black, state: state, colorTag: 'black'),
          _buildColorButton(context,
              color: Colors.red, state: state, colorTag: 'red'),
          _buildColorButton(context,
              color: Colors.green, state: state, colorTag: 'green'),
          _buildColorButton(context,
              color: Colors.blue, state: state, colorTag: 'blue'),
          _buildColorButton(context,
              color: Colors.yellow, state: state, colorTag: 'yellow'),
        ],
      ),
    );
  }

  ///For eraser

  Widget _buildPointerModeSwitcher(BuildContext context,
      {required bool penMode}) {
    return FloatingActionButton.small(
      heroTag: 'pointer',
      onPressed: () => notifier.setAllowedPointersMode(
        penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
      ),
      tooltip:
          "Switch drawing mode to " + (penMode ? "all pointers" : "pen only"),
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: !penMode
            ? const Icon(
                Icons.touch_app,
                key: ValueKey(true),
              )
            : const Icon(
                Icons.do_not_touch,
                key: ValueKey(false),
              ),
      ),
    );
  }

  ///For eraser
  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        heroTag: 'eraser',
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: notifier.setEraser,
      ),
    );
  }

  ///For  color
  Widget _buildColorButton(BuildContext context,
      {required Color color,
      required ScribbleState state,
      required String colorTag}) {
    final isSelected = state is Drawing && state.selectedColor == color.value;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          heroTag: colorTag,
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  ///For undo
  Widget _buildUndoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      heroTag: 'undo',
      tooltip: "Undo",
      onPressed: notifier.canUndo ? notifier.undo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canUndo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.undo_rounded,
        color: Colors.white,
      ),
    );
  }

  ///For redo
  Widget _buildRedoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      heroTag: 'Redo',
      tooltip: "Redo",
      onPressed: notifier.canRedo ? notifier.redo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canRedo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.redo_rounded,
        color: Colors.white,
      ),
    );
  }

  ///For clear
  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: "Clear",
      onPressed: notifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.clear),
    );
  }
}
