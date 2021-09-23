import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:provider/provider.dart';


class PostImage extends StatelessWidget {
   PostImage(
      {Key key, this.model, this.type, this.isRepostImage = false})
      : super(key: key);

  final FeedModel model;
  final PostType type;
  final bool isRepostImage;


  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: model.imagePath == null
          ?
      Padding(
        padding: EdgeInsets.only(top: 0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                  image: DecorationImage(
                      image: AssetImage('assets/images/img.jpeg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ),
        ),
      )
          :
      Padding(
        padding: EdgeInsets.all(0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          onTap: () {
            if(type == PostType.ParentPost){
              return;
            }
            var state = Provider.of<FeedState>(context, listen: false);
            state.setPostToReply = model;
            Navigator.pushNamed(context, '/ImageViewPge');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: AspectRatio(
                aspectRatio: 1.2 / 1.8,
                child: customNetworkImage(
                    model.imagePath,
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PostImage1 extends StatelessWidget {
   PostImage1(
      {Key key, this.model, this.type, this.isRepostImage = false})
      : super(key: key);

  final FeedModel model;
  final PostType type;
  final bool isRepostImage;



  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: model.imagePath == null
          ?
      Padding(
        padding: EdgeInsets.only(top: 0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                      image: DecorationImage(
                          image: AssetImage('assets/images/img.jpeg'),
                          fit: BoxFit.cover
                      )
                  ),
                )
              ),
            ),
          ),
        ),
      )
          :
      Padding(
        padding: EdgeInsets.only(top: 0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          onTap: () {
            if(type == PostType.ParentPost){
              return;
            }
            var state = Provider.of<FeedState>(context, listen: false);
            state.setPostToReply = model;
            Navigator.pushNamed(context, '/ImageViewPge');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1.0,
                child: customNetworkImage(
                    model.imagePath,
                    fit: BoxFit.fill
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PostImage2 extends StatelessWidget {
  PostImage2(
      {Key key, this.model, this.type, this.isRepostImage = false})
      : super(key: key);

  final FeedModel model;
  final PostType type;
  final bool isRepostImage;


  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: model.imagePath == null
          ?
      Padding(
        padding: EdgeInsets.only(top: 0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                  image: DecorationImage(
                      image: AssetImage('assets/images/img.jpeg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ),
        ),
      )
          :
      Padding(
        padding: EdgeInsets.all(0),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          onTap: () {
            if(type == PostType.ParentPost){
              return;
            }
            var state = Provider.of<FeedState>(context, listen: false);
            state.setPostToReply = model;
            Navigator.pushNamed(context, '/ImageViewPge');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: AspectRatio(
                aspectRatio: 1.0 / 1.0,
                child: customNetworkImage(
                    model.imagePath,
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

