import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mappa_indicatore/ui/controller/camera_controller.dart';
import 'package:mappa_indicatore/ui/controller/delete_controller.dart';
import 'package:mappa_indicatore/ui/controller/download_controller.dart';
import 'package:mappa_indicatore/ui/controller/upload_controller.dart';
import 'package:mappa_indicatore/ui/models/custom_marker.dart';
import 'package:mappa_indicatore/ui/providers/login_provider.dart';
import 'package:mappa_indicatore/ui/utility/dialog_image.dart';
import 'package:mappa_indicatore/ui/utility/dialog_take_image.dart';
import 'package:provider/provider.dart';

import '../permissions/position_permission.dart';
import '../providers/geolocalization_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CustomMarker> listaMarkers = [];
  late GoogleMapController mapController;
  late Future<Position>
      _localizationFuture; // Salvo la variabile riempita per non dover ogni volta ricaricare la funzione

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _localizationFuture =
        getLocalization(); // Quando iizializzo il componente questa variabile viene riempita
    loadMarkers();
  }

  Future<Position> getLocalization() async {
    return await determinePosition();
  }

  Future<void> loadMarkers() async {
    List<CustomMarker> markers = await downloadMarkers();
    setState(() {
      listaMarkers = markers;
    });
  }

  final DialogTakeImage dialogTakeImage = DialogTakeImage();

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<GeolocalizationProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        actions: loginProvider.token.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    loginProvider.token = '';
                    Get.offAllNamed('/');
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    loginProvider.token = '';
                    Get.toNamed('/login');
                  },
                )
              ],
      ),
      backgroundColor: Colors.black54,
      body: FutureBuilder<Position>(
        future: _localizationFuture,
        // Utilizzo la variabile in modo tale che solo all'init faccia partire la funzione una volta piena la variabile avrà semrpe un data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            localizationProvider.geolocalization = snapshot.data;
            final LatLng posizioneGeo = LatLng(
              localizationProvider.geolocalization!.latitude,
              localizationProvider.geolocalization!.longitude,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      onTap: loginProvider.token.isNotEmpty
                          ? (LatLng value) async {
                              dialogTakeImage.dialogBuilder(
                                  context,
                                  value,
                              listaMarkers,
                              setState);
                            }
                          : null,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: posizioneGeo,
                        zoom: 11.0,
                      ),
                      markers: listaMarkers
                          .map((customMarker) => customMarker.marker)
                          .toSet(),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaMarkers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              trailing  : GestureDetector(
                                onTap: () {
                                  DialogImage().dialogBuilder(context, listaMarkers[index].imageUrl);
                                },
                                child: Image.network(listaMarkers[index].imageUrl.first),
                              ),
                              title: Text(listaMarkers[index].titolo),
                              onTap: () {
                                mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: listaMarkers[index].marker.position,
                                    zoom: 11,
                                  ),
                                ));
                              },
                              subtitle: Text(listaMarkers[index].descrizione),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}
