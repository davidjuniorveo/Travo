import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/model/chatModel.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/chats/chatState.dart';
import 'package:streambox/state/chats/chatUserState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';

class ChatScreenPage extends StatefulWidget {
  ChatScreenPage({Key key, this.userProfileId}) : super(key: key);

  final String userProfileId;

  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final messageController = new TextEditingController();
  String senderId;
  String userImage;
  ChatState state;
  ScrollController _controller;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    _scaffoldKey = GlobalKey<ScaffoldState>();
    _controller = ScrollController();
    final chatUserState = Provider.of<ChatUserState>(context, listen: false);
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.setChatUser = chatUserState.chatUser;
    senderId = state.userId;
    chatState.databaseInit(chatState.chatUser.userId, state.userId);
    chatState.getchatDetailAsync();
    super.initState();
  }

  Widget _chatScreenBody() {
    final state = Provider.of<ChatState>(context);
    if (state.messageList == null || state.messageList.length == 0) {
      return Center(
        child: Text(
          'Say Hi👋',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      reverse: true,
      physics: BouncingScrollPhysics(),
      itemCount: state.messageList.length,
      itemBuilder: (context, index) => chatMessage(state.messageList[index]),
    );
  }

  Widget chatMessage(ChatMessage message) {
    if (senderId == null) {
      return Container();
    }
    if (message.senderId == senderId)
      return _message(message, true);
    else
      return _message(message, false);
  }

  Widget _message(ChatMessage chat, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            myMessage
                ? SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: customAdvanceNetworkImage(userImage),
                  ),
            Expanded(
              child: Container(
                alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (fullWidth(context) / 4),
                  top: 20,
                  left: myMessage ? (fullWidth(context) / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage
                            ? Color(0xfff75336)
                            : StreamboxColor.mystic,
                      ),
                      child: UrlText(
                        text: chat.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: myMessage ? StreamboxColor.white : Colors.black,
                        ),
                        urlStyle: TextStyle(
                          fontSize: 15,
                          color: myMessage
                              ? StreamboxColor.white
                              : Color(0xfff75336),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: InkWell(
                        borderRadius: getBorder(myMessage),
                        onLongPress: () {
                          var text = ClipboardData(text: chat.message);
                          Clipboard.setData(text);
                          _scaffoldKey.currentState.hideCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: StreamboxColor.white,
                              content: Text(
                                'Message copied',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Text(
            '${getChatTime(chat.createdAt).toString()}',
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
          ),
        )
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomRight: myMessage ? Radius.circular(20) : Radius.circular(20),
      bottomLeft: myMessage ? Radius.circular(20) : Radius.circular(20),
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                alignLabelWithHint: true,
                hintText: 'Start with a message...',
                suffixIcon: IconButton(icon: Icon(Ionicons.paper_plane, color: Color(0xfff75336), size: 26), onPressed: submitMessage),
                // fillColor: Colors.black12, filled: true
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitMessage() {
    // var state = Provider.of<ChatUserState>(context, listen: false);
    var authstate = Provider.of<AuthState>(context, listen: false);
    ChatMessage message;
    message = ChatMessage(
        message: messageController.text,
        createdAt: DateTime.now().toUtc().toString(),
        senderId: authstate.userModel.userId,
        receiverId: state.chatUser.userId,
        seen: false,
        timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        senderName: authstate.user.displayName);
    if (messageController.text == null || messageController.text.isEmpty) {
      return;
    }
    UserModel myUser = UserModel(
        displayName: authstate.userModel.displayName,
        userId: authstate.userModel.userId,
        userName: authstate.userModel.userName,
        profilePic: authstate.userModel.profilePic);
    UserModel secondUser = UserModel(
      displayName: state.chatUser.displayName,
      userId: state.chatUser.userId,
      userName: state.chatUser.userName,
      profilePic: state.chatUser.profilePic,
    );
    state.onMessageSubmitted(message, myUser: myUser, secondUser: secondUser);
    Future.delayed(Duration(milliseconds: 50)).then((_) {
      messageController.clear();
    });
    try {
      // final state = Provider.of<ChatUserState>(context,listen: false);
      if (state.messageList != null &&
          state.messageList.length > 1 &&
          _controller.offset > 0) {
        _controller.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } catch (e) {
      print("[Error] $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<ChatState>(context, listen: false);
    userImage = state.chatUser.profilePic;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleText(
                state.chatUser.displayName,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Color(0xfff75336)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 70),
                child: _chatScreenBody(),
              ),
            ),
            _bottomEntryField()
          ],
        ),
      ),
    );
  }
}
