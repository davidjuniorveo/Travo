import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:streambox/page/feed/FeedPage.dart';
import 'package:streambox/page/message/chatListPage.dart';
import 'package:streambox/page/notification/notificationPage.dart';
import 'package:streambox/page/profile/profilePage.dart';
import 'package:streambox/state/appState.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/chats/chatUserState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/state/notificationState.dart';
import 'package:streambox/state/searchState.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initPosts();
      initProfile();
      initSearch();
      initNotificaiton();
      initChat();
    });

    super.initState();
  }

  void initPosts() {
    var state = Provider.of<FeedState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initNotificaiton() {
    var state = Provider.of<NotificationState>(context, listen: false);
    var authstate = Provider.of<AuthState>(context, listen: false);
    state.databaseInit(authstate.userId);
    state.getDataFromDatabase(authstate.userId);
    state.initfirebaseService();
  }

  void initChat() {
    final chatState = Provider.of<ChatUserState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.databaseInit(state.userId, state.userId);
    state.updateFCMToken();
    chatState.getFCMServerKey();
  }

  List<Widget> _items = [
    FeedPage(),
    ChatListPage(),
    NotificationPage(),
    ProfilePage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
          child: IndexedStack(
              index: _selectedIndex,
              children: _items
          )//
      ),
      bottomNavigationBar: _showBottomNav(),
    );
  }

  Widget _showBottomNav()
  {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(AntIcons.home),
          icon: Icon(AntIcons.home_outline),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Ionicons.paper_plane),
          icon: Icon(Ionicons.paper_plane_outline),
          label: 'Direct',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Ionicons.notifications),
          icon: Icon(Ionicons.notifications_outline),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Ionicons.person),
          icon: Icon(Ionicons.person_outline),
          label: 'Me',
        ),
      ],
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      iconSize: 24,
      selectedItemColor: Color(0xffff5a2a),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        color: Color(0xffff5a2a),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedItemColor: Colors.grey[500],
      onTap: _onTap,
    );
  }

  void _onTap(int index)
  {
    _selectedIndex = index;
    setState(() {

    });
  }
}