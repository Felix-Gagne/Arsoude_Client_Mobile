import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Http/Models.dart';
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
  CameraPosition cem = CameraPosition(
    target: LatLng(45.536447 , -73.495223),
    zoom: 10,
  );

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


    Future<void> _showMapOverlay() async {

    markers.clear();
    polylineCoordinates.clear();
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
      coordonnees = await getCoordinates(widget.randonne.id);

      cem = CameraPosition(target: LatLng(widget.randonne.startingCoordinates.latitude,
          widget.randonne.startingCoordinates.longitude),
          zoom: 10
      );

        SEMark.add(start);
        SEMark.add(end);

        for (var c in coordonnees) {
          markers.add(Marker(
            markerId: MarkerId("Waypoint"),
            position: LatLng(c.latitude, c.longitude),
            visible: false,

          ));
        }

        if (markers.length > 1) {
          for (var mark in markers) {
                polylineCoordinates.add(mark.position);
          }
         await addPolyLine(polylineCoordinates);
          markers.clear();
        }
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            // Replace this with your map overlay widget
            return Container(
              height: 10000, // Set the height of the overlay as needed
              color: Colors.white, // Background color of the overlay
              child: Center(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  mapType: MapType.terrain,
                  initialCameraPosition: cem,
                  markers: SEMark,
                  polylines: Set<Polyline>.of(polylines.values),
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(

            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.3,
                      child: Image.network(widget.randonne.imageUrl, fit: BoxFit.cover,),
                    ),
                    // Making background darker
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7), // Adjust opacity as needed
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Map icon

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showMapOverlay();
                        },
                        child: Container(
                            margin: EdgeInsets.all(14),
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
                                print(lat);
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

                    Positioned(top:10, left: 10, child: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const navBar(page: 0)));
                    }, icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),)),
                  ],
                ),

                Positioned(
                  top: 227,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Shadow color
                            spreadRadius: 2,  // Spread radius
                            blurRadius: 7,    // Blur radius
                            offset: Offset(0, 3), // Offset from the top
                          ),
                        ],
                    ),
                    child: Text(widget.randonne.name, style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),),
                    padding: EdgeInsets.all(8),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
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
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.randonne.location,
                                      style: GoogleFonts.plusJakartaSans(
                                        textStyle: TextStyle(
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
                                        ? Icon(
                                      IconData(0xe1d2, fontFamily: 'MaterialIcons'),
                                      size: 30,
                                    )
                                        : Icon(
                                      IconData(0xe1e1, fontFamily: 'MaterialIcons'),
                                      size: 30,
                                    ),
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
                          Text(widget.randonne.description, style: GoogleFonts.plusJakartaSans(
                              textStyle: TextStyle(
                                  fontSize: 16
                              )
                          ),),

                        ],
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.87,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4), // shadow color
                                  spreadRadius: 1, // spread radius
                                  blurRadius: 5, // blur radius
                                  offset: Offset(5, 5), // changes position of shadow
                                ),

                              ],
                            ),
                            child: !widget.randonne.isPublic ? MaterialButton(onPressed: (){
                                   SetPublic(widget.randonne.id);

                            }, child: Text("Rendre publique", style: GoogleFonts.plusJakartaSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                )
                            )), color: Colors.blue,) : MaterialButton(onPressed: (){
                              SetPrivate(widget.randonne.id);
                            }, child: Text("Rendre Privé", style: GoogleFonts.plusJakartaSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                )
                            )), color: Colors.pinkAccent,)
                          )
                        ],

                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width *0.4,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4), // shadow color
                                  spreadRadius: 1, // spread radius
                                  blurRadius: 5, // blur radius
                                  offset: Offset(5, 5), // changes position of shadow
                                ),

                              ],
                            ),
                            child : MaterialButton(onPressed: (){}, child: Text(S.of(context).getDirections, style: GoogleFonts.plusJakartaSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                )
                            )), color: Colors.grey,),
                          ),
                          SizedBox(width: width*0.07,),
                          Container(
                            width: width *0.4,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4), // shadow color
                                  spreadRadius: 1, // spread radius
                                  blurRadius: 5, // blur radius
                                  offset: Offset(5, 5), // changes position of shadow
                                ),
                                
                              ],
                            ),
                            child: MaterialButton(
                              onPressed: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => SuiviPage(randonne: widget.randonne,))
                               ); },
                              child: Text(S.of(context).start, style: GoogleFonts.plusJakartaSans(
                                textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                              )
                            ),), color: Colors.green,)
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Row difficulty() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 7,
          color: Colors.red,
        ),
        SizedBox(width: 4),
        Container(
          width: 30,
          height: 7,
          color: Colors.red,
        ),
        SizedBox(width: 4),
        Container(
          width: 30,
          height: 7,
          color: Colors.red,
        ),
      ],
    );
  }

}

