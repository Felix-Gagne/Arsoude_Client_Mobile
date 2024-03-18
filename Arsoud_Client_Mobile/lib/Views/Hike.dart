import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Http/HttpService.dart';
import 'package:untitled/Http/Models.dart';
import '../Http/LocationService.dart';
import '../Http/PathDeviation.dart';
import '../generated/l10n.dart';
import 'CameraPage.dart';
import 'DetailRandonné.dart';
import 'Login.dart';



class HikePage extends StatefulWidget{
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Randonne randonne;


  const HikePage({super.key,
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.randonne
  });
  @override
  State<HikePage> createState() => _HikePageState();
}

class _HikePageState extends State<HikePage>{

  StreamSubscription<Position>? subscription;
  List<Position?> positions = [];
  LatLng? lastPosition;
  bool isVisible = false;
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  CameraPosition cem = const CameraPosition( target: LatLng(45.543589 , -73.491606) );
  bool trailStarted = false;
  List<Coordinates> coordonees = [];
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  DateTime? start;
  DateTime? end ;
  late double hikeRating = 0;
  bool rated = false;
  int currentCoordIndex = 0;
  int warningIndex = 0;



  @override
  void initState() {
    super.initState();
    LocationService.requestPermission();
    setMarkers();
    setState(() {
      cem = CameraPosition(target: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude), zoom: 14);
      Marker start = Marker(
        markerId: const MarkerId("Start"),
        position: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude),
      );
      Marker end = Marker(
        markerId: const MarkerId("End"),
        position: LatLng(widget.randonne.endingCoordinates.latitude , widget.randonne.endingCoordinates.longitude),
      );
    });


  }

  //Commence la randonnée et le timer
  startListening() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(),
      ),
    );

    start = DateTime.now();
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    //Reçoit la position actuelle et l'ajoute dans la liste de coordonnées
    if  (subscription == null) {
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
                    BitmapDescriptor.hueRose)
            );

            lastPosition = LatLng(position.latitude, position.longitude);

            checkDeviation();

            setState(() {});
          });
    }
    else  {
      subscription!.resume();
    }
  }

  checkDeviation(){
    double distance = 0;
    double leastDistance = double.infinity;
    double threshold = 30;
    double lastLat = lastPosition!.latitude;
    double lastLong = lastPosition!.longitude;

    for(int i = 0; i <= coordonees.length; i++){
      distance = Geolocator.distanceBetween(lastPosition!.latitude, lastPosition!.longitude, coordonees[i].latitude, coordonees[i].longitude);
      if (distance < leastDistance) {
        leastDistance = distance;
        currentCoordIndex = i;
      }
    }

    if(warningIndex <= 1){
      if(currentCoordIndex == 0){
        if(Geolocator.distanceBetween(lastPosition!.latitude, lastPosition!.longitude, coordonees[currentCoordIndex].latitude, coordonees[currentCoordIndex].longitude) >= threshold
            || Geolocator.distanceBetween(lastPosition!.latitude, lastPosition!.longitude, coordonees[currentCoordIndex + 1].latitude, coordonees[currentCoordIndex +1].longitude)  >= threshold ){
          checkDeviation();
          warningIndex++;
          return;
        }
      }

      if(Geolocator.distanceBetween(lastLat,lastLong, coordonees[currentCoordIndex].latitude, coordonees[currentCoordIndex].longitude) >= threshold
          || Geolocator.distanceBetween(lastLat, lastLong, coordonees[currentCoordIndex + 1].latitude, coordonees[currentCoordIndex +1].longitude)  >= threshold
          || Geolocator.distanceBetween(lastLat, lastLong, coordonees[currentCoordIndex + 2].latitude, coordonees[currentCoordIndex +2].longitude)  >= threshold
          || Geolocator.distanceBetween(lastLat, lastLong, coordonees[currentCoordIndex -1].latitude, coordonees[currentCoordIndex -1].longitude)  >= threshold){
        checkDeviation();
        warningIndex++;
        return;
      }
    }
    else{
      warningIndex = 0;

      const snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Color(0xFFC72C41),
        dismissDirection: DismissDirection.down,
        content: Text('Warning'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  // Future<void> showNotification(String title, String body) async {
  //   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'your channel id', 'your channel name', 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   final platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics,
  //   );
  //
  //   await FlutterLocalNotificationsPlugin().show(
  //     0, title, body, platformChannelSpecifics, payload: 'item x',
  //   );
  // }

  pauseListening(){
    subscription!.pause();
  }

  //Arrête la randonné et le timer
  stoplListening() async {
    end = DateTime.now();
    subscription!.cancel();
    List<Coordinates> coordinatesList = [];

    for(var pos in positions){
      Coordinates coor = Coordinates();
      coor.latitude = pos!.latitude;
      coor.longitude = pos!.longitude;
      coordinatesList.add(coor);
    }

    Hike data = new Hike();
    data.date = DateTime.now();
    data.Distance = positions.length * 10;
    data.time = end!.difference(start!).inSeconds.toString();
    data.TrailId = widget.randonne.id;

    if (lastPosition != null && Geolocator.distanceBetween(
        lastPosition!.latitude, lastPosition!.longitude,
        widget.randonne.endingCoordinates.latitude, widget.randonne.endingCoordinates.longitude) <= 20)
    {
      data.isCompleted = true;
    }
    else {
      data.isCompleted = false;
    }

    if(rated == true){
      await hikeRating;
      rateHike(widget.randonne.id, hikeRating);
    }
    CreateHike(data);
  }

  //Initialise le google map controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newLatLngZoom( lastPosition!, 14));
  }

  Future<void> setMarkers() async {
    Marker start = Marker(
      markerId: MarkerId("Start"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: LatLng(widget.randonne.startingCoordinates.latitude,
          widget.randonne.startingCoordinates.longitude),
    );
    Marker end = Marker(
      markerId: MarkerId("End"),
      position: LatLng(widget.randonne.endingCoordinates.latitude,
          widget.randonne.endingCoordinates.longitude),
    );
    try {
      coordonees = await getCoordinates(widget.randonne.id);
    }
    on DioError catch(e){
      if(e.response?.statusCode == 404){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).theTrailDoesNotExist),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
      if(e.response?.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).sessionHasExpiredPleaseLoginAgain),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).uneErreurCestProduite),
          )
      );
    }

    for (var c in coordonees) {
      polylineCoordinates.add(LatLng(c.latitude, c.longitude));
      markers.add(Marker(
        markerId: MarkerId("Waypoint"),
        position: LatLng(c.latitude, c.longitude),
        visible: false,
      ));
    }

    await addPolyLine(polylineCoordinates);
    cem = CameraPosition(target: LatLng(widget.randonne.startingCoordinates.latitude,
        widget.randonne.startingCoordinates.longitude),
        zoom: 10
    );

  }


  addPolyLine(List<LatLng> coords) {
    PolylineId id = PolylineId(coords.first.longitude.toString());
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: coords ,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  //À chaque update de la position de l'utilisateur, la caméra se déplace
  Future<void> moveToStartMarker() async {
    Position position = await LocationService.getCurrentPosition();
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng( position.latitude, position.longitude ), 20.0),
    );
  }

  // double haversine(double lat1, double lon1, double lat2, double lon2) {
  //   const R = 6371.0; // Earth radius in km
  //   // Convert latitude and longitude from degrees to radians
  //   final lat1Rad = math.radians(lat1);
  //   final lon1Rad = math.radians(lon1);
  //   final lat2Rad = math.radians(lat2);
  //   final lon2Rad = math.radians(lon2);
  //
  //   // Difference in latitude and longitude
  //   final dlat = lat2Rad - lat1Rad;
  //   final dlon = lon2Rad - lon1Rad;
  //
  //   // Haversine formula
  //   final a = pow(sin(dlat / 2), 2) + cos(lat1Rad) * cos(lat2Rad) * pow(sin(dlon / 2), 2);
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   final distance = R * c;
  //
  //   return distance;
  // }

  @override
  void dispose() {
    _mapController.dispose();
    stoplListening();
    super.dispose();
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
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () { Navigator.pop(context); },
          backgroundColor: const Color(0xff09635f),
          child: const Icon(Icons.arrow_back, color: Colors.white,),
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
      icon: const Icon(Icons.camera_alt, size: 40,),
      onPressed: () async {
        await availableCameras().then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CameraPage(cameras: value, randonne: widget.randonne,))));
      },
    );
  }

  Container _startIcon() {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber,),
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
        pauseListening();
        setState(() {});
      },
          icon: const Icon(Icons.pause, size: 45)),
    );
  }

  Opacity stopIcon(BuildContext context) {
    return Opacity(
      opacity: trailStarted ? 1.0 : 0.0,
      child:  IconButton(
        tooltip: 'Stop',
        icon: const Icon(Icons.stop_circle_rounded, size: 40,),
        onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Rate this hike!', ),
          content: RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber,),
            onRatingUpdate: (rating) {
              hikeRating = rating;
              print(hikeRating);
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    stoplListening();
                    trailStarted = false;
                    _mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(LatLng(widget.randonne.startingCoordinates.latitude, widget.randonne.startingCoordinates.longitude), 15.0),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailRanonne(randonne: widget.randonne,)));
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    rated = true;
                    stoplListening();
                    trailStarted = false;
                    _mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(LatLng(widget.randonne.startingCoordinates.latitude, widget.randonne.startingCoordinates.longitude), 15.0),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailRanonne(randonne: widget.randonne,)));
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      )
      ),
    );
  }



}