import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/chatModel.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/chats/chatUserState.dart';
import 'package:streambox/state/searchState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {

  const ChatListPage({Key key}) : super(key: key);

  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  
  @override
  void initState() {
    final chatState = Provider.of<ChatUserState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.setIsChatScreenOpen = true;

    // chatState.databaseInit(state.profileUserModel.userId,state.userId);
    chatState.getUserchatList(state.user.uid);
    super.initState();
  }

  Widget _body() {
    final state = Provider.of<ChatUserState>(context);
    final searchState = Provider.of<SearchState>(context, listen: false);
    if (state.chatUserList == null) {
      return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(2.5),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: StreamboxColor.mystic,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(25.0),
                    child: Lottie.asset(
                      'assets/images/happy.json',
                      repeat: true,
                      reverse: true,
                      animate: true,
                    )
                ),
                SizedBox(height: 10.0),
                Text(
                    'You can now send direct\nmessages to fellow travellers',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      );
    } else {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: state.chatUserList.length,
        itemBuilder: (context, index) => _userCard(
            searchState.userlist.firstWhere(
              (x) => x.userId == state.chatUserList[index].key,
              orElse: () => UserModel(userName: "Unknown"),
            ),
            state.chatUserList[index]),
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
      );
    }
  }

  Widget _userCard(UserModel model, ChatMessage lastMessage) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        onTap: () {
          final chatState = Provider.of<ChatUserState>(context, listen: false);
          final searchState = Provider.of<SearchState>(context, listen: false);
          chatState.setChatUser = model;
          if (searchState.userlist.any((x) => x.userId == model.userId)) {
            chatState.setChatUser = searchState.userlist
                .where((x) => x.userId == model.userId)
                .first;
          }
          Navigator.pushNamed(context, '/ChatScreenPage');
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/ProfilePage/${model.userId}');
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    model.profilePic ?? dummyimage,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: Row(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) * .5),
              child: TitleText(
                model.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(width: 3),
            customIcon(context,
                icon: AppIcon.blueTick,
                istwitterIcon: true,
                iconColor: Color(0xffff5a2a),
                size: 17,
                paddingIcon: 3
            ),
            Spacer(),
            lastMessage == null
                ? SizedBox.shrink()
                : TitleText(
                   '${getChatTime(lastMessage.createdAt).toString()}',
                    fontSize: 12,
                    color: Color(0xffff5a2a),
                    fontWeight: FontWeight.w700,
                  ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 4),
            Text(
              trimMessage(lastMessage.message) ?? 'Start messaging',
              maxLines: 1,
              style: GoogleFonts.muli(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/DirectMessagesPage');
  }

  String trimMessage(String message) {
    if (message != null && message.isNotEmpty) {
      if (message.length > 70) {
        message = message.substring(0, 70) + '...';
        return message;
      } else {
        return message;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xffff5a2a)),
        title: customTitleText('Direct Messages'),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15),
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
                            Ionicons.paper_plane_outline,
                            color: Color(0xffff5a2a),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/NewMessagePage');
                          },
                        )
                      ]
                  )
              )
          ),
        ],
      ),
      body: _body(),
    );
  }
}

