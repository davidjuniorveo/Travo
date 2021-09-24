import 'package:flutter/material.dart';
import 'package:streambox/helper/customRoute.dart';
import 'package:streambox/page/Auth/forgetPasswordPage.dart';
import 'package:streambox/page/Auth/selectAuthMethod.dart';
import 'package:streambox/page/Auth/signin.dart';
import 'package:streambox/page/Auth/signup.dart';
import 'package:streambox/page/Auth/verifyEmail.dart';
import 'package:streambox/page/common/splash.dart';
import 'package:streambox/page/feed/composePost/composePost.dart';
import 'package:streambox/page/feed/composePost/state/composePostState.dart';
import 'package:streambox/page/feed/feedPostDetail.dart';
import 'package:streambox/page/feed/imageViewPage.dart';
import 'package:streambox/page/message/chatScreenPage.dart';
import 'package:streambox/page/message/newMessagePage.dart';
import 'package:streambox/page/notification/notificationPage.dart';
import 'package:streambox/page/profile/EditProfilePage.dart';
import 'package:streambox/page/profile/profileImageView.dart';
import 'package:streambox/page/profile/profilePage.dart';
import 'package:streambox/page/search/SearchPage.dart';
import 'package:streambox/state/chats/chatState.dart';
import 'package:provider/provider.dart';
import 'package:streambox/widgets/customWidgets.dart';


class Routes{
  static dynamic route(){
      return {
          '/': (BuildContext context) =>   SplashPage(),
      };
  }

  static void sendNavigationEventToFirebase(String path) {
    if(path != null && path.isNotEmpty){
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route onGenerateRoute(RouteSettings settings) {
     final List<String> pathElements = settings.name.split('/');
     if (pathElements[0] != '' || pathElements.length == 1) {
       return null;
     }
     switch (pathElements[1]) {
      case "ComposePostPage":
        bool isRepost = false;
        bool isPost = false;
        if(pathElements.length == 3 && pathElements[2].contains('repost')){
          isRepost = true;
        }
        else if(pathElements.length == 3 && pathElements[2].contains('post')){
          isPost = true;
        }
        return CustomRoute<bool>(builder:(BuildContext context)=> ChangeNotifierProvider<ComposePostState>(
          create: (_) => ComposePostState(),
          child: ComposePostPage(isRepost:isRepost, isPost: isPost),
        ));
      case "FeedPostDetail":
        var postId = pathElements[2];
          return SlideLeftRoute<bool>(builder:(BuildContext context)=> FeedPostDetail(postId: postId,),settings: RouteSettings(name:'FeedPostDetail'));
        case "ProfilePage":
         String profileId;
         if(pathElements.length > 2){
             profileId = pathElements[2];
         }
        return CustomRoute<bool>(builder:(BuildContext context)=> ProfilePage(
          profileId: profileId,
        )); 
      case "CreateFeedPage": return CustomRoute<bool>(builder:(BuildContext context)=> ChangeNotifierProvider<ComposePostState>(
          create: (_) => ComposePostState(),
          child: ComposePostPage(isRepost:false, isPost: true),
        ));
       case "ChatScreenPage": return CustomRoute<bool>(builder:(BuildContext context)=> ChangeNotifierProvider<ChatState>(
          create: (_) => ChatState(),
          child: ChatScreenPage(),
        ));
      case "WelcomePage":return CustomRoute<bool>(builder:(BuildContext context)=> WelcomePage()); 
      case "SignIn":return CustomRoute<bool>(builder:(BuildContext context)=> SignIn()); 
      case "SignUp":return CustomRoute<bool>(builder:(BuildContext context)=> Signup()); 
      case "ForgetPasswordPage":return CustomRoute<bool>(builder:(BuildContext context)=> ForgetPasswordPage()); 
      case "SearchPage":return CustomRoute<bool>(builder:(BuildContext context)=> SearchPage()); 
      case "ImageViewPge":return CustomRoute<bool>(builder:(BuildContext context)=> ImageViewPge());
      case "EditProfile":return CustomRoute<bool>(builder:(BuildContext context)=> EditProfilePage()); 
      case "ProfileImageView":return SlideLeftRoute<bool>(builder:(BuildContext context)=> ProfileImageView()); 
      case "NewMessagePage":return CustomRoute<bool>(builder:(BuildContext context)=> NewMessagePage(),);
      case "NotificationPage":return CustomRoute<bool>(builder:(BuildContext context)=> NotificationPage(),);
      case "VerifyEmailPage":return CustomRoute<bool>(builder:(BuildContext context)=> VerifyEmailPage(),); 
      default:return onUnknownRoute(RouteSettings(name: '/Feature'));
     }
  }

   static Route onUnknownRoute(RouteSettings settings){
     return MaterialPageRoute(
          builder: (_) => Scaffold(
                appBar: AppBar(title: customTitleText(settings.name.split('/')[1]),centerTitle: true,),
                body: Center(
                  child: Text('${settings.name.split('/')[1]} Comming soon..'),
                ),
              ),
        );
   }
}