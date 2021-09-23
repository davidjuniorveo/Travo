import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/theme.dart';
import 'package:image_picker/image_picker.dart';


Widget customTitleText(String title, {BuildContext context}){
  return Text(title ?? '',style: TextStyle(
      color: Color(0xfff75336),
      fontWeight:FontWeight.w800,
      fontSize: 18),
  );
}

Widget customText1(String title, {BuildContext context}){
  return Text(title ?? '',style: TextStyle(
      color: Colors.black87,
      fontWeight:FontWeight.bold,
      fontSize: 20),
      textAlign: TextAlign.center,
      maxLines: 4,
      overflow: TextOverflow.ellipsis
  );
}

Widget  heading(String heading,{double horizontalPadding = 10,BuildContext context}){
  double fontSize =  16;
  if(context != null){
     fontSize = getDimention(context,16) ;
  }
    return Padding(
               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(heading,style: AppTheme.apptheme.typography.dense.display1.copyWith(fontSize: fontSize),),);
  }
Widget userImage(String path, {double height = 100}){
  return  Container(
          child:  Container(
          width: height,height: height,
          alignment:   FractionalOffset.topCenter,
           decoration: BoxDecoration(
                  boxShadow: shadow,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(height/2),
                  image: DecorationImage( image: NetworkImage(path))
            ),
          ));
}
Widget customIcon(BuildContext context,{int icon, bool isEnable = false,double size = 18,bool istwitterIcon = true, bool isFontAwesomeRegular = false,bool isFontAwesomeSolid = false,Color iconColor, double paddingIcon  = 10}){
  iconColor = iconColor ?? Theme.of(context).textTheme.caption.color;
  return  Padding(
    padding: EdgeInsets.only( bottom:istwitterIcon ?  paddingIcon: 0),
    child: Icon(
             IconData(
               icon,fontFamily: istwitterIcon ? 'TwitterIcon' : isFontAwesomeRegular ? 'AwesomeRegular' : isFontAwesomeSolid ? 'AwesomeSolid' : 'Fontello'),
               size: size,color: isEnable 
               ? Theme.of(context).primaryColor :
                iconColor,),
  );
}
Widget customTappbleIcon(BuildContext context,int icon ,{double size = 16,bool isEnable =false, Function(bool,int) onPressed1,bool isBoolValue,int id,
                         Function onPressed2,bool isFontAwesomeRegular = false,bool istwitterIcon = false,bool isFontAwesomeSolid = false,Color iconColor,EdgeInsetsGeometry padding}){
 if(padding == null){
   padding  = EdgeInsets.all(10);
 }
 return MaterialButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minWidth: 10,height: 10,
    padding: padding,
    shape: CircleBorder(),
    color: Colors.transparent,
    elevation: 0,
    onPressed: (){
      if(onPressed1 != null){
       onPressed1(isBoolValue,id);
      }
      else if(onPressed2 != null){
        onPressed2();
      }
  }
  ,child:  customIcon(context,icon:icon,size: size,isEnable: isEnable,istwitterIcon:istwitterIcon,isFontAwesomeRegular:isFontAwesomeRegular,isFontAwesomeSolid: isFontAwesomeSolid,iconColor: iconColor ));
}
Widget customText(
    String msg,
    {Key key, TextStyle style,TextAlign textAlign = TextAlign.justify,TextOverflow overflow = TextOverflow.visible,BuildContext context,bool softwrap = true}){

  if(msg == null){
    return SizedBox(height: 0,width: 0,);
  }
  else{
    if(context != null && style != null){
      var fontSize = style.fontSize ?? Theme.of(context).textTheme.body1.fontSize;
      style =  style.copyWith(fontSize: fontSize - ( fullWidth(context) <= 375  ? 2 : 0));
    }
    return Text(msg,style: style,textAlign: textAlign,overflow:overflow,softWrap: softwrap,key: key,);
  }
}

Widget customImage(BuildContext context, String path,{double height = 60, bool isBorder = false,}){
  return Container(
       padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
       shape: BoxShape.circle,
       border: Border.all(
           color: Colors.white,
           width: 1
       ),
      ) ,
     child: CircleAvatar(
        maxRadius: height/2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:  customAdvanceNetworkImage(path ?? dummyimage),
   ));
}

Widget customImage4(BuildContext context, String path,{double height = 50, bool isBorder = false,}){
  return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white,
            width: 4
        ),
        color: Colors.white,
        shape: BoxShape.circle,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
            ]
        ),
      ) ,
      child: CircleAvatar(
        maxRadius: height/2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:  customAdvanceNetworkImage(path ?? dummyimage),
      ));
}

