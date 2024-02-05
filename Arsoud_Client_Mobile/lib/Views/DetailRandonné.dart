import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Http/Models.dart';
import 'package:untitled/Views/Suivi.dart';

import 'navBar.dart';

class DetailRanonne extends StatefulWidget {
  const DetailRanonne({Key? key, required this.randonne});

  final Randonne randonne;

  @override
  State<DetailRanonne> createState() => _DetailRanonneState();
}

class _DetailRanonneState extends State<DetailRanonne> {



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
                      child: Container(
                        margin: EdgeInsets.all(14),
                        width: width * 0.15,
                        height: height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(top:10, left: 10, child: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const navBar(page: 0)));
                    }, icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),)),
                  ],
                ),
                //name randonné
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
                    child: Positioned(
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
                                    Text("Difficile", style: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                    SizedBox(height: height * 0.01),
                                    difficulty(),
                                    SizedBox(height: height * 0.03),
                                    Text(
                                      "10.5 Km",
                                      style: GoogleFonts.plusJakartaSans(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Distance",
                                      style: GoogleFonts.plusJakartaSans(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20), // Adjust the space between columns
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Location :",
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
                                    SizedBox(height: height * 0.03),
                                    Row(
                                      children: [
                                        Text(
                                          "Type : ",
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
                            child : MaterialButton(onPressed: (){}, child: Text("Get Directions", style: GoogleFonts.plusJakartaSans(
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
                                SuiviPage(randonne: widget.randonne);
                              },
                              child: Text("Start", style: GoogleFonts.plusJakartaSans(
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

