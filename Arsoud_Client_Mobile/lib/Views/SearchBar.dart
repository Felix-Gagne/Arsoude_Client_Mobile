import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 25, 5, 10),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ],
              borderRadius: BorderRadius.circular(36),
            ),
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: TextField(
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: S.of(context).chercherUneRandonne,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: const BorderSide(color: Colors.black, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: const BorderSide(color: Colors.black, width: 0.5),
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Image.asset(
                    'assets/Images/logoSearch.png',
                    height: 20,
                    width: 20,
                    scale: 0.9,
                  ),
                ),
                suffixIcon: Container(
                  width: 55,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: const Row(
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
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
