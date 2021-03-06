import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/enum.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:streambox/model/chatModel.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/appState.dart';

import '../../helper/utility.dart';

class ChatState extends AppState {

  List<ChatMessage> _messageList;
  UserModel _chatUser;
  String serverToken = "<FCM SERVER KEY>";

  StreamSubscription<QuerySnapshot> _messageSubscription;
  static final CollectionReference _messageCollection = kfirestore.collection(MESSAGES_COLLECTION);

  static final CollectionReference _userCollection = kfirestore.collection(USERS_COLLECTION);

  UserModel get chatUser => _chatUser;

  set setChatUser(UserModel model) {
    _chatUser = model;
  }

  String _channelName;

  List<ChatMessage> get messageList {
    if (_messageList == null) {
      return null;
    } else {
      _messageList.sort((x, y) => DateTime.parse(x.createdAt)
          .toLocal()
          .compareTo(DateTime.parse(y.createdAt).toLocal()));
      _messageList.reversed;
      _messageList = _messageList.reversed.toList();
      return List.from(_messageList);
    }
  }

  void databaseInit(String userId, String myId) async {
    _messageList = null;

    getChannelName(userId, myId);

    _messageSubscription = _messageCollection
        .doc(_channelName)
        .collection(MESSAGES_COLLECTION)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docChanges.isEmpty) {
        return;
      }
      if (snapshot.docChanges.first.type == DocumentChangeType.added) {
        _onMessageAdded(snapshot.docChanges.first.doc);
      } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
        // _onNotificationRemoved(snapshot.docChanges.first.doc);
      } else if (snapshot.docChanges.first.type ==
          DocumentChangeType.modified) {
        _onMessageChanged(snapshot.docChanges.first.doc);
      }
    });
  }

  void getFCMServerKey() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    var data = remoteConfig.getString('FcmServerKey');
    if (data != null && data.isNotEmpty) {
      serverToken = jsonDecode(data)["key"];
    } else {
      cprint("Please configure Remote config in firebase",
          errorIn: "getFCMServerKey");
    }
  }

  void getchatDetailAsync() async {
    try {
      // _messageList.clear();
      if (_messageList == null) {
        _messageList = [];
      }
      _messageCollection
          .doc(_channelName)
          .collection(MESSAGES_COLLECTION)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          for (var i = 0; i < querySnapshot.docs.length; i++) {
            final model = ChatMessage.fromJson(querySnapshot.docs[i].data());
            model.key = querySnapshot.docs[i].id;
            _messageList.add(model);
          }
          // _userlist.addAll(_userFilterlist);
          // _userFilterlist.sort((x, y) => y.followers.compareTo(x.followers));
          notifyListeners();
        } else {
          _messageList = null;
        }
      });
      // kDatabase
      //     .child('chats')
      //     .child(_channelName)
      //     .once()
      //     .then((DataSnapshot snapshot) {
      //   _messageList = List<ChatMessage>();
      //   if (snapshot.value != null) {
      //     var map = snapshot.value;
      //     if (map != null) {
      //       map.forEach((key, value) {
      //         var model = ChatMessage.fromJson(value);
      //         model.key = key;
      //         _messageList.add(model);
      //       });
      //     }
      //   } else {
      //     _messageList = null;
      //   }
      // });
    } catch (error) {
      cprint(error);
    }
  }

  void onMessageSubmitted(ChatMessage message,
      {UserModel myUser, UserModel secondUser}) {
    print(chatUser.userId);
    try {
      if (message.message != null &&
          message.message.length > 0 &&
          message.message.length < 400) {
        _userCollection
            .doc(message.senderId)
            .collection(CHAT_USER_LIST_COLLECTION)
            .doc(message.receiverId)
            .set({"lastMessage": message.toJson()});
        _userCollection
            .doc(message.receiverId)
            .collection(CHAT_USER_LIST_COLLECTION)
            .doc(message.senderId)
            .set({"lastMessage": message.toJson()});

        kfirestore
            .collection(MESSAGES_COLLECTION)
            .doc(_channelName)
            .collection(MESSAGES_COLLECTION)
            .doc()
            .set(message.toJson());
        // sendAndRetrieveMessage(message);
        logEvent('send_message');
      }
    } catch (error) {
      cprint(error);
    }
  }

  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    // cprint(_channelName); //2RhfE-5kyFB
    return _channelName;
  }

  void _onMessageAdded(DocumentSnapshot snapshot) {
    if (_messageList == null) {
      _messageList = List<ChatMessage>();
    }
    if (snapshot.data() != null) {
      var map = snapshot.data();
      if (map != null) {
        var model = ChatMessage.fromJson(map);
        model.key = snapshot.id;
        if (_messageList.length > 0 &&
            _messageList.any((x) => x.key == model.key)) {
          return;
        }
        _messageList.add(model);
      }
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void _onMessageChanged(DocumentSnapshot snapshot) {
    if (_messageList == null) {
      _messageList = List<ChatMessage>();
    }
    if (snapshot.data() != null) {
      var map = snapshot.data();
      if (map != null) {
        var model = ChatMessage.fromJson(map);
        model.key = snapshot.id;
        if (_messageList.length > 0 &&
            _messageList.any((x) => x.key == model.key)) {
          return;
        }
        _messageList.add(model);
      }
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void onChatScreenClosed() {
    if (_messageSubscription != null) {
      _messageSubscription.cancel();
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  void sendAndRetrieveMessage(ChatMessage model) async {
    /// on noti
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    if (chatUser.fcmToken == null) {
      return;
    }

    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': model.message,
        'title': "Message from ${model.senderName}"
      },
      'priority': 'high',
      'data()': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Message.toString(),
        "senderId": model.senderId,
        "receiverId": model.receiverId,
        "title": "title",
        "body": model.message,
        "postId": ""
      },
      'to': chatUser.fcmToken
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: body);
    print(response.body.toString());
  }
}
