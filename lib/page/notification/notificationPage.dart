import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/model/notificationModel.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/notificationState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';


class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);


  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/NotificationPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xffff5a2a)),
        title: customTitleText('Notifications'),
        centerTitle: true,
      ),
      body: NotificationPageBody(),
    );
  }
}

class NotificationPageBody extends StatelessWidget {
  const NotificationPageBody({Key key}) : super(key: key);

  Widget _notificationRow(BuildContext context, NotificationModel model, bool isFirstNotification) {
    var state = Provider.of<NotificationState>(context);
    return FutureBuilder(
      future: state.getPostDetail(model.postKey),
      builder: (BuildContext context, AsyncSnapshot<FeedModel> snapshot) {
        if (snapshot.hasData) {
          return NotificationTile(
            model: snapshot.data,
          );
        } else if (isFirstNotification &&
            (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active)) {
          return SizedBox(
            height: 1,
            child: LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<NotificationState>(context);
    var list = state.notificationList;
    if (list == null || list.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
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
                        'assets/images/ntify.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ),
          ),
        )
      );
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) =>
          _notificationRow(context, list[index], index == 0),
      itemCount: list.length,
    );
  }
}

class NotificationTile extends StatelessWidget {

  final FeedModel model;
  const NotificationTile({Key key, this.model}) : super(key: key);

  Widget _userList(BuildContext context, List<String> list) {
    // List<String> names = [];
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    var state = Provider.of<NotificationState>(context, listen: false);
    if (list != null && list.length > 5) {
      list = list.take(5).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, state, (name) {
        // names.add(name);
      });
    }).toList();
    if (noOfUser > 5) {
      avaterList.add(
        Text(
          " +${noOfUser - 5}",
          style: subtitleStyle.copyWith(fontSize: 16),
        ),
      );
    }

    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 10),
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
        Padding(
          padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
          child: TitleText(
            '$length Liked\tyour\ttravel\tspot' + '\nposted\tat\t' +'${getPostTime2(model.createdAt)}',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis
          ),
        ),
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              child: customImage(context, snapshot.data.profilePic, height: 38),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var description = model.description.length > 150
        ? model.description.substring(0, 150) + '...'
        : model.description;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: StreamboxColor.white,
          child: ListTile(
            title: _userList(context, model.likeList),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 10, top: 2),
              child: TitleText(
                  description,
                  color: Color(0xffff5a2a),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis
              )
            ),
          ),
        ),
        Divider(height: 0, thickness: .6)
      ],
    );
  }
}
