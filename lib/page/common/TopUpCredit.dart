import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';


class TopUpCredit extends StatefulWidget {

  @override
  _TopUpCreditState createState() => _TopUpCreditState();
}

class _TopUpCreditState extends State<TopUpCredit> {

  TextEditingController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xfff75336)),
          title: customTitleText('Top\tUp\tCredit'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                  'ENTER AMOUNT',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
              ),
              Container(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                enabled: true,
                controller: controller,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Eg. 10,000',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                ),
              ),
              Container(
                height: 40,
              ),
              Text(
                  'ENTER MOBILE\tMONEY\tNUMBER',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
              ),
              Container(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                enabled: true,
                controller: controller,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Eg. +256 771234567',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                ),
              ),
              Container(
                height: 100,
              ),
              RippleButton(
                splashColor: StreamboxColor.dodgetBlue_50.withAlpha(100),
                borderRadius: BorderRadius.all(Radius.circular(28)),
                onPressed: () => showConfirmation(context),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Color(0xfff75336),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  showConfirmation(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72, // half screen on load
          maxChildSize: 1, // full screen on scroll
          minChildSize: 0.5,
          builder: (BuildContext context,
              ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.only(top: 10, bottom: 2, left: 5, right: 5),
              margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: const Radius.circular(0),
                  bottomRight: const Radius.circular(0),
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 20, 2, 5),
                      child: Text(
                          'Wait for Confirmation!',
                          style: GoogleFonts.muli(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                      child: Text(
                          'You\twill\treceive\ta\tscreen\nmessage\tshortly\tprompting\tyou\nto\tinput\tyour\tMobile\tMoney\tPIN',
                          style: GoogleFonts.muli(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          color: Colors.grey[200],
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                ),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            );
          },
        );
      },
    );
  }

}