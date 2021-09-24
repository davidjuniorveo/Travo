import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/customRoute.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/page/common/usersListPage.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/state/notificationState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';


class PostIconsRow extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  final bool isPostDetail;
  final PostType type;
  const PostIconsRow(
      {Key key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.isPostDetail = false,
      this.type})
      : super(key: key);

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return GestureDetector(
        onTap: () {
          addLikeToPost(context);
        },
        child:  _iconWidget(
          context,
          icon: model.likeList.any((userId) => userId == authState.userId)
              ? AppIcon.heartFill
              : AppIcon.heartEmpty,
          onPressed: () {
            addLikeToPost(context);
          },
          iconColor: model.likeList.any((userId) => userId == authState.userId)
              ? iconEnableColor
              : Colors.white,
          size: 30,
        )
    );
  }


  Widget _iconWidget(BuildContext context,
      {
        int icon,
        Function onPressed,
        IconData sysIcon,
        Color iconColor,
        double size = 30}) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) onPressed();
      },
      icon: sysIcon != null
          ? Icon(sysIcon, color: Colors.black87, size: size)
          : customIcon(
        context,
        size: 30,
        icon: icon,
        istwitterIcon: true,
        iconColor: iconColor,
      ),
    );
  }


  void addLikeToPost(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToPost(model, authState.userId);
  }

  void onLikeTextPressed(BuildContext context) {
    Navigator.of(context).push(
      CustomRoute<bool>(
        builder: (BuildContext context) => UsersListPage(
          pageTitle: "Liked by",
          userIdsList: model.likeList.map((userId) => userId).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  _likeCommentsIcons(context, model);
  }
}

class PostIconsRow1 extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  final bool isPostDetail;
  final PostType type;

  const PostIconsRow1(
      {Key key,
        this.model,
        this.iconColor,
        this.iconEnableColor,
        this.size,
        this.isPostDetail = false,
        this.type})
      : super(key: key);

  Widget _userList(BuildContext context, List<String> list) {
    // List<String> names = [];
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    var state = Provider.of<NotificationState>(context, listen: false);
    if (list != null && list.length > 2) {
      list = list.take(2).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, state, (name) {
        // names.add(name);
      });
    }).toList();
    if (noOfUser > 2) {
      avaterList.add(
        Container(
            height: 28,
            width: 80,
            padding: EdgeInsets.only(top: 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white70,
              shape: BoxShape.rectangle,
            ),
            alignment: Alignment.center,
            child: TitleText(
                " +${noOfUser - 2}",
                color: Color(0xffff5a2a),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis
            )
        ),
      );
    }

    var col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
      ],
    );
    return col;
  }

  Widget _userAvater(String userId, NotificationState state, ValueChanged<String> name) {
    return FutureBuilder(
      future: state.getuserDetail(userId),
      //  initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          name(snapshot.data.displayName);
          return Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child:  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: RippleButton(
                        child: customImage(
                          context, snapshot.data.profilePic,
                          height: 28,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    )
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _userList(context, model.likeList),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _likeCommentsIcons(context, model);
  }
}

class PostIconsRow2 extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  final bool isPostDetail;
  final PostType type;

  const PostIconsRow2(
      {Key key,
        this.model,
        this.iconColor,
        this.iconEnableColor,
        this.size,
        this.isPostDetail = false,
        this.type})
      : super(key: key);

  Widget _userList(BuildContext context, List<String> list) {
    // List<String> names = [];
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    var state = Provider.of<NotificationState>(context, listen: false);
    if (list != null && list.length > 3) {
      list = list.take(3).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, state, (name) {
        // names.add(name);
      });
    }).toList();
    if (noOfUser > 3) {
      avaterList.add(
        Container(
            height: 40,
            width: 88,
            padding: EdgeInsets.only(top: 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color(0xfff1f3f4),
              shape: BoxShape.rectangle,
            ),
            alignment: Alignment.center,
            child: TitleText(
                " +${noOfUser - 3}",
                color: Color(0xffff5a2a),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis
            )
        ),
      );
    }

    var col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
      ],
    );
    return col;
  }

  Widget _userAvater(String userId, NotificationState state, ValueChanged<String> name) {
    return FutureBuilder(
      future: state.getuserDetail(userId),
      //  initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          name(snapshot.data.displayName);
          return Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child:  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: RippleButton(
                        child: customImage(
                          context, snapshot.data.profilePic,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _userList(context, model.likeList),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            _likeCommentsIcons(context, model)
          ],
        ));
  }
}
