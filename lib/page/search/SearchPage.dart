import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/searchState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });
    super.initState();
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/TrendsPage');
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    final list = state.userlist;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.5,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xfff75336)),
          title: Container(
            height: 45,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(28),
            ),
            child:  TextField(
              onChanged: (text) {
                state.filterByUsername(text);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(28.0),
                    ),
                  ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                hintText: "Search here",
                hintStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          centerTitle: true,
        ),
      body: Consumer<SearchState>(
        builder: (context, state, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  addAutomaticKeepAlives: false,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _UserTile(user: list[index]),
                  separatorBuilder: (_, index) => Divider(
                    height: 0,
                  ),
                  itemCount: list?.length ?? 0,
                ),
              )
            ],
          );
        },
      )
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return RippleButton(
      onPressed: () {
        kAnalytics.logViewSearchResults(searchTerm: user.userName);
        Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
      },
      child: Container(
        color: StreamboxColor.white,
        child: ListTile(
          leading: customImage(context, user.profilePic, height: 60),
          title: Row(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) * .5),
                child: TitleText(
                    user.displayName,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis
                ),
              ),
              SizedBox(width: 3),
              user.isVerified
                  ? customIcon(context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: Color(0xfff75336),
                  size: 17,
                  paddingIcon: 3)
                  :
               customIcon(context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: Color(0xfff75336),
                  size: 17,
                  paddingIcon: 3
               ),
            ],
          ),
          subtitle: TitleText(
            user.bio,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 14,
             overflow: TextOverflow.ellipsis,
           ),
            trailing: IconButton(
              icon: Icon(
                Ionicons.person_outline,
                color: Colors.black54,
                size: 24,
              ),
                onPressed: () {
                  kAnalytics.logViewSearchResults(searchTerm: user.userName);
                  Navigator.of(context).pushNamed('/userprofilePage/' + user?.userId);
                }
            )
        ),
      ),
    );
  }
}
