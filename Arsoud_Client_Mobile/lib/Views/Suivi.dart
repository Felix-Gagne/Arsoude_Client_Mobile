import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Http/HttpService.dart';
import 'package:untitled/Http/Models.dart';
import '../Http/LocationService.dart';
import '../generated/l10n.dart';
import 'DetailRandonné.dart';

class SuiviPage extends StatefulWidget {
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Randonne randonne;

  const SuiviPage(
      {super.key,
      this.fabLocation = FloatingActionButtonLocation.endDocked,
      this.shape = const CircularNotchedRectangle(),
      required this.randonne});

  @override
  State<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends State<SuiviPage> {
  StreamSubscription<Position>? subscription;
  List<Position?> positions = [];
  LatLng? lastPosition;
  bool isVisible = false;
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  CameraPosition cem =
      const CameraPosition(target: LatLng(45.543589, -73.491606));
  bool trailStarted = false;

  @override
  void initState() {
    super.initState();
    LocationService.requestPermission();

    setState(() {
      cem = CameraPosition(
          target: LatLng(widget.randonne.startingCoordinates.latitude,
              widget.randonne.startingCoordinates.longitude),
          zoom: 14);
      Marker start = Marker(
        markerId: const MarkerId("Start"),
        position: LatLng(widget.randonne.startingCoordinates.latitude,
            widget.randonne.startingCoordinates.longitude),
      );
      Marker end = Marker(
        markerId: const MarkerId("End"),
        position: LatLng(widget.randonne.endingCoordinates.latitude,
            widget.randonne.endingCoordinates.longitude),
      );
    });
  }

  //Commence la randonnée et le timer
  startListening() async {
    cem = CameraPosition(
      target: LatLng(widget.randonne.startingCoordinates.latitude,
          widget.randonne.startingCoordinates.longitude),
      zoom: 16,
    );

    //Ajoute les permissions pour avoir la localisation
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(!mounted) return;
      return Future.error(S.of(context).locationServiceDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(!mounted) return;
        return Future.error(S.of(context).locationServicePermissionsDisabled);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if(!mounted) return;
      return Future.error(
          S.of(context).locationServicePermissionsPermanentlyDisabled);
    }

    //Reçoit la position actuelle et l'ajoute dans la liste de coordonnées
    if (subscription == null) {
      subscription =
          LocationService.getPositionStream().listen((Position? position) {
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(position!.latitude, position.longitude), 20.0));
        positions.add(position);

        //Ajoute un marker dans la position courante de l'utilisateur
        Marker marker = Marker(
            markerId: MarkerId("Marker: ${position.hashCode}"),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose));
        markers.add(marker);
        lastPosition = LatLng(position.latitude, position.longitude);
        setState(() {});
      });
    } else {
      subscription!.resume();
    }
  }

  pauseListening() {
    subscription!.pause();
  }

  //Arrête la randonné et le timer
  stoplListening() {
    subscription!.cancel();
    List<Coordinates> coordinatesList = [];
    for (var marker in markers) {
      Coordinates coor = Coordinates();
      coor.latitude = marker.position.latitude;
      coor.longitude = marker.position.longitude;
      coordinatesList.add(coor);
    }
    addCoordinates(coordinatesList, widget.randonne.id);
  }

  //Initialise le google map controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(lastPosition!, 14));
  }

  //À chaque update de la position de l'utilisateur, la caméra se déplace
  Future<void> moveToStartMarker() async {
    Position position = await LocationService.getCurrentPosition();
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 20.0),
    );
  }

  @override
  void dispose() {
    stoplListening();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: cem,
                myLocationEnabled: true,
                markers: markers,
                onMapCreated: _onMapCreated,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: const Color(0xff09635f),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff09635f),
          elevation: 0,
          child: _iconsList(context),
        ),
      ),
    );
  }

  IconTheme _iconsList(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _cameraIcon(),
          _startIcon(),
          stopIcon(context),
        ],
      ),
    );
  }

  IconButton _cameraIcon() {
    return IconButton(
      tooltip: 'Camera',
      icon: const Icon(
        Icons.camera_alt,
        size: 40,
      ),
      onPressed: () {},
    );
  }

  Container _startIcon() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
      ),
      child: !isVisible
          ? IconButton(
              tooltip: 'Start',
              icon: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Icon(
                    Icons.play_arrow_sharp,
                    size: 45,
                  )),
              onPressed: () {
                setState(() {
                  trailStarted = true;
                  isVisible = !isVisible;
                  moveToStartMarker();
                  startListening();
                });
              },
            )
          : IconButton(
              onPressed: () {
                isVisible = !isVisible;
                moveToStartMarker();
                pauseListening();
                setState(() {});
              },
              icon: const Icon(Icons.pause, size: 45)),
    );
  }

  Opacity stopIcon(BuildContext context) {
    return Opacity(
      opacity: trailStarted ? 1.0 : 0.0,
      child: IconButton(
        tooltip: 'Stop',
        icon: const Icon(
          Icons.stop_circle_rounded,
          size: 40,
        ),
        onPressed: () {
          stoplListening();
          trailStarted = false;
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
                LatLng(widget.randonne.startingCoordinates.latitude,
                    widget.randonne.startingCoordinates.longitude),
                15.0),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRandonne(
                        randonne: widget.randonne,
                      )));
        },
      ),
    );
  }
}