//
//class CustomSliverAppbar extends StatefulWidget {
//  final profileId;
//
//  CustomSliverAppbar({this.profileId});
//
//  @override
//  _CustomSliverAppbarState createState() => _CustomSliverAppbarState();
//}
//
//class _CustomSliverAppbarState extends State<CustomSliverAppbar> with SingleTickerProviderStateMixin {
//
//  ScrollController controller = ScrollController();
//
//  TabController _tabController;
//
//  @override
//  void initState() {
//    _tabController = TabController(
//      initialIndex: 0,
//      length: 2,
//      vsync: this,
//    );
//    super.initState();
//  }
//
//  void onSettingIconPressed() {
//    Navigator.pushNamed(context, '/DirectMessagesPage');
//  }
//
//  Widget _getUserAvatar(BuildContext context) {
//    var authState = Provider.of<AuthState>(context);
//    return Padding(
//      padding: EdgeInsets.all(7),
//      child: customInkWell(
//        context: context,
////        onPressed: () => showProfile(context),
//        child: customImage(context, authState.userModel?.profilePic, height: 30),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        leading: Padding(
//          padding: EdgeInsets.only(left: 0),
//          child: IconButton(
//            icon: Icon(
//              Ionicons.menu,
//              color: Colors.blue,
//              size: 27,
//            ),
//            onPressed: () => showSignout(context),
//          ),
//
//        ),
//        centerTitle: true,
//        title: customTitleText(
//          'Inbox',
//        ),
//      ),
//      body: NestedScrollView(
//        floatHeaderSlivers: true,
//        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//          return <Widget>[
//            SliverAppBar(
//              leading: _getUserAvatar(context),
//              centerTitle: true,
//              pinned: true,
//              floating: true,
//              elevation: 0.0,
//              expandedHeight: 15.0,
//              bottom: PreferredSize(
//                child: Container(
//                  width: double.infinity,
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      border: Border(
//                        bottom: BorderSide(
//                            color: Colors.black12,
//                            width: 0.4
//                        ),
//                      )
//                  ),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      new TabBar(
//                        isScrollable: false,
//                        indicatorWeight: 4,
////                        indicator: BubbleTabIndicator(
////                          indicatorHeight: 40.0,
////                          indicatorColor: StreamboxColor.mystic,
////                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
////                          // Other flags
////                          // indicatorRadius: 1,
////                          // insets: EdgeInsets.all(1),
////                          // padding: EdgeInsets.all(10)
////                        ),
//                        unselectedLabelColor: AppColor.lightGrey,
//                        indicatorSize: TabBarIndicatorSize.tab,
//                        labelPadding: EdgeInsets.only(top: 0),
//                        controller: _tabController,
//                        labelColor: Colors.black,
//                        tabs: [
//                          Tab(
//                            child: Center(
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Text(
//                                      'Direct Messages',
//                                      style: GoogleFonts.muli(
//                                        fontSize: 16,
//                                        fontWeight: FontWeight.w600,
//                                      )
//                                  ),
//                                  SizedBox(width: 5),
//                                  Icon(
//                                    Icons.brightness_1,
//                                    color: Colors.white,
//                                    size: 10,
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                          Tab(
//                            child: Center(
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Text(
//                                      'Notifications',
//                                      style: GoogleFonts.muli(
//                                        fontSize: 16,
//                                        fontWeight: FontWeight.w600,
//                                      )
//                                  ),
//                                  SizedBox(width: 5),
//                                  Icon(
//                                    Icons.brightness_1,
//                                    color: Colors.white,
//                                    size: 10,
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//                preferredSize: Size.fromHeight(55.0),
//              ),
//              actions: [
//              ],
//            ),
//          ];
//        },
//        body: TabBarView(
//          controller: _tabController,
//          children: [
//            ChatListPage(),
//            NotificationPage()
//          ],
//        ),
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    _tabController.dispose();
//    super.dispose();
//  }
//
//
//  showSignout(BuildContext context) {
//    showModalBottomSheet(
//      backgroundColor: Colors.transparent,
//      context: context,
//      isScrollControlled: true,
//      builder: (BuildContext context) {
//        return DraggableScrollableSheet(
//          initialChildSize: 0.72, // half screen on load
//          maxChildSize: 1, // full screen on scroll
//          minChildSize: 0.5,
//          builder: (BuildContext context,
//              ScrollController scrollController) {
//            return Container(
//              padding: EdgeInsets.only(top: 10, bottom: 2, left: 5, right: 5),
//              margin: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
//              decoration: BoxDecoration(
//                color: Theme.of(context).bottomSheetTheme.backgroundColor,
//                borderRadius: BorderRadius.only(
//                  topLeft: const Radius.circular(20),
//                  topRight: const Radius.circular(20),
//                  bottomLeft: const Radius.circular(20),
//                  bottomRight: const Radius.circular(20),
//                ),
//              ),
//              child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Container(
//                      width: 40,
//                      height: 5,
//                      decoration: BoxDecoration(
//                        color: Colors.grey[400],
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(10),
//                        ),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
//                      child: Text(
//                          'Are you sure \nyou want to\nSign Out?',
//                          style: GoogleFonts.muli(
//                            fontSize: 17,
//                            color: Colors.black,
//                            fontWeight: FontWeight.w600,
//                          ),
//                          textAlign: TextAlign.center,
//                          maxLines: 4,
//                          overflow: TextOverflow.ellipsis
//                      ),
//                    ),
//                    SizedBox(height: 20),
//                    Container(
//                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                      height: 50,
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                        color: Colors.blue,
//                        borderRadius: BorderRadius.all(Radius.circular(28)),
//                      ),
//                      child: FlatButton(
//                        onPressed: _logOut,
//                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//                        color: Colors.blue,
//                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                        child: Text(
//                          'Sign Out',
//                          style: TextStyle(
//                            letterSpacing: 0.5,
//                            color: Colors.white,
//                            fontSize: 16,
//                            fontFamily: 'HelveticaNeue',
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 20),
//                    Container(
//                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
//                      height: 50,
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                        color: Color(0xfff1f3f4),
//                        borderRadius: BorderRadius.all(Radius.circular(28)),
//                      ),
//                      child: FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//                        color: Color(0xfff1f3f4),
//                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                        child: Text(
//                          'Cancel',
//                          style: TextStyle(
//                            letterSpacing: 0.5,
//                            color: Colors.black54,
//                            fontSize: 16,
//                            fontFamily: 'HelveticaNeue',
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ]
//              ),
//            );
//          },
//        );
//      },
//    );
//  }
//
//  void _logOut() {
//    final state = Provider.of<AuthState>(context,listen: false);
//    final notificationDtate = Provider.of<NotificationState>(context,listen: false);
//    notificationDtate.unsubscribeNotifications(state.userModel?.userId);
//    Navigator.pop(context);
//    state.logoutCallback();
//  }
//
//}
