import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Http/Models.dart';
import 'package:location_distance_calculator/location_distance_calculator.dart';

import '../Http/HttpService.dart';
import '../generated/l10n.dart';
import 'DetailRandonné.dart';
import 'ListOfTrails.dart';
import 'SearchBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = SearchController();
  List<Randonne> listTrails = [];
  var distance;

  Future<List<Randonne>> refresh() async {
    listTrails = await getAllTrails();
    return listTrails;
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).discoverNewHikes,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  FutureBuilder<List<Randonne>>(
                    future: refresh(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          width: 400,
                          child: Text(
                            S.of(context).nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir,
                              style: GoogleFonts.plusJakartaSans(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              )
                          ),
                        );
                      } else if(listTrails.length == 0){
                        return SizedBox(
                          width: 400,
                          child: Text(S.of(context).noHikesExist,
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16
                              )
                          ),),
                        );
                      }
                      else {
                        return ListOfTrails(listTrails: listTrails);
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






