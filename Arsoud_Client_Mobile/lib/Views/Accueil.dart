import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Http/Models.dart';

import '../Http/HttpService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = SearchController();
  List<Randonne> listTrails = [];

  Future<List<Randonne>> refresh() async {
    listTrails = await getTrailListUser();
    return listTrails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vos randonnées',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 25,),
                  FutureBuilder<List<Randonne>>(
                    future: refresh(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          width: 400,
                          child: Text(
                            "Nous rencontrons un probleme avec le serveur actuellement veuillez revenir plus tard.",
                              style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              )
                          ),
                        );
                      } else if(listTrails.length == 0){
                        return SizedBox(
                          width: 400,
                          child: Text("Vous n'avez crée aucune randonnée jusqu\'à aujourd\'hui. Afin de continuer \ndans cette section veuillez \ncrée une randonnée.",
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16
                              )
                          ),),
                        );
                      }
                      else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: listTrails.length,
                            itemBuilder: (BuildContext context, int index) {
                              Randonne randonne = listTrails[index];
                              var typeTrail;
                              var icon;
                              if(randonne.type ==1){
                                typeTrail = "Vélo";
                                 icon = IconData(0xe1e1, fontFamily: 'MaterialIcons');
                              }
                              else{
                                typeTrail = "Pieds";
                                icon = IconData(0xe1d2, fontFamily: 'MaterialIcons');
                              }
                              return Container(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 25),
                                child: Row(
                                  children: [

                                    Container(
                                      height: 100,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            spreadRadius: 0.5,
                                            blurRadius: 10,
                                            offset: Offset(7, 10), // changes the position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: (randonne.imageUrl != "")
                                            ? Image.network(
                                          randonne.imageUrl,
                                          fit: BoxFit.cover,
                                          width: 160, // Ensure consistent width
                                          height: 100, // Ensure consistent height
                                        )
                                            : Image.asset(
                                          "assets/Images/imagePlaceholder.jpg",
                                          fit: BoxFit.cover,
                                          width: 160, // Ensure consistent width
                                          height: 100, // Ensure consistent height
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0,),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: Text(
                                              randonne.name,
                                              style:
                                              GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 160,
                                            child: Text(
                                              randonne.description,
                                              style:
                                              GoogleFonts.plusJakartaSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 180,
                                            child: Row(
                                              children: [
                                                Text(typeTrail, style:
                                                GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                SizedBox(width: 5,),
                                                Icon(icon),
                                                Text(" -  Distance : 16km", style:
                                                GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
            borderRadius: BorderRadius.circular(36),
          ),
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Chercher une randonnée',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide(color: Colors.black, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide(color: Colors.black, width: 0.5),
              ),
              //Icon
              prefixIcon: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Image.asset(
                  'assets/Images/logoSearch.png',
                  height: 20,
                  width: 20,
                  scale: 0.9,
                ),
              ),
              suffixIcon: Container(
                width: 55,
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.filter_alt_outlined),
                    SizedBox(width: 5),
                    CircleAvatar(
                      radius: 12,
                      child: Text('-', textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
        ),
      ],
    );
  }
}
