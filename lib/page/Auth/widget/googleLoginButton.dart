import 'package:flutter/material.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/widgets/newWidget/customLoader.dart';
import 'package:streambox/widgets/newWidget/rippleButton.dart';
import 'package:provider/provider.dart';


class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key key, @required this.loader, this.loginCallback});
  final CustomLoader loader;
  final Function loginCallback;
  void _googleLogin(context) {
    var state = Provider.of<AuthState>(context, listen: false);
    loader.showLoader(context);
    state.handleGoogleSignIn().then((status) {
      // print(status)
      if (state.user != null) {
        loader.hideLoader();
        Navigator.pop(context);
        loginCallback();
      } else {
        loader.hideLoader();
        cprint('Unable to login', errorIn: '_googleLoginButton');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RippleButton(
      onPressed: (){
        _googleLogin(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Wrap(
          children: <Widget>[
            SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(
                letterSpacing: 0.5,
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'HelveticaNeue',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
