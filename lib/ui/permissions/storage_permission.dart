import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setInformatioMarker (List<Marker> markers) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonStringList = markers.map((marker) => jsonEncode(marker.toJson())).toList();
  await prefs.setStringList('marker_list', jsonStringList);
}

Future<List<Marker>> getInformatioMarker () async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonStringList = prefs.getStringList('marker_list');

  if(jsonStringList != null) {
    print('dentro ${prefs.getStringList('marker_list')}');
    return jsonStringList.map((jsonString) => Marker(
      markerId: MarkerId('${jsonDecode(jsonString)['markerId']}'),
      position: LatLng(jsonDecode(jsonString)['position'][0], jsonDecode(jsonString)['position'][1],),
    )).toList();
  }

  return [];
}