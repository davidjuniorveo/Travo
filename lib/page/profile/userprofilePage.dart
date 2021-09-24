import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/page/profile/widgets/tabPainter.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/chats/chatUserState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/state/notificationState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/customLoader.dart';
import 'package:streambox/widgets/newWidget/customUrlText.dart';
import 'package:streambox/widgets/newWidget/emptyList.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:streambox/widgets/post/post.dart';
import 'package:streambox/widgets/post/widgets/postBottomSheet.dart';
import 'package:provider/provider.dart';


class userprofilePage extends StatefulWidget {
  userprofilePage({Key key, this.profileId}) : super(key: key);

  final String profileId;

  _userprofilePageState createState() => _userprofilePageState();
}

class _userprofilePageState extends State<userprofilePage> with SingleTickerProviderStateMixin {

  bool isMyProfile = false;
  int pageIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authstate = Provider.of<AuthState>(context, listen: false);
      authstate.getProfileUser(userProfileId: widget.profileId);
      isMyProfile =
          widget.profileId == null || widget.profileId == authstate.userId;
    });
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverAppBar getAppbar() {
    var authstate = Provider.of<AuthState>(context);
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 280,
      elevation: 0.5,
      stretch: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: [

      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: authstate.isbusy
            ? Container(
          padding: EdgeInsets.only(top: 5),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 160,
                width: 160,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                        color: Colors.white,
                        width: 5
                    ),
                    shape: BoxShape.circle
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RippleButton(
                      splashColor: Color(0xfff75336),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      onPressed: () {
                      },
                      child: Container(
                        width: 280,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
            : Container(
          padding: EdgeInsets.only(top: 5),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 5
                    ),
                    shape: BoxShape.circle
                ),
                child: RippleButton(
                  child: customImage(
                    context,
                    authstate.profileUserModel.profilePic,
                    height: 160,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  onPressed: () {
                    Navigator.pushNamed(context, "/ProfileImageView");
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    isMyProfile
                        ?
                    RippleButton(
                      splashColor: Color(0xfff75336),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/EditProfile');
                      },
                      child: Container(
                        width: 280,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                        :
                    RippleButton(
                      splashColor: Color(0xfff75336),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onPressed: () {
                        final chatState = Provider.of<ChatUserState>(context, listen: false);
                        chatState.setChatUser = authstate.profileUserModel;
                        Navigator.pushNamed(context, '/ChatScreenPage');
                      },
                      child: Container(
                        width: 280,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xffff5a2a),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Message Us',
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _emptyBox() {
    return SliverToBoxAdapter(child: SizedBox.shrink());
  }

  isFollower() {
    var authstate = Provider.of<AuthState>(context, listen: false);
    if (authstate.profileUserModel.followersList != null &&
        authstate.profileUserModel.followersList.isNotEmpty) {
      return (authstate.profileUserModel.followersList
          .any((x) => x == authstate.userModel.userId));
    } else {
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    final state = Provider.of<AuthState>(context, listen: false);

    /// It will remove last user's profile from profileUserModelList
    state.removeLastUser();
    return true;
  }

  TabController _tabController;

  @override
  build(BuildContext context) {
    var state = Provider.of<FeedState>(context);
    var authstate = Provider.of<AuthState>(context);
    List<FeedModel> list;
    String id = widget.profileId ?? authstate.userId;

    /// Filter user's post among all posts available in home page posts list
    if (state.feedlist != null && state.feedlist.length > 0) {
      list = state.feedlist.where((x) => x.userId == id).toList();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xffff5a2a)),
          title: customTitleText('Profile'),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Color(0xffff5a2a),
                            ),
                            onPressed: () => showExit(context),
                          )
                        ]
                    )
                )
            )
          ],
        ),
        body: NestedScrollView(
          // controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              getAppbar(),
              authstate.isbusy
                  ? _emptyBox()
                  :
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: authstate.isbusy
                      ? UserNameRowWidget1()
                      : UserNameRowWidget(
                    user: authstate.profileUserModel,
                    isMyProfile: isMyProfile,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.white,
                        indicator: TabIndicator(),
                        controller: _tabController,
                        labelStyle: TextStyle(
                          color: Color(0xffff5a2a),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: <Widget>[
                          Text(
                              "Recent Posts",
                              style: TextStyle(
                                color: Color(0xffff5a2a),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              /// Display all independent tweers list
              _postList(context, authstate, list, false, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postList(BuildContext context, AuthState authstate,
      List<FeedModel> postsList, bool isreply, bool isMedia) {
    List<FeedModel> list;

    /// If user hasn't posted yet
    if (postsList == null) {
      // cprint('No Post avalible');
    } else if (isMedia) {
      /// Display all Posts with media file

      list = postsList.where((x) => x.imagePath != null).toList();
    } else if (!isreply) {
      /// Display all independent Posts
      /// No comments Post will display

      list = postsList
          .where((x) => x.parentkey == null || x.childRepostkey != null)
          .toList();
    } else {
      /// Display all reply Posts
      /// No intependent post will display
      list = postsList
          .where((x) => x.parentkey != null && x.childRepostkey == null)
          .toList();
    }

    /// if [authState.isbusy] is true then an loading indicator will be displayed on screen.
    return authstate.isbusy
        ?
    Container(
      height: fullHeight(context) - 180,
      child: CustomScreenLoader(
        height: double.infinity,
        width: fullWidth(context),
        backgroundColor: Colors.white,
      ),
    )

    /// if post list is empty or null then need to show user a message
        : list == null || list.length < 1
        ?
    Container(
      padding: EdgeInsets.only(top: 50, left: 30, right: 30),
      child: NotifyText(
        title: isMyProfile
            ? ''
            : '',
      ),
    )

    /// If posts available then post list will displayed
        :
    ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
        color: Colors.white,
        child: Post2(
          model: list[index],
          isDisplayOnProfile: true,
          trailing: PostBottomSheet().postOptionIcon(
            context,
            list[index],
            PostType.Post,
          ),
        ),
      ),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context,listen: false);
    final notificationDtate = Provider.of<NotificationState>(context,listen: false);
    notificationDtate.unsubscribeNotifications(state.userModel?.userId);
    Navigator.pop(context);
    state.logoutCallback();
  }

  showExit(BuildContext context) {
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
                                'Are\tyou\tsure\tyou\nwant\tto\tsign\tout\n🥺',
                                style: GoogleFonts.muli(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(height: 80),
                        ]
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xff1A1A1A),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(28),
                                ),
                              ),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                color: Color(0xffff5a2a),
                                onPressed: _logOut,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                                          child: Text(
                                            'Sign\tOut',
                                            style: TextStyle(
                                              color: Colors.white,
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
                          SizedBox(height: 5),
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
                    )
                  ]
              ),
            );
          },
        );
      },
    );
  }
}

class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key key,
    @required this.user,
    @required this.isMyProfile,
  }) : super(key: key);

  final bool isMyProfile;
  final UserModel user;

  String getBio(String bio) {
    if (isMyProfile) {
      return bio;
    } else if (bio == "Edit profile to update bio") {
      return "No bio available";
    } else {
      return bio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: user.displayName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              user.isVerified
                  ?
              customIcon(context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: Color(0xffff5a2a),
                  size: 20,
                  paddingIcon: 3)
                  :
              customIcon(context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: Color(0xffff5a2a),
                  size: 20,
                  paddingIcon: 3
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            getBio(user.bio),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis
          ),
        ),
      ],
    );
  }
}

class UserNameRowWidget1 extends StatelessWidget {
  const UserNameRowWidget1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '-',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            '-',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}






