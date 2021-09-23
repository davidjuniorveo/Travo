import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/customLoader.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:streambox/widgets/post/post.dart';
import 'package:streambox/widgets/post/widgets/postBottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key key, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          color: Color(0xffffffff),
          child: RefreshIndicator(
            key: widget.refreshIndicatorKey,
            onRefresh: () async {
              /// refresh home page feed
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getDataFromDatabase();
              return Future.value(true);
            },
            child: Stack(
              children: [
                _FeedPageBody(
                  refreshIndicatorKey: widget.refreshIndicatorKey,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}


class _FeedPageBody extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const _FeedPageBody({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  __FeedPageBodyState createState() => __FeedPageBodyState();
}

class __FeedPageBodyState extends State<_FeedPageBody> {

  String _selected = '';
  List<String> _items = ['Silver', 'Platinum', 'Gold'];

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen: false);

    DateTime now = DateTime.now();
    var timeNow = int.parse(DateFormat('kk').format(now));

    var message = '';

    if (timeNow < 12) {
      message = 'Good Morning🤩';
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      message = 'Good Afternoon😜';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      message = 'Good Evening😉';
    } else {
      message = 'Good Night😴';
    }

    return Consumer<FeedState>(
      builder: (context, state, child) {
        final List<FeedModel> list = state.getPostList(authstate.userModel);
        return CustomScrollView(
          slivers: <Widget>[
            child,
            state.isBusy && list == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: fullHeight(context) - 135,
                      child: CustomScreenLoader(
                        height: double.infinity,
                        width: fullWidth(context),
                        backgroundColor: Color(0xffffffff),
                      ),
                    ),
                  )
                : !state.isBusy && list == null
                    ?
            SliverToBoxAdapter(
                child: Container(
                    height: fullHeight(context),
                    width: fullWidth(context),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                      'Travel\twallet',
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
                                Flexible(
                                    child: RippleButton(
                                      splashColor: StreamboxColor.dodgetBlue_50.withAlpha(100),
                                      borderRadius: BorderRadius.all(Radius.circular(28)),
                                      child: Container(
                                          height: 35,
                                          width: 140,
                                          margin: EdgeInsets.symmetric(horizontal: 0),
                                          decoration: BoxDecoration(
                                            color:  Color(0xfff75336),
                                            borderRadius: BorderRadius.circular(28),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  'Choose class',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xffffffff),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 20,
                                                color: Color(0xffffffff),
                                              ),
                                            ],
                                          )
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                      'UGX --',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xfff75336),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    child: RippleButton(
                                      splashColor: StreamboxColor.dodgetBlue_50.withAlpha(100),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      child: Container(
                                        height: 40,
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(horizontal: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Top\tUp\tCredit',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 4,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            decoration: BoxDecoration(
                              color:  Colors.grey[50],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => topUpcreditdetails(context),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                        'Details',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
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
                            ),
                          ),
                          Container(
                            height: 4,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            decoration: BoxDecoration(
                              color:  Colors.grey[50],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 15, 15, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Recommended For You',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 25, 5, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xfff75336)),
                                        strokeWidth: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                    )
                )
            )
                    :
            SliverToBoxAdapter(
                child: Container(
                  height: fullHeight(context),
                  width: fullWidth(context),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    shape: BoxShape.rectangle,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                    'Travel\twallet',
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
                              Flexible(
                                  child: RippleButton(
                                    onPressed: () => chooseclasses(context),
                                    splashColor: StreamboxColor.dodgetBlue_50.withAlpha(100),
                                    borderRadius: BorderRadius.all(Radius.circular(28)),
                                    child: Container(
                                        height: 35,
                                        width: 140,
                                        margin: EdgeInsets.symmetric(horizontal: 0),
                                        decoration: BoxDecoration(
                                          color:  Color(0xfff75336),
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            _selected.isEmpty
                                            ? Text(
                                                'Choose class',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis
                                            )
                                            : Text(
                                                _selected,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: Color(0xffffffff),
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                    'UGX 0',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xfff75336),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                  child: RippleButton(
                                    splashColor: StreamboxColor.dodgetBlue_50.withAlpha(100),
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/TopUpCredit');
                                    },
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Top\tUp\tCredit',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 4,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                            color:  Colors.grey[50],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => topUpcreditdetails(context),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 15, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                      'Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
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
                          ),
                        ),
                        Container(
                          height: 4,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                            color:  Colors.grey[50],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 15, 15, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Recommended For You',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: list.map((model) {
                                  return Post(
                                    model: model,
                                    trailing: PostBottomSheet().postOptionIcon(
                                      context,
                                      model,
                                      PostType.Post,
                                    ),
                                  );
                                }).toList()
                            ),
                          ),
                        ),
                      ]
                  )
                )
            )
          ],
        );
      },
      child: SliverAppBar(
        floating: false,
        pinned: true,
        elevation: 0.5,
        leading: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          onPressed: () => showEmergency(context),
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: Color(0xfff75336),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ]
              )
          ),
        ),
        title: Padding(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/Onboarding');
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  width: 132,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Onboarding');
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.only(top: 0),
                              decoration: new BoxDecoration(
                                border: Border.all(
                                  color: Color(0xfff75336),
                                  width: 1.5,
                                ),
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: customNetworkImage1(
                                'https://allnaijatrends.com/wp-content/uploads/2019/06/omoni-oboli-ufuoma-mcdermott-chioma-akpotha-bikini-1024x1024.jpg',
                                fit: BoxFit.fill,
                              ),
                            )
                        ),
                        Text(
                          '\tOpen\tStory',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ]
                  )
              ),
            )
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 5),
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
                            EvaIcons.plus,
                            color: Color(0xfff75336)
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/CreateFeedPage/post');
                          },
                        )
                      ]
                  )
              )
          ),
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
                            Ionicons.search,
                            color: Color(0xfff75336),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/SearchPage/');
                          },
                        )
                      ]
                  )
              )
          ),
        ],
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          child: Container(
              height: 10.0,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.black26,
                        width: 0.28
                    )
                ),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  ]
              )
          ),
          preferredSize: Size.fromHeight(10.0),
        ),
      )
    );
  }


  Widget _floatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Icon(
                          Icons.car_repair,
                          color: Colors.black54,
                          size: 26,
                        )
                    ),
                  ]
              )
          ),
        ),
        GestureDetector(
          onTap: () {
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Icon(
                          Icons.healing,
                          color: Colors.black54,
                          size: 26,
                        )
                    ),
                  ]
              )
          ),
        ),
        GestureDetector(
          onTap: () {
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Icon(
                          Icons.pregnant_woman,
                          color: Colors.black54,
                          size: 26,
                        )
                    ),
                  ]
              )
          ),
        )
      ],
    );
  }

  showEmergency(BuildContext context) {
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
                          'What\ttype\tof\temergency\nhave\tyou\tfaced?',
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
                    SizedBox(height: 20),
                    _floatingActionButton(),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                      child: Text(
                          'The\tcall\twill\tstart\twhen\tyou\ttap\n&\twill\tincur\tcharges',
                          style: GoogleFonts.muli(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 20),
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
                          color: Color(0xfff75336),
                          onPressed: () => launch("tel://+256\t778756743"),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                                    child: Text(
                                      'Emergency SOS',
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

  topUpcreditdetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72, // half screen on load
          maxChildSize: 1, // full screen on scroll
          minChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
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
                          'Hey👋, travel Buddy',
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
                    SizedBox(height: 20),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: Colors.black54,
                                    size: 26,
                                  )
                              ),
                            ]
                        )
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                      child: Text(
                          'You\tcan\ttop\tup\tany\namount\ton\tyour\ttravel\twallet',
                          style: GoogleFonts.muli(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                      child: Text(
                          'Reminder',
                          style: GoogleFonts.muli(
                            fontSize: 14,
                            color: Color(0xfff75336),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                      child: Text(
                          'The\tmore\tyou\tsave,\tthe\nmore\tlikely\tyou\tare\tto\nwin an All-Paid trip',
                          style: GoogleFonts.muli(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 10),
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

  chooseclasses(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3, // half screen on load
          maxChildSize: 1, // full screen on scroll
          minChildSize: 0.2,
          builder: (BuildContext context, ScrollController scrollController) {
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
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: _items.length,
                itemBuilder: (context, index) =>
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selected = _items[index];
                          });
                          Navigator.of(context).pop();
//                          showDialog(
//                            context: context,
//                            builder: (context) => new SimpleDialog(
//                              backgroundColor: Theme.of(context).backgroundColor,
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(10.0)
//                              ),
//                              title: new Text('Thanks for choosing\n🎉\t$_selected\tclass\t🎊',
//                                  style: TextStyle(
//                                    fontSize: 16,
//                                    color: Color(0xfff75336),
//                                    fontWeight: FontWeight.w600,
//                                  ),
//                                  textAlign: TextAlign.center,
//                                  maxLines: 2,
//                                  overflow: TextOverflow.ellipsis
//                              ),
//                              children: <Widget>[
//                                Divider(),
//                                Row(
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                  children: <Widget>[
//                                    SimpleDialogOption(
//                                      onPressed: () => Navigator.of(context).pop(true),
//                                      child: Text('ok'),
//                                    ),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          );
                        },
                        child: Text(
                            _items[index],
                            style: GoogleFonts.muli(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis
                        ),
                      )
                    ),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
              },
              ),
            );
          },
        );
      },
    );
  }
}
