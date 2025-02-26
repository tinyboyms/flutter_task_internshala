import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? currentImage;
  final String? currentImageBase64;
  final Function(File) onImagePicked;

  const ProfileImagePicker({
    Key? key,
    this.currentImage,
    this.currentImageBase64,
    required this.onImagePicked,
  }) : super(key: key);

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        onImagePicked(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          image: currentImage != null
              ? DecorationImage(
                  image: FileImage(currentImage!),
                  fit: BoxFit.cover,
                )
              : currentImageBase64 != null
                  ? DecorationImage(
                      image: MemoryImage(
                        Uint8List.fromList(base64Decode(currentImageBase64!)),
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: (currentImage == null && currentImageBase64 == null)
            ? Icon(
                Icons.add_a_photo,
                size: 40,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
} 