import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteMarker(String id) async {
  await FirebaseFirestore.instance.collection('matteo_markers')
      .doc(id)
      .delete();
}

Future<void> deleteImage(String imageUrl) async {
  try {

    final Reference imageRef = FirebaseStorage.instance.ref().child('/Matteo/images/$imageUrl');

    await imageRef.delete();
    print('Image deleted successfully');
  } catch (e) {
    print('Error deleting image: $e');
  }
}
