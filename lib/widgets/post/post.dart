import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/feedState.dart';
import 'package:provider/provider.dart';
import 'package:streambox/widgets/post/widgets/postIconsRow.dart';
import 'package:streambox/widgets/post/widgets/postImage.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:provider/provider.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';

class Post extends StatelessWidget {

  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;
  const Post(
      {Key key,
        this.model,
        this.trailing,
        this.type = PostType.Post,
        this.isDisplayOnProfile = false})
      : super(key: key);


  void onTapPost(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == PostType.Detail || type == PostType.ParentPost) {
      return;
    }
    if (type == PostType.Post && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyPostStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: AspectRatio(
            aspectRatio: 1 / 1.5,
            child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 0, left: 0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      PostImage(
                        model: model,
                        type: type,
                      ),
                      AspectRatio(
                          aspectRatio: 1 / 1.5,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      stops: [.2, .9],
                                      colors: [
                                        Colors.black45.withOpacity(.5),
                                        Colors.black45.withOpacity(.1),
                                      ]
                                  )
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: PostIconsRow1(
                                            type: type,
                                            model: model,
                                            isPostDetail: type == PostType.Detail,
                                            iconColor: Theme.of(context).textTheme.caption.color,
                                            iconEnableColor: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: PostIconsRow(
                                            type: type,
                                            model: model,
                                            isPostDetail: type == PostType.Detail,
                                            iconColor: Theme.of(context).textTheme.caption.color,
                                            iconEnableColor: Color(0xfff75336),
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      model.description == null
                                      ? SizedBox(height: 0)
                                      : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                  '${model.description}'.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis
                                              )
                                            ),
                                            Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: const EdgeInsets.fromLTRB(2, 2, 4, 0),
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent,
                                                          shape: BoxShape.circle
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      model.price == null
                                          ? SizedBox(height: 0)
                                          : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    '${model.price}'.toLowerCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      model.save == null
                                          ? SizedBox(height: 0)
                                          : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    '${model.save}'.toLowerCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      onTapPost(context);
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffffffff),
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text(
                                                                  'Check this out',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                  textAlign: TextAlign.start,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis
                                                              ),
                                                            ]
                                                        )
                                                    )
                                                )
                                            ),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}

class Post1 extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;

  const Post1(
      {Key key,
        this.model,
        this.trailing,
        this.type = PostType.Post,
        this.isDisplayOnProfile = false})
      : super(key: key);


  void onTapPost(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == PostType.Detail || type == PostType.ParentPost) {
      return;
    }
    if (type == PostType.Post && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyPostStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0),
            child: PostImage1(
              model: model,
              type: type,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                    model.description  ?? 'Not Added',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                    model.price   ?? 'Not Added',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xfff75336),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                    model.duration   ?? 'Not Added',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                    model.save   ?? 'Not Added',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            height: 50,
            width: double.infinity,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xfff75336),
              shape: BoxShape.rectangle,
            ),
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Color(0xfff75336),
                onPressed: () {
                  Navigator.of(context).pushNamed('/ProfilePage/' + model?.userId);
                },
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Get\tin\ttouch\t',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  ],
                )
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            decoration: BoxDecoration(
              color:  Colors.grey[50],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xfff75336),
              ),
            ],
          ),
          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            decoration: BoxDecoration(
              color:  Colors.grey[50],
            ),
          ),
          SizedBox(height: 10),
          Text(
              model.details ?? 'Not Added',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis
          ),
          SizedBox(height: 20),
          Text(
              'People interested',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis
          ),
          Padding(
            padding: EdgeInsets.only(left: 0),
            child: PostIconsRow2(
              type: type,
              model: model,
              isPostDetail: type == PostType.Detail,
              iconColor: Theme.of(context).textTheme.caption.color,
              iconEnableColor: StreamboxColor.ceriseRed,
              size: 20,
            ),
          ),
          SizedBox(height: 10),
        ],
      )
    );
  }
}

class Post2 extends StatelessWidget {

  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;
  const Post2(
      {Key key,
        this.model,
        this.trailing,
        this.type = PostType.Post,
        this.isDisplayOnProfile = false})
      : super(key: key);


