import 'dart:io';

import 'package:favorite_places_app/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.savePickedImage});

  final void Function(File image) savePickedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;

  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });
    widget.savePickedImage(selectedImage!);
  }

  void selectFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImagefrmGallery =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImagefrmGallery == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImagefrmGallery.path);
    });

    widget.savePickedImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'Add image.',
        style: TextStyle(color: colorScheme.onBackground),
      ),
    );

    if (selectedImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary,
            ),
          ),
          child: content,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: selectFromGallery,
              icon: const Icon(Icons.photo),
              label: const Text('Select from gallery'),
            ),
            const SizedBox(
              width: 4,
            ),
            TextButton.icon(
              onPressed: takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Take Picture'),
            ),
          ],
        )
      ],
    );
  }
}
