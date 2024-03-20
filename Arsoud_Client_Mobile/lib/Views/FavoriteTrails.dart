import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Http/HttpService.dart';
import '../Http/Models.dart';
import '../generated/l10n.dart';
import 'ListOfTrails.dart';
import 'SearchBar.dart';

class FavoritTerails extends StatefulWidget {
  const FavoritTerails({Key? key});

  @override
  State<FavoritTerails> createState() => _FavoritTerailsState();
}

class _FavoritTerailsState extends State<FavoritTerails> {
  final searchController = SearchController();
  List<Randonne> listTrails = [];
  var distance;

  Future<List<Randonne>> refresh() async {
    listTrails = await getUserFavoriteTrails();
    return listTrails;
  }

  @override
  void dispose() {
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
                    S.of(context).favoriteTrail,
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
                          child: Text(S.of(context).noFavorites,
                              style: GoogleFonts.plusJakartaSans(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16))
                          ),
                        );
                      } else if (listTrails.isEmpty) {
                        return SizedBox(
                          width: 400,
                          child: Text(
                            S.of(context).noFavoriteTrails,
                            style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                        );
                      } else {
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
