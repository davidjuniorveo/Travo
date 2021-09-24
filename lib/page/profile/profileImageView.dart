import 'package:flutter/material.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var authstate = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      backgroundColor: StreamboxColor.white,
      appBar: AppBar(),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: fullWidth(context),
          // height: fullWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: customAdvanceNetworkImage(
                  authstate.profileUserModel.profilePic),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
