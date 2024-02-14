import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Http/Models.dart';
import '../generated/l10n.dart';
import 'DetailRandonné.dart';

class ListOfTrails extends StatelessWidget {
  const ListOfTrails({
    super.key,
    required this.listTrails,
  });

  final List<Randonne> listTrails;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: listTrails.length,
        itemBuilder: (BuildContext context, int index) {
          Randonne randonne = listTrails[index];
          var typeTrail;
          var icon;
          if(randonne.type == 1){
            typeTrail = "Vélo";
            icon = IconData(0xe1d2, fontFamily: 'MaterialIcons');

          }
          else{
            typeTrail = "Pieds";
            icon = IconData(0xe1e1, fontFamily: 'MaterialIcons');
          }
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailRanonne(randonne: randonne,)));
            },
            child: Container(
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
                      child: (randonne.imageUrl != null)
                          ? Image.network(
                        randonne.imageUrl!,
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
                            randonne.location,
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
                              Text(S.of(context).distance+"16km", style:
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
            ),
          );
        },
      ),
    );
  }
}
