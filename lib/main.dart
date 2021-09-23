import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/state/searchState.dart';
import 'helper/routes.dart';
import 'state/appState.dart';
import 'package:provider/provider.dart';
import 'state/authState.dart';
import 'state/chats/chatUserState.dart';
import 'state/feedState.dart';
import 'package:google_fonts/google_fonts.dart';
import 'state/notificationState.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffffffff),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xffffffff),
      systemNavigationBarIconBrightness: Brightness.dark
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<ChatUserState>(create: (_) => ChatUserState()),
        ChangeNotifierProvider<NotificationState>(create: (_) => NotificationState()),
      ],
      child: MaterialApp(
        title: 'Travelhub',
        theme: AppTheme.apptheme.copyWith(
          accentColor: Color(0xfff75336),
          primaryColor: Color(0xfff75336),
          iconTheme: IconThemeData(color: Color(0xfff75336)),
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
      ),
    );
  }
}
