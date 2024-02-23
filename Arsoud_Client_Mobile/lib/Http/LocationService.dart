// TODO installer geolocator : flutter pub add geolocator
// TODO suivre la doc pour l'utilisation du package : https://pub.dev/packages/geolocator
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static LocationPermission? permission;
  static bool? allow;
  static Completer<GoogleMapController> _controller = Completer();

  static requestPermission() async {
    if (permission == null) {
      permission = await Geolocator.requestPermission();
    }
  }

  static requestLocationService() async {
    if (permission == null) {
      allow = await Geolocator.isLocationServiceEnabled();
    }
  }

  static requestCheckpermission() async {
    if (permission == null) {
      permission = await Geolocator.checkPermission();
    }
  }

  static Future<Position> getCurrentPosition()  async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  static Stream<Position> getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      // TODO distance en mètre entre 2 emplacements
      // TODO ici ce sera à tout les 10 mètres
      distanceFilter: 10,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  static double getDistanceBetween(double startlatitude, double startlongitude,
      double endlatitude, double endlongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startlatitude, startlongitude, endlatitude, endlongitude);
    return distanceInMeters;
  }

  static Future<void> centerScreen(Position position) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18)));
  }

}
