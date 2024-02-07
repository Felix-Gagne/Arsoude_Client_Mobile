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
  Set<Polyline> polylines = {};
  bool isVisible = false;
  late GoogleMapController _mapController;

  LatLng endPosition = LatLng(45.543589 , -73.491606);
  Set<Marker> markers = Set();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polyliness = {};
  List<LatLng> polylineCoordinates = [];
   CameraPosition cem = new CameraPosition( target: LatLng(45.543589 , -73.491606) );
  int seconds = 0;
  late Timer _timer;

  @override
  void initState(){

    LocationService.requestPermission();



    setState(() {
      cem = new CameraPosition(target: LatLng(widget.randonne.startingCoordinates.x , widget.randonne.startingCoordinates.y), zoom: 14);
      Marker start = Marker(
        markerId: MarkerId("Start"),
        position: LatLng(widget.randonne.startingCoordinates.x , widget.randonne.startingCoordinates.y),
      );
      Marker end = Marker(
        markerId: MarkerId("End"),
        position: LatLng(widget.randonne.endingCoordinates.x , widget.randonne.endingCoordinates.y),
      );
      markers.add(start);
      markers.add(end);
    });
  }



  startListening() async {
    cem = CameraPosition(
      target: LatLng(widget.randonne.startingCoordinates.x , widget.randonne.startingCoordinates.y),
      zoom: 16,
    );

    Position currentPosition = await LocationService.getCurrentPosition();
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

    subscription = LocationService.getPositionStream().listen((Position? position) {
      positions.add(position);
      print(positions);
      setState(() {
      });

      Marker marker = Marker(
        markerId: MarkerId("Marker: " + position.hashCode.toString()),
        position: LatLng(position!.latitude , position!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)
      );
      markers.add(marker);
      lastPosition = LatLng(position!.latitude, position!.longitude);
      createPolyline(lastPosition!);
    });
    startTimer();

  }

  stoplListening() {
    subscription!.cancel();
    List<Coordinates> coordinatesList = [];


    for(var marker in markers){
      Coordinates coor = new Coordinates();
      coor.x = marker.position.latitude;
      coor.y = marker.position.longitude;
      coordinatesList.add(coor);
    }

    addCoordinates(coordinatesList, widget.randonne.id);
    stopTimer();

  }


  createPolyline(LatLng position) {
    List<LatLng> points = [];
    points.add(position);
    points.add(markers.last.position);
    polylines.add(Polyline(
      polylineId: PolylineId(polylines.length.toString()),
      points: points,
      color: Colors.blue,


    ));
    setState(() {

    });

    print( "BAAAAA : " + polylines.last.points.toString());
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void moveToStartMarker() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(widget.randonne.startingCoordinates.x, widget.randonne.startingCoordinates.y), 20.0),
    );
  }
  void makeLines() async {
    await polylinePoints
        .getRouteBetweenCoordinates(
      'AIzaSyDT0ddm46ekfRxxfYCWiyjrePEP5lWUXCk',
      PointLatLng(widget.randonne.startingCoordinates.x, widget.randonne.startingCoordinates.y), //Starting LATLANG
      PointLatLng(endPosition.latitude, endPosition.longitude), //End LATLANG
      travelMode: TravelMode.driving,
    ).then((value) {
      value.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }).then((value) {
      addPolyLine();
    });
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates
    );
    polyliness[id] = polyline;
    setState((){});
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(microseconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      setState(() {

      });
    }

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
                polylines: Set<Polyline>.of(polyliness.values),
                myLocationEnabled: true,
                markers: markers,
                onMapCreated: _onMapCreated,
              ),),
              Container(
                height: 50,
                alignment: Alignment.center,
                color:  Color(0xff09635f),
                child: Text(
                  ' ${Duration(milliseconds: 1 *seconds).toString()}',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              )
            ],
          ),

        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
          backgroundColor: Color(0xff09635f), // Customize the background color
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
                        startTimer();
                        isVisible = !isVisible;
                        moveToStartMarker();
                        startListening();
                      });
                    },
                  )
                      : IconButton(onPressed: () {
                        stopTimer();
                    isVisible = !isVisible;
                    moveToStartMarker();
                    startListening();
                  }, icon: Icon(Icons.pause, size: 45)),
                ),
                Opacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  child:  IconButton(
                    tooltip: 'Favorite',
                    icon: const Icon(Icons.stop_circle_rounded, size: 40,),
                    onPressed: () {
                      stoplListening();
                      _mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(LatLng(widget.randonne.startingCoordinates.x, widget.randonne.startingCoordinates.y), 15.0),
                      );
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