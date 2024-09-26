import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  Marker marker;
  String imageUrl; // lista di stringhe
  String titolo;
  String descrizione;

  CustomMarker({
    required this.marker,
    required this.imageUrl,
    required this.titolo,
    required this.descrizione
  });
}