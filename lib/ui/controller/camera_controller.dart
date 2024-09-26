import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromGallery() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

Future<XFile?> pickImageFromCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);

  print('stampa ${image.toString()}');

    return image;
}