  void onTapPost(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == PostType.Detail || type == PostType.ParentPost) {
      return;
    }
    if (type == PostType.Post && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyPostStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: AspectRatio(
            aspectRatio: 1 / 1.0,
            child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 0, left: 0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      PostImage2(
                        model: model,
                        type: type,
                      ),
                      AspectRatio(
                          aspectRatio: 1 / 1.0,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      stops: [.2, .9],
                                      colors: [
                                        Colors.black45.withOpacity(.5),
                                        Colors.black45.withOpacity(.1),
                                      ]
                                  )
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Container(
                                              width: 100,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.transparent,
                                                ),
                                                color: Colors.white70,
                                                borderRadius: BorderRadius.all(Radius.circular(24)
                                                ),
                                              ),
                                              child: FlatButton(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                                  color: Colors.white70,
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                                  child: TitleText(
                                                      '\tMore\t',
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                      overflow: TextOverflow.ellipsis
                                                  ),
                                                  onPressed: () {
                                                    _openbottomSheet(context, type, model);
                                                  }
                                              )
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: PostIconsRow(
                                            type: type,
                                            model: model,
                                            isPostDetail: type == PostType.Detail,
                                            iconColor: Theme.of(context).textTheme.caption.color,
                                            iconEnableColor: Color(0xfff75336),
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      model.description == null
                                          ? SizedBox(height: 0)
                                          : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    '${model.description}'.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis
                                                )
                                            ),
                                            Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: const EdgeInsets.fromLTRB(2, 2, 4, 0),
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent,
                                                          shape: BoxShape.circle
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      model.price == null
                                          ? SizedBox(height: 0)
                                          : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    '${model.price}'.toLowerCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      model.save == null
                                          ? SizedBox(height: 0)
                                          : Padding(
                                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    '${model.save}'.toLowerCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      onTapPost(context);
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffffffff),
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text(
                                                                  'Check this out',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                  textAlign: TextAlign.start,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis
                                                              ),
                                                            ]
                                                        )
                                                    )
                                                )
                                            ),
                                            Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                      )
                    ],
                  ),
                )
            )
        )
    );
  }

  void _openbottomSheet(BuildContext context, PostType type, FeedModel model) async {
    var authState = Provider.of<AuthState>(context, listen: false);
    bool isMyPost = authState.userId == model.userId;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) *
                (type == PostType.Post
                    ? (isMyPost ? .25 : .44)
                    : (isMyPost ? .38 : .52)),
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == PostType.Post
                ? _postOptions(context, isMyPost, model, type)
                : _postDetailOptions(context, isMyPost, model, type));
      },
    );
  }

  Widget _postDetailOptions(BuildContext context, bool isMyPost, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        isMyPost
            ? _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Delete Post',
          onPressed: () {
            _deletePost(
              context,
              type,
              model.key,
              parentkey: model.parentkey,
            );
          },
          isEnable: true,
        )
            :  _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Action performed by owner',
          onPressed: () {
            _deletePost(
              context,
              type,
              model.key,
              parentkey: model.parentkey,
            );
          },
          isEnable: true,
        ),
      ],
    );
  }

  Widget _postOptions(
      BuildContext context, bool isMyPost, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        isMyPost
            ? _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Delete Post',
          onPressed: () {
            _deletePost(
              context,
              type,
              model.key,
              parentkey: model.parentkey,
            );
          },
          isEnable: true,
        )
            :
        _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Action performed by owner',
          isEnable: true,
        ),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, int icon,
      {String text, Function onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null)
            onPressed();
          else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
              SizedBox(
                width: 15,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePost(BuildContext context, PostType type, String postId,
      {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deletePost(postId, type, parentkey: parentkey);
    // CLose bottom sheet
    Navigator.of(context).pop();
    if (type == PostType.Detail) {
      // Close Post detail page
      Navigator.of(context).pop();
      // Remove last post from post detail stack page
      state.removeLastPostDetail(postId);
    }
  }

  void openRepostbottomSheet(
      BuildContext context, PostType type, FeedModel model) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _repost(context, model, type));
      },
    );
  }

  Widget _repost(BuildContext context, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

}

