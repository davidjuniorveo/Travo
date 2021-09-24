import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streambox/widgets/customWidgets.dart';

class ComposePostImage extends StatelessWidget {
  final File image;
  final Function onCrossIconPressed;
  const ComposePostImage({Key key, this.image, this.onCrossIconPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image == null
          ? Container(
             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
             child: Container(
               height: 250,
               width: fullWidth(context) * .8,
                 decoration: BoxDecoration(
                   color: Colors.grey[200],
                 borderRadius: BorderRadius.all(Radius.circular(10)
                 ),
                ),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Padding(
                       padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                       child: Text(
                           'Upload\ta\tcover\tphoto\tand\tmake\nyour\ttrip\tmore\nrecognizable\tto\tthe\ttravellers',
                           style: GoogleFonts.muli(
                             fontSize: 14,
                             color: Colors.black54,
                             fontWeight: FontWeight.w600,
                           ),
                           textAlign: TextAlign.center,
                           maxLines: 5,
                           overflow: TextOverflow.ellipsis
                       ),
                     ),
                   ]
               ),
              ),
            )
          : Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    height: 250,
                    width: fullWidth(context) * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xfffffff)
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 18,
                      onPressed: onCrossIconPressed,
                      icon: Icon(
                        Icons.close,
                        color: Color(0xfff75336),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
