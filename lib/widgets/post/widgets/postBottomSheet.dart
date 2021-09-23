import 'package:flutter/material.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:provider/provider.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';


class PostBottomSheet {

  Widget postOptionIcon(BuildContext context, FeedModel model, PostType type) {
    return customInkWell(
        radius: BorderRadius.circular(20),
        context: context,
        onPressed: () {
          _openbottomSheet(context, type, model);
        },
        child: Container(
          width: 100,
          height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.transparent,
              ),
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(24)
              ),
            ),
          child: FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: Colors.white70,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: TitleText(
                  '\tMore\t',
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis
              )
          )
        )
    );
  }

  void _openbottomSheet(BuildContext context, PostType type, FeedModel model) async {
    var authState = Provider.of<AuthState>(context, listen: false);
    bool isMyPost = authState.userId == model.userId;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) *
                (type == PostType.Post
                    ? (isMyPost ? .25 : .44)
                    : (isMyPost ? .38 : .52)),
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == PostType.Post
                ? _postOptions(context, isMyPost, model, type)
                : _postDetailOptions(context, isMyPost, model, type));
      },
    );
  }

  Widget _postDetailOptions(BuildContext context, bool isMyPost, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        isMyPost
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Post',
                onPressed: () {
                  _deletePost(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            :  _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Action performed by owner',
          onPressed: () {
            _deletePost(
              context,
              type,
              model.key,
              parentkey: model.parentkey,
            );
          },
          isEnable: true,
        ),
      ],
    );
  }

  Widget _postOptions(
      BuildContext context, bool isMyPost, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        isMyPost
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Post',
                onPressed: () {
                  _deletePost(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            :
        _widgetBottomSheetRow(
          context,
          AppIcon.delete,
          text: 'Action performed by owner',
          isEnable: true,
        ),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, int icon,
      {String text, Function onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null)
            onPressed();
          else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
              SizedBox(
                width: 15,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePost(BuildContext context, PostType type, String postId,
      {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deletePost(postId, type, parentkey: parentkey);
    // CLose bottom sheet
    Navigator.of(context).pop();
    if (type == PostType.Detail) {
      // Close Post detail page
      Navigator.of(context).pop();
      // Remove last post from post detail stack page
      state.removeLastPostDetail(postId);
    }
  }

  void openRepostbottomSheet(
      BuildContext context, PostType type, FeedModel model) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _repost(context, model, type));
      },
    );
  }

  Widget _repost(BuildContext context, FeedModel model, PostType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