Widget customImage5(BuildContext context, String path,{double height = 50, bool isBorder = false,}){
  return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ]
        ),
      ) ,
      child: CircleAvatar(
        maxRadius: height/2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:  customAdvanceNetworkImage(dummyimage),
      )
  );
}

Widget customImage2(BuildContext context, String path,{double height = 50, bool isBorder = false,}){
  return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.white,
            width: 2
        ),
      ) ,
      child: CircleAvatar(
        maxRadius: height/2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:  customAdvanceNetworkImage(path ?? dummyimage),
      ));
}


Widget customImage1(BuildContext context, String path,{double height = 50, bool isBorder = false,}){
  return
    Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white,
              width: 1
          ),
        ) ,
        child: CircleAvatar(
          maxRadius: height/2,
          backgroundColor: Colors.transparent,
          backgroundImage:  customAdvanceNetworkImage(path ?? dummyimage),
        )
    );
}


double fullWidth(BuildContext context) {
  // cprint(MediaQuery.of(context).size.width.toString());
  return MediaQuery.of(context).size.width;
} 
double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
} 
Widget customInkWell({
  Widget child,
  BuildContext context,
  Function(bool,int)
  function1,Function onPressed,bool isEnable = false,
  int no = 0,
  Color color = Colors.transparent,
  Color splashColor,BorderRadius radius}){

  if(splashColor == null){
    splashColor = Theme.of(context).primaryColorLight;
  }
  if(radius == null){
    radius = BorderRadius.circular(0);
  }
  return Material(
    
    color:color,
    child: InkWell(
      borderRadius: radius,
      onTap: (){
        if(function1 != null){
          function1(isEnable,no);
        }
        else if(onPressed != null){
          onPressed();
        }
      },
      splashColor: splashColor,
      child: child,
    ),
  );
}
SizedBox sizedBox({double height = 5, String title}){
    return SizedBox(
      height: title == null || title.isEmpty ? 0 : height,
    );
  }

