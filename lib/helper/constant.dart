import 'package:cloud_firestore/cloud_firestore.dart';

String dummyimage = 'https://yt3.ggpht.com/a/AATXAJxxDMOKtY55Hbyd5FyM1iYTay89h2PNeVwoEXH5xw=s900-c-k-c0xffffffff-no-rj-mo';

String appFont = 'HelveticaNeuea';

List<String> dummyimageList = [
  'https://yt3.ggpht.com/a/AATXAJxxDMOKtY55Hbyd5FyM1iYTay89h2PNeVwoEXH5xw=s900-c-k-c0xffffffff-no-rj-mo',
];

List<String> dummyimageList2 = [
  'https://images.unsplash.com/photo-1546704346-511b59e5b78d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
  'https://images.unsplash.com/photo-1515943492249-2d5d5d944085?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80'
];



class AppIcon{
  static final int fabPost = 0xf029;
  static final int messageEmpty = 0xf187;
  static final int messageFill = 0xf554;
  static final int search = 0xf058;
  static final int searchFill = 0xf558;
  static final int notification = 0xf055;
  static final int notificationFill = 0xf019;
  static final int messageFab = 0xf053;
  static final int home = 0xf053;
  static final int homeFill = 0xF553;
  static final int heartEmpty = 0xf148;
  static final int heartFill = 0xf015;
  static final int settings = 0xf059;
  static final int adTheRate = 0xf064;
  static final int reply = 0xf151;
  static final int repost = 0xf152;
  static final int image = 0xf109;
  static final int camera = 0xf110;
  static final int arrowDown = 0xf196;
  static final int blueTick = 0xf099;

  static final int link = 0xf098;
  static final int unFollow = 0xf097;
  static final int mute = 0xf101;
  static final int viewHidden = 0xf156;
  static final int block = 0xe609;
  static final int report = 0xf038;
  static final int pin = 0xf088;
  static final int delete = 0xf154;

  static final int profile = 0xf056;
  static final int lists = 0xf094;
  static final int bookmark = 0xf155;
  static final int moments = 0xf160;
  static final int twitterAds = 0xf504;
  static final int bulb = 0xf567;
  static final int newMessage = 0xf035;
  
  static final int sadFace = 0xf430;
  static final int bulbOn = 0xf066;
  static final int bulbOff = 0xf567;
  static final int follow = 0xf175;
  static final int thumbpinFill = 0xf003;
  static final int calender = 0xf203;
  static final int locationPin = 0xf031;
  static final int edit = 0xf112;

}

/// Firestore collections
/// 
/// Store `User` Model in db
const String USERS_COLLECTION = "users";

/// Store `FeedModel` Model in db
const String TWEET_COLLECTION = "posts";

/// Store `ChatMessage` Model in db
const String MESSAGES_COLLECTION = "messages";

/// Store `ChatMessage` Model in db
/// `chatUsers` ate stored in `ChatMessage` on purpose
const String CHAT_USER_LIST_COLLECTION = "chatUsers";

/// Store `NotificationModel` Model in db
const String NOTIFICATION_COLLECTION = "notification";

const String FOLLOWER_COLLECTION = "followerList";

const String FOLLOWING_COLLECTION = "followingList";

// // Below collections is not used yet
// const String TWEET_LIKE_COLLECTION = "likeList";

FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference postRef = firestore.collection('posts');