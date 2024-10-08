import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mappa_indicatore/ui/controller/download_controller.dart';
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
  late Future<Position?>
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

  Future<Position?> getLocalization() async {
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
        backgroundColor: const Color(0xFF2A3C56),
        automaticallyImplyLeading: false,
        actions: loginProvider.token.isNotEmpty
            ? [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              loginProvider.token = '';
              Get.offAllNamed('/');
            },
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.login),
            color: Colors.white,
            onPressed: () {
              loginProvider.token = '';
              Get.toNamed('/login');
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Position?>(
        future: _localizationFuture,
        builder: (context, snapshot) {
          LatLng posizioneGeo;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            localizationProvider.geolocalization = snapshot.data;
            posizioneGeo = LatLng(
              localizationProvider.geolocalization!.latitude,
              localizationProvider.geolocalization!.longitude,
            );
          } else {
            posizioneGeo = const LatLng(38.116669, 13.366667);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      onTap: loginProvider.token.isNotEmpty
                          ? (LatLng value) async {
                        dialogTakeImage.dialogBuilder(
                            context, value, listaMarkers, setState);
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
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: listaMarkers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            trailing: GestureDetector(
                              onTap: () {
                                DialogImage().dialogBuilder(
                                    context, listaMarkers[index].imageUrl);
                              },
                              child: Image.network(
                                  listaMarkers[index].imageUrl.first),
                            ),
                            title: Text(listaMarkers[index].titolo),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: listaMarkers[index].marker.position,
                                    zoom: 11,
                                  ),
                                ),
                              );
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
        },
      ),
    );
  }
}
