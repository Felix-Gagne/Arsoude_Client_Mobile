import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Http/Models.dart';
import 'package:untitled/Views/Hike.dart';
import 'package:untitled/Views/Login.dart';
import 'package:untitled/Views/Suivi.dart';

import '../Http/HttpService.dart';
import '../generated/l10n.dart';
import 'navBar.dart';

class DetailRanonne extends StatefulWidget {
  const DetailRanonne({Key? key, required this.randonne});

  final Randonne randonne;

  @override
  State<DetailRanonne> createState() => _DetailRanonneState();
}

class _DetailRanonneState extends State<DetailRanonne> {
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> completer = Completer();
  Set<Marker> markers = Set();
  Set<Marker> SEMark = Set();
  List<Coordinates> coordonnees = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  var favorite = false;
  var isConnected = false;
  bool  owner = false;
  late List<String> listImage = [];
  CameraPosition cem = const CameraPosition(
    target: LatLng(45.536447 , -73.495223),
    zoom: 10,
  );

  Future<bool?> verifyIfTrailIsFavorit() async {
    String? user = await storage.read(key: 'jwt');
    if(user != null || user != ""){
      isConnected = true;
      var listTrails = await getUserFavoriteTrails();
      for(var favoritTrail in listTrails){
        if(widget.randonne.id  == favoritTrail.id ){
          favorite = true;
        }
      }
    }
    else{
      isConnected = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    verifyIfTrailIsFavorit();
    CheckisOwner();

    getImages();

  }

  CheckisOwner() async {
    owner =await IsOwner(widget.randonne.id);
    setState(() {
    });
  }

  getImages() async {
    listImage = await getTrailImages(widget.randonne.id);
    print("HFDHFDHJKFHJHFJKUHVOUDHVJKHVJHFUODVHOVHOIHIOVH");
    print(listImage);
    if (mounted) {
      setState(() {});
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    cem =  CameraPosition(
      target: LatLng(widget.randonne.startingCoordinates.latitude , widget.randonne.startingCoordinates.longitude),
      zoom: 5,
    );
    _mapController = controller;
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
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

  Future<void> setMarkers() async {
    Marker start = Marker(
      markerId: const MarkerId("Start"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: LatLng(widget.randonne.startingCoordinates.latitude,
          widget.randonne.startingCoordinates.longitude),
    );
    Marker end = Marker(
      markerId: const MarkerId("End"),
      position: LatLng(widget.randonne.endingCoordinates.latitude,
          widget.randonne.endingCoordinates.longitude),
    );
    try {
      coordonnees = await getCoordinates(widget.randonne.id);
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
    for (var c in coordonnees) {
      markers.add(Marker(
        markerId: const MarkerId("Waypoint"),
        position: LatLng(c.latitude, c.longitude),
        visible: false,
      ));
    }
    cem = CameraPosition(target: LatLng(widget.randonne.startingCoordinates.latitude,
        widget.randonne.startingCoordinates.longitude),
        zoom: 10
    );

    SEMark.add(start);
    SEMark.add(end);
  }

  Future<void> _showMapOverlay() async {
    //On Ajoute les markers
    markers.clear();
    polylineCoordinates.clear();
    await setMarkers();

    //On Utilise les markers pour faire les polylines et on les supprimes
    if (markers.length > 1) {
      for (var mark in markers) {
        polylineCoordinates.add(mark.position);
      }
      await addPolyLine(polylineCoordinates);
      markers.clear();
    }
    //On affiche le dialogue
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Dialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.black12,
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.5), // Adjust the opacity as needed
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    mapType: MapType.terrain,
                    initialCameraPosition: cem,
                    markers: SEMark,
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double heightNmae = height *0.27;
    double heightInfo = height *0.35;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                TopPage(width, height, context),
                Positioned(
                  top: heightNmae,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    width: width*0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          spreadRadius: 2,  // Spread radius
                          blurRadius: 7,    // Blur radius
                          offset: const Offset(0, 3), // Offset from the top
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(widget.randonne.name, style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),),
                  ),
                ),
                TrailInfo(heightInfo, context, height),
                Buttons(width, context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack TopPage(double width, double height, BuildContext context) {
    return Stack(
      children: [
      SizedBox(
      width: width,
      height: height * 0.3,
      child: listImage.isNotEmpty
          ? CarouselSlider(
        options: CarouselOptions(
          height: height * 0.3,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          pauseAutoPlayOnManualNavigate: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 250),
          viewportFraction: 1,
        ),
        items: listImage.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(width: 50, height: 50, child: CircularProgressIndicator(value: downloadProgress.progress),),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        }).toList(),
      )
          : CachedNetworkImage(
        imageUrl: widget.randonne.imageUrl!,
        fit: BoxFit.fill,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator(value: downloadProgress.progress),),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),

    Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              _showMapOverlay();
            },
            child: Container(
              margin: const EdgeInsets.all(14),
              width: width * 0.15,
              height: height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius:BorderRadius.circular(10) ,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.terrain,
                  initialCameraPosition: cem,
                  markers: SEMark,
                  polylines: Set<Polyline>.of(polylines.values),
                  onTap: (LatLng lat) {
                    _showMapOverlay();
                  },
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
          ),
        ),

        Positioned(top:50, left: 10, child: Container( decoration:  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const navBar(page: 0)));
          }, icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,),),
        )),
      ],
    );
  }

  Positioned TrailInfo(double heightInfo, BuildContext context, double height) {
    return Positioned(
      top: heightInfo,
      left: 10,
      right: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).location,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        widget.randonne.location,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20), // Adjust the space between columns
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).type,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      (widget.randonne.type == 1)
                          ? const Icon(IconData(0xe1d2, fontFamily: 'MaterialIcons'), size: 30,)
                          : Icon(IconData(0xe1e1, fontFamily: 'MaterialIcons'), size: 30,),
                      (isConnected) ? GestureDetector(
                        onTap: () async{
                          try{
                            var response = await manageTrailFavorite(widget.randonne.id, favorite);
                            favorite = response;
                          }
                          catch (e){
                            throw e;
                          }
                          setState(() {});
                        },
                        child: (favorite)
                            ? Icon(Icons.bookmark, color: Colors.black, size: 36,)
                            : Icon(Icons.bookmark_outline, color: Colors.black, size: 36,),
                      ) : Text("")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height *0.02,),
            Container(
              height: 2,
              width: double.infinity,
              color: Colors.black,
            ),
            SizedBox(height: height *0.02,),
            Text(
              widget.randonne.description,
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(fontSize: 16),
              ),)
          ],
        ),
      ),
    );
  }

  Padding Buttons(double width, BuildContext context) {
    return Padding(
      padding: owner ? const EdgeInsets.all(3.0) : const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: width *0.45,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HikePage(randonne: widget.randonne)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(S.of(context).start, style: GoogleFonts.plusJakartaSans(
                          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)
                      ),
                    ),
                  )
              ),
              SizedBox(width: width * 0.03),
              SizedBox(
                width: width * 0.45,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text(
                    S.of(context).getDirections,
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                owner ?  Container(
                    width: width * 0.83,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: !widget.randonne.isPublic ? ElevatedButton(
                      onPressed: (){
                        SetPublic(widget.randonne.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(S.of(context).rendrePublique, style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        )
                      )),
                    ) : MaterialButton(
                      onPressed: () {
                        SetPrivate(widget.randonne.id);
                      },
                      color: Colors.pinkAccent, child: Text(S.of(context).rendrePriv, style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        )
                    )),)
                ) : const SizedBox()
              ]
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              owner && coordonnees.length < 3 ? SizedBox(width: width * 0.83,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuiviPage(randonne: widget.randonne),
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).faireLeTrajet,
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ) : const SizedBox(width: 0),
            ],
          ),
        ],
      ),
    );
  }

}