Widget customNetworkImage(String path,{BoxFit fit = BoxFit.contain}){
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path ?? dummyimage,
    imageBuilder: (context, imageProvider) =>
        Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: fit,
           ),
      ),
    ),
    placeholderFadeInDuration: Duration(milliseconds: 500),
    placeholder: (context, url) => Container(
      color: Color(0xffeeeeee),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget customNetworkImage4(String path,{BoxFit fit = BoxFit.contain}){
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path ?? dummyimage,
    imageBuilder: (context, imageProvider) =>
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
    placeholderFadeInDuration: Duration(milliseconds: 500),
    placeholder: (context, url) => Container(
      color: Color(0xffeeeeee),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget customNetworkImage1(String path,{BoxFit fit = BoxFit.contain}){
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path ?? dummyimage,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    ),
    placeholderFadeInDuration: Duration(milliseconds: 500),
    placeholder: (context, url) => Container(
      color: Colors.transparent,
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget customNetworkImage2(String path,{BoxFit fit = BoxFit.contain}){
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path ?? dummyimage,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xffffffff),
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    ),
    placeholderFadeInDuration: Duration(milliseconds: 500),
    placeholder: (context, url) => Container(
      color: Color(0xffffffff),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}


dynamic customAdvanceNetworkImage(String path){
if(path == null){
    path = dummyimage;
  }
  return CachedNetworkImageProvider(
    path ?? dummyimage,
  );
}
void showAlert(BuildContext context,{@required Function onPressedOk,@required String title,String okText = 'OK', String cancelText = 'Cancel'}) async{
   showDialog(
     context: context,
     builder: (context){ return  customAlert(context,onPressedOk: onPressedOk,title: title,okText: okText,cancelText: cancelText);  }
   );
  }
Widget customAlert(BuildContext context,{@required Function onPressedOk,@required String title,String okText = 'OK', String cancelText = 'Cancel'}) {
    return AlertDialog(
          title: Text('Alert',style: TextStyle(fontSize: getDimention(context,25),color: Colors.black54)),
          content: customText(title,style: TextStyle(color: Colors.black45)),
          actions: <Widget>[
          FlatButton(
            textColor: Colors.grey,
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(cancelText),
           ),
           FlatButton(
             textColor: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.pop(context);
              onPressedOk();
            },
            child: Text(okText),
         )
       ],
    );
  }
void customSnackBar(GlobalKey<ScaffoldState> _scaffoldKey,String msg,{double height = 30, Color backgroundColor = Colors.black}){
    if( _scaffoldKey == null || _scaffoldKey.currentState == null){
      return;
    }
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content:Text(msg, style: TextStyle(color:Colors.white,),));
           _scaffoldKey.currentState.showSnackBar(snackBar);
  }
Widget emptyListWidget(BuildContext context, String title,{String subTitle,String image = 'emptyImage.png'}){
  return Container(
     color: Color(0xfffafafa),
    child:Center(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: fullWidth(context) * .95,
          height: fullWidth(context) * .95,
          decoration: BoxDecoration(
            // color: Color(0xfff1f3f6),
            boxShadow: <BoxShadow>[
              // BoxShadow(blurRadius: 50,offset: Offset(0, 0),color: Color(0xffe2e5ed),spreadRadius:20),
              BoxShadow(offset: Offset(0, 0),color: Color(0xffe2e5ed),),
              BoxShadow(blurRadius: 50,offset: Offset(10,0),color: Color(0xffffffff),spreadRadius:-5),
            ],
            shape: BoxShape.circle
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            customText(title,style: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7))),
            customText(subTitle,style: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))),
        ],) 
    ],)
  )
  );
}


 Widget loader(){
   if(Platform.isIOS){
     return Center(child: CupertinoActivityIndicator(),);
   }
   else{
     return Center(
       child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),),
     );
   }
 }
  Widget customSwitcherWidget({@required child, Duration duraton = const Duration(milliseconds: 500)}){
   return AnimatedSwitcher(
      duration: duraton,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: child,
   );
  }
  
  Widget customExtendedText(String text, bool isExpanded,{BuildContext context, TextStyle style,@required Function onPressed, @required TickerProvider provider,AlignmentGeometry alignment = Alignment.topRight,@required EdgeInsetsGeometry padding , int wordLimit = 100,bool isAnimated = true }){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         AnimatedSize(
          vsync: provider,
          duration:  Duration(milliseconds: (isAnimated ? 500 : 0)),
          child: ConstrainedBox(
            constraints: isExpanded  ?  BoxConstraints() :  BoxConstraints(maxHeight: wordLimit == 100 ? 100.0 : 260.0),
              child:  customText(
                text,
                softwrap: true,
                overflow: TextOverflow.fade,
                style: style ,
                context: context,
                textAlign: TextAlign.start))),
              text != null && text.length > wordLimit ? 
              Container(
                alignment: alignment,
                child: InkWell(
                 onTap: onPressed,
                  child: Padding(
                    padding: padding,
                    child: Text(!isExpanded ? 'more...' : 'Less...',style: TextStyle(color: Colors.blue,fontSize: 14),),
                  )
                )
                ,
              )
               : Container()
    ]);
  }
  double getDimention(context, double unit){
  if(fullWidth(context) <= 360.0){
    return unit / 1.3;
  }
  else {
    return unit;
  }
}
Widget customListTile(BuildContext context,{Widget title,Widget subtitle, Widget leading,Widget trailing,Function onTap}){
   return customInkWell(
     context: context,
     onPressed: (){if(onTap != null){onTap();}},
     child: Padding(
       padding: EdgeInsets.symmetric(vertical: 0),
       child:Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           SizedBox(width: 10,),
           Container(
                 width: 40,
                 height: 40,
                 child: leading,
               ),
           SizedBox(width: 20,),
           Container(
             width: fullWidth(context) - 80 ,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Row(
                   children: <Widget>[
                     Expanded(child:title ?? Container()),
                    trailing ?? Container(),
                   ],
                 ),
                 subtitle
               ],
             ),
           ),
            SizedBox(width: 10,),
         ],
       )
     )
   );
}

openImagePicker(BuildContext context, Function onImageSelected) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.4, // half screen on load
        maxChildSize: 1, // full screen on scroll
        minChildSize: 0.3,
        builder: (BuildContext context,
            ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(top: 10, bottom: 2, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
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
                              'Upooad\tprofile\timage\nfrom\tgallery',
                              style: GoogleFonts.muli(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ]
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(Radius.circular(28)),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    color: Colors.grey[200],
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontFamily: 'HelveticaNeue',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Flexible(
                                child:  Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff75336),
                                    borderRadius: BorderRadius.all(Radius.circular(28)),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      getImage(context, ImageSource.gallery,onImageSelected);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    color: Color(0xfff75336),
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: Text(
                                      'Gallery',
                                      style: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'HelveticaNeue',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        )
                      ]
                  )
                ]
            ),
          );
        },
      );
    },
  );
}


  getImage(BuildContext context, ImageSource source,Function onImageSelected) {
    ImagePicker.pickImage(source: source,imageQuality: 100).then((File file) {
      onImageSelected(file);
      Navigator.pop(context);
    });
  }