import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mappa_indicatore/ui/models/custom_marker.dart';

Future<List<CustomMarker>> downloadMarkers() async {
  final marksCollection =
      FirebaseFirestore.instance.collection('matteo_markers');
  final snapshot = await marksCollection.get();

  List<CustomMarker> customMarkers = [];
  for (var document in snapshot.docs) {
    final data = document.data();
    final LatLng position = LatLng(document['latitude'], document['longitude']);
    final List<String> imageUrl = List<String>.from(data['imageUrl']);
    final titolo = data['titolo'];
    final descrizione = data['descrizione'];
    print(imageUrl);

    customMarkers.add(CustomMarker(
      marker: Marker(
        markerId: MarkerId(document.id),
        position: position,
      ),
      imageUrl: imageUrl,
      titolo: titolo,
      descrizione: descrizione,
    ));
  }

  return customMarkers;
}
