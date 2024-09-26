import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String> uploadImage (File imageFile) async {

  try {
    final storageRef = FirebaseStorage.instance.ref().child('/Matteo/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await storageRef.putFile(imageFile);

    String imageUrl = await storageRef.getDownloadURL();
    
    return imageUrl;
  } catch (e) {
    print("Errore durante il caricamento dell'immagine: $e");
    return '';
  }
  
}

Future<void> uploadMarker (LatLng position, List<String> imageUrl, String titolo, String descrizione) async {

  try{
    final markersCollection = FirebaseFirestore.instance.collection('matteo_markers');

    await markersCollection.add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'imageUrl': imageUrl,
      'titolo': titolo,
      'descrizione': descrizione,
    });

    print('iserimento fatto');
    
  } catch (e) {
    print('errore salvataggio marker $e');
  }
}