import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Http/GeoService.dart';
import 'package:untitled/Http/HttpService.dart';
import 'package:untitled/Http/Models.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:untitled/Views/Accueil.dart';
import 'package:untitled/Views/navBar.dart';
import '../Http/LocationService.dart';
import '../Models/Position.dart';
import 'DetailRandonné.dart';

class SuiviPage extends StatefulWidget{
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Randonne randonne;

  const SuiviPage({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.randonne
  });
  @override
  State<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends State<SuiviPage>{

  StreamSubscription<Position>? subscription;
  List<Position?> positions = [];
  LatLng? lastPosition;
  bool isVisible = false;
  late GoogleMapController _mapController;
  Set<Marker> markers = Set();
  CameraPosition cem = new CameraPosition( target: LatLng(45.543589 , -73.491606) );
  bool trailStarted = false;


  @override
  void initState(){
    LocationService.requestPermission();

    setState(() {
      cem = new CameraPosition(target: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude), zoom: 14);
      Marker start = Marker(
        markerId: MarkerId("Start"),
        position: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude),
      );
      Marker end = Marker(
        markerId: MarkerId("End"),
        position: LatLng(widget.randonne.endingCoordinates.latitude , widget.randonne.endingCoordinates.longitude),
      );

    });
  }


  //Commence la randonnée et le timer
  startListening() async {
    cem = CameraPosition(
      target: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude),
      zoom: 16,
    );

    //Ajoute les permissions pour avoir la localisation
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //Reçoit la position actuelle et l'ajoute dans la liste de coordonnées
    if  (subscription == null) {
      subscription =
          LocationService.getPositionStream().listen((Position? position) {
            _mapController.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(position!.latitude, position.longitude), 20.0));
            positions.add(position);
            print(positions);

            //Ajoute un marker dans la position courante de l'utilisateur
            Marker marker = Marker(
                markerId: MarkerId("Marker: " + position.hashCode.toString()),
                position: LatLng(position!.latitude, position!.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose)
            );
            markers.add(marker);
            lastPosition = LatLng(position!.latitude, position!.longitude);
            setState(() {
            });
          });
    }
    else  {
      subscription!.resume();
    }
  }

  PauseListening(){
    subscription!.pause();
  }

  //Arrête la randonné et le timer
  stoplListening() {
    subscription!.cancel();
    List<Coordinates> coordinatesList = [];
    for(var marker in markers){
      Coordinates coor = new Coordinates();
      coor.latitude = marker.position.latitude;
      coor.longitude = marker.position.longitude;
      coordinatesList.add(coor);
    }
    addCoordinates(coordinatesList, widget.randonne.id);
  }

  //Initialise le google map controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newLatLngZoom( lastPosition!, 14));
  }
  
  //À chaque update de la position de l'utilisateur, la caméra se déplace
  Future<void> moveToStartMarker() async {
    Position position = await LocationService.getCurrentPosition();
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng( position.latitude, position.longitude ), 20.0),
    );
  }

  @override
  void dispose() {
    super.dispose();
    stoplListening();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body:  Column(
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
          shape: CircleBorder(),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
          backgroundColor: Color(0xff09635f),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: BottomAppBar(
          color:  Color(0xff09635f),
          elevation: 0,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  tooltip: 'Open navigation menu',
                  icon: const Icon(Icons.camera_alt, size: 40,),
                  onPressed: () {},
                ),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber,),
                  child:  !isVisible ? IconButton(
                    tooltip: 'Start',
                    icon: const FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(Icons.play_arrow_sharp, size: 45,)
                    ),
                    onPressed: () {
                      setState(() {
                        trailStarted = true;
                        isVisible = !isVisible;
                        moveToStartMarker();
                        startListening();
                      });
                    },
                  ) : IconButton(onPressed: ()
                      {
                        isVisible = !isVisible;
                        moveToStartMarker();
                        PauseListening();
                        setState(() {});
                      },
                      icon: Icon(Icons.pause, size: 45)
                  ),
                ),
                Opacity(
                  opacity: trailStarted ? 1.0 : 0.0,
                  child:  IconButton(
                    tooltip: 'Favorite',
                    icon: const Icon(Icons.stop_circle_rounded, size: 40,),
                    onPressed: () {
                      stoplListening();
                      trailStarted = false;
                      _mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(LatLng(widget.randonne.startingCoordinates.latitude, widget.randonne.startingCoordinates.longitude), 15.0),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailRanonne(randonne: widget.randonne,)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}