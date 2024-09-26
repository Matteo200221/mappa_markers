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
        final formKey = GlobalKey<FormState>();
        String titolo = '';
        String descrizione = '';
        List<String> listaFotoUrl = [];
        String urlFoto = '';

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              title: const Text('Selezioni da dove vuole inserire l\'immagine'),
              contentPadding: EdgeInsets.all(6),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Titolo',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci un titolo';
                                }
                                return null;
                              },
                              onSaved: (value) => titolo = value!,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Descrizione',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci una descrizione';
                                }
                                return null;
                              },
                              onSaved: (value) => descrizione = value!,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: [
                                for (var url in listaFotoUrl)
                                  Image.network(
                                    url,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                if (listaFotoUrl.length < 6)
                                  ElevatedButton(
                                    onPressed: () async {
                                      XFile? imageHandler = await showDialog<XFile?>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Seleziona una foto'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  XFile? imageHandler =
                                                  await pickImageFromCamera();
                                                  if (imageHandler != null) {
                                                    File imageSelected =
                                                    File(imageHandler.path);
                                                    urlFoto = await uploadImage(
                                                        imageSelected);
                                                    dialogSetState(() {
                                                      listaFotoUrl.add(urlFoto);
                                                    });
                                                  }
                                                  Navigator.of(context)
                                                      .pop(imageHandler);
                                                },
                                                child: const Text('Fotocamera'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  XFile? imageHandler =
                                                  await pickImageFromGallery();
                                                  if (imageHandler != null) {
                                                    File imageSelected =
                                                    File(imageHandler.path);
                                                    urlFoto = await uploadImage(
                                                        imageSelected);
                                                    dialogSetState(() {
                                                      listaFotoUrl.add(urlFoto);
                                                    });
                                                  }
                                                  Navigator.of(context)
                                                      .pop(imageHandler);
                                                },
                                                child: const Text('Galleria'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            uploadMarker(posizione, listaFotoUrl, titolo, descrizione);
                            setState(() {
                              listaCustomMarker.add(
                                CustomMarker(
                                    marker: Marker(
                                      markerId: MarkerId(
                                          'id_${listaCustomMarker.length}'),
                                      position: posizione,
                                    ),
                                    imageUrl: listaFotoUrl,
                                    titolo: titolo,
                                    descrizione: descrizione,
                                ),
                              );
                            });
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: const Text('Salva'),
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
      },
    );
  }
}
