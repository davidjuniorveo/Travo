import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:image_picker/image_picker.dart';


class ComposeBottomIconWidget extends StatefulWidget {
  
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelcted;
  ComposeBottomIconWidget({Key key, this.textEditingController, this.onImageIconSelcted}) : super(key: key);
  
  @override
  _ComposeBottomIconWidgetState createState() => _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {

 bool reachToWarning = false;
 bool reachToOver = false;
 Color wordCountColor;
 String post = '';
 
 @override
 void initState() { 
   wordCountColor = Colors.blue;
   widget.textEditingController.addListener(updateUI);
   super.initState();
 }
 void updateUI(){
   setState(() {
     post = widget.textEditingController.text;
     if (widget.textEditingController.text != null &&
          widget.textEditingController.text.isNotEmpty) {
            if (widget.textEditingController.text.length > 259 &&
                widget.textEditingController.text.length < 280) {
              wordCountColor = Colors.orange;
            } else if (widget.textEditingController.text.length >= 280) {
              wordCountColor = Theme.of(context).errorColor;
            } else {
              wordCountColor = Colors.blue;
            }
           }
   });
 }
 Widget _bottomIconWidget() {
    return GestureDetector(
      onTap: () {
          setImage(ImageSource.gallery);
        },
      child: Container(
        width: fullWidth(context),
        height: 50,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            color: Theme.of(context).backgroundColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
                'Tap to add image(*Required)',
                style: GoogleFonts.muli(
                  fontSize: 16,
                  color: Color(0xfff75336),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis
            )
          ],

        ),
      )
    );
  }
  void setImage(ImageSource source) {
    ImagePicker.pickImage(source: source, imageQuality: 100).then((File file) {
      setState(() {
        // _image = file;
        widget.onImageIconSelcted(file);
      });
    });
  }
  double getPostLimit() {
    if (post == null ||
        post.isEmpty) {
      return 0.0;
    }
    if (post.length > 280) {
      return 1.0;
    }
    var length = post.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: _bottomIconWidget(),
    );
  }
}