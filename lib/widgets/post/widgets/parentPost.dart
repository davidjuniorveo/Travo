import 'package:flutter/material.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/post/post.dart';
import 'package:streambox/widgets/post/widgets/unavailablePost.dart';
import 'package:provider/provider.dart';


class ParentPostWidget extends StatelessWidget {
  ParentPostWidget(
      {Key key, this.childRepostkey, this.type, this.isImageAvailable, this.trailing})
      : super(key: key);

  final String childRepostkey;
  final PostType type;
  final Widget trailing;
  final bool isImageAvailable;

  void onPostPressed(BuildContext context, FeedModel model) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
        future: feedstate.fetchPost(childRepostkey),
        builder: (context, AsyncSnapshot<FeedModel> snapshot) {
          if (snapshot.hasData) {
            return Post(
              model: snapshot.data,
              type: PostType.ParentPost,
              trailing:trailing
            );
          }
          if ((snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.waiting) &&
              !snapshot.hasData) {
            return UnavailablePost(
              snapshot: snapshot,
              type: type,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      );
  }
}