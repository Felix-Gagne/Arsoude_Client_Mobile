import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Http/HttpService.dart';
import 'SearchBar.dart';

import '../Http/Models.dart';
import '../generated/l10n.dart';
import 'Accueil.dart';
import 'ListOfTrails.dart';

class UserTrails extends StatefulWidget {
  const UserTrails({Key? key});

  @override
  State<UserTrails> createState() => _UserTrailsState();
}

class _UserTrailsState extends State<UserTrails> {
  final searchController = SearchController();
  List<Randonne> listTrails = [];
  var distance;

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
          SearchBarWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).vosRandonnes,
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
                              S.of(context).nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir,
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
                          child: Text(S.of(context).vousNavezCreAucuneRandonne,
                            style: GoogleFonts.plusJakartaSans(
                                textStyle: TextStyle(
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

