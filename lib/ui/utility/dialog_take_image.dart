import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/camera_controller.dart';
import '../controller/upload_controller.dart';
import '../models/custom_marker.dart';

class DialogTakeImage {
  Future<void> dialogBuilder(BuildContext context, LatLng posizione,
      List<CustomMarker> listaCustomMarker, Function setState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selezioni da dove vuole inserire l\'immagine'),
          contentPadding: EdgeInsets.all(6),
          content: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            XFile? imageHandler = await pickImageFromCamera();
                            if (imageHandler != null) {
                              File imageSelected = File(imageHandler.path);
                              String imageUrl = await uploadImage(imageSelected);
                              if (imageUrl.isNotEmpty) {
                                uploadMarker(posizione, imageUrl);
                                setState(() {
                                  listaCustomMarker.add(
                                    CustomMarker(
                                        marker: Marker(
                                          markerId: MarkerId(
                                              'id_${listaCustomMarker.length}'),
                                          position: posizione,
                                        ),
                                        imageUrl: imageUrl),
                                  );
                                });
                              }
                            }
                          } catch (e) {
                            print('Errore: $e');
                          } finally {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: Text('Fotocamera'),
                      ),

                  ElevatedButton(
                    onPressed: () async {
                      try {
                        XFile? imageHandler = await pickImageFromGallery();
                        print('prova $imageHandler');
                        if (imageHandler != null) {
                          File imageSelected = File(imageHandler.path);
                          String imageUrl = await uploadImage(imageSelected);
                          if (imageUrl.isNotEmpty) {
                            uploadMarker(posizione, imageUrl);
                            setState(() {
                              listaCustomMarker.add(
                                CustomMarker(
                                    marker: Marker(
                                      markerId: MarkerId(
                                          'id_${listaCustomMarker.length}'),
                                      position: posizione,
                                    ),
                                    imageUrl: imageUrl),
                              );
                            });
                          }
                        }
                      } catch (e) {
                        print('Errore: $e');
                      } finally {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    child: Text('Galleria'),
                  ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Chiudi'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}