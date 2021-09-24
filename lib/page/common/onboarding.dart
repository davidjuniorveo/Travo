import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';


class Onboarding extends StatefulWidget {

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  @override
  Widget build(BuildContext context) {

    final page = [
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffF5C536),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(2.5),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Lottie.asset(
                        'assets/images/bag.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Your\thost\nwill\ttake\tcare',
                  style: GoogleFonts.muli(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'of\ttravels,\ttransfers\tand\ta\tcool\nplace\tto\tstay',
                  style: GoogleFonts.muli(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Swipe to the Left or Right',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.lightBlueAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(2.5),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Ionicons.partly_sunny_outline,
                        size: 120,
                        color: Colors.white,
                      ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Flexible\npayment',
                  style: GoogleFonts.muli(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'all\tlegit\ncurrencies\tare\taccdeptable',
                  style: GoogleFonts.muli(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Swipe to the Left or Right',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xfffffffF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(2.5),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Lottie.asset(
                        'assets/images/man.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Relax\n&\tenjoy',
                  style: GoogleFonts.muli(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Sunbathe,\tCamp,\tswim,\thike\neat,\tdrink,\tcanoe,\tzip lining.......',
                  style: GoogleFonts.muli(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Swipe to the Left or Right',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.tealAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(2.5),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Ionicons.arrow_redo,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Share with\nfriends & family',
                  style: GoogleFonts.muli(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'have\ta\tgood\ttime,\tthe\tworld\tis\ntoo\tbig\tto\discover\tit\talone',
                  style: GoogleFonts.muli(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Swipe to the Left or Right',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.deepOrangeAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(2.5),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.masks,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'Travel\tsafe\tduring\nCOVID-19',
                  style: GoogleFonts.muli(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(
                  'expect\thand\tsanitiser,\ndisinfected\titems,\tface\tmasks',
                  style: GoogleFonts.muli(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Swipe to the Left or Right',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )
    ];

    Widget _floatingActionButton() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            'Go back',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Scaffold(
        floatingActionButton: _floatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: LiquidSwipe(
        pages: page,
        enableLoop: true,
        fullTransitionValue: 300,
        enableSlideIcon: true,
        waveType: WaveType.liquidReveal,
        positionSlideIcon: 0.5,
      )
    );
  }
}
