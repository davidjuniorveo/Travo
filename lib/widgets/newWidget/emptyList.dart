import 'package:flutter/material.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import '../customWidgets.dart';


class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context) - 135,
      color: StreamboxColor.mystic,
      child: NotifyText(title: title,subTitle: subTitle,)
    );
  }
}

class NotifyText extends StatelessWidget {
  final String subTitle;
  final String title;
  const NotifyText({Key key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleText(title, fontSize: 16, textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
        ],
      );
  }
}