import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/post/post.dart';
import 'package:streambox/widgets/post/widgets/postBottomSheet.dart';
import 'package:provider/provider.dart';


class FeedPostDetail extends StatefulWidget {
  FeedPostDetail({Key key, this.postId}) : super(key: key);
  final String postId;

  _FeedPostDetailState createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  String postId;

  @override
  void initState() {
    postId = widget.postId;
    // var state = Provider.of<FeedState>(context, listen: false);
    // state.getpostDetailFromDatabase(postId);
    super.initState();
  }


  Widget _postDetail(FeedModel model) {
    return Post1(
      model: model,
      type: PostType.Detail,
      trailing: PostBottomSheet().postOptionIcon(
          context, model, PostType.Detail
      ),
    );
  }

  void addLikeToComment(String commentId) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToPost(state.postDetailModel.last, authState.userId);
  }

  void openImage() async {
    Navigator.pushNamed(context, '/ImageViewPge');
  }

  void deletePost(PostType type, String postId, {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deletePost(postId, type, parentkey: parentkey);
    Navigator.of(context).pop();
    if (type == PostType.Detail) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<FeedState>(context, listen: false).removeLastPostDetail(postId);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xffff5a2a),
                    )
                  )
              ),
              elevation: 0,
              pinned: true,
              centerTitle: true,
              title: customTitleText('Travel\tdetails'),
            ),
            Consumer<FeedState>(
              builder: (context, state, child) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      state.postDetailModel == null ||
                          state.postDetailModel.length == 0
                          ? Container()
                          : _postDetail(state.postDetailModel?.last),

                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
