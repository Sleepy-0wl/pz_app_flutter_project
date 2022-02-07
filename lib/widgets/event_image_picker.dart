import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// This widget is for picking image for new event. Accessed in new_event_screen.dart.
// It uses image_picker package and allows user to pick image from gallery.
class EventImagePicker extends StatefulWidget {
  const EventImagePicker(this.imagePickFn, {Key? key}) : super(key: key);

  final void Function(File pickedImage) imagePickFn;

  @override
  _EventImagePickerState createState() => _EventImagePickerState();
}

class _EventImagePickerState extends State<EventImagePicker> {
  var _pickedImage;

  void _pickImage(ImageSource imgSource) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: imgSource,
      imageQuality: 100,
      maxWidth: 1000,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: SizedBox(
            height: 200,
            width: 300,
            child: _pickedImage != null
                ? Image(
                    image: FileImage(_pickedImage),
                    fit: BoxFit.cover,
                  )
                : const Image(
                    image: AssetImage('assets/empty_pic.png'),
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.image),
            label: const Text('Odaberi sliku'),
          ),
        ),
      ],
    );
  }
}
