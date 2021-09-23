import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:streambox/helper/constant.dart';
import 'package:streambox/helper/theme.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/page/feed/composePost/state/composePostState.dart';
import 'package:streambox/page/feed/composePost/widget/composeBottomIconWidget.dart';
import 'package:streambox/page/feed/composePost/widget/composePostImage.dart';
import 'package:streambox/page/feed/composePost/widget/widgetView.dart';
import 'package:streambox/state/authState.dart';
import 'package:streambox/state/feedState.dart';
import 'package:streambox/state/searchState.dart';
import 'package:streambox/widgets/customAppBar.dart';
import 'package:streambox/widgets/customWidgets.dart';
import 'package:streambox/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';


class ComposePostPage extends StatefulWidget {
  ComposePostPage({Key key, this.isRepost, this.isPost = true})
      : super(key: key);

  final bool isRepost;
  final bool isPost;
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<ComposePostPage> {
  bool isScrollingDown = false;
  FeedModel model;
  ScrollController scrollcontroller;

  File _image;
  TextEditingController _textEditingController;
  TextEditingController _textEditingController1;
  TextEditingController _textEditingController2;
  TextEditingController _textEditingController3;
  TextEditingController _textEditingController4;
  TextEditingController _textEditingController5;
  TextEditingController _textEditingController6;

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    _textEditingController4.dispose();
    _textEditingController5.dispose();
    _textEditingController6.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var feedState = Provider.of<FeedState>(context, listen: false);
    model = feedState.postToReplyModel;
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    _textEditingController1 = TextEditingController();
    _textEditingController2 = TextEditingController();
    _textEditingController3 = TextEditingController();
    _textEditingController4 = TextEditingController();
    _textEditingController5 = TextEditingController();
    _textEditingController6 = TextEditingController();
    scrollcontroller..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        Provider.of<ComposePostState>(context, listen: false)
            .setIsScrolllingDown = true;
      }
    }
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.forward) {
      Provider.of<ComposePostState>(context, listen: false)
          .setIsScrolllingDown = false;
    }
  }


  void _onCrossIconPressed() {
    setState(() {
      _image = null;
    });
  }

  void _onImageIconSelcted(File file) {
    setState(() {
      _image = file;
    });
  }

  /// Submit post to save in firebase database
  void _submitButton() async {
    FocusManager.instance.primaryFocus.unfocus();
    var state = Provider.of<FeedState>(context, listen: false);
    kScreenloader.showLoader(context);

    FeedModel postModel = createPostModel();

    if (_image != null) {
      await state.uploadFile(_image).then((imagePath) {
        if (imagePath != null) {
          postModel.imagePath = imagePath;

          /// If type of post is new post
          if (widget.isPost) {
            state.createPost(postModel);
          }

          /// If type of post is  repost
          else if (widget.isRepost) {
            state.createRePost(postModel);
          }

          /// If type of post is new comment post
          else {
            state.addcommentToPost(postModel);
          }
        }
      });
    }

    /// If post did not contain image
    else {
      /// If type of post is new post
      if (widget.isPost) {
        state.createPost(postModel);
      }

      /// If type of post is  repost
      else if (widget.isRepost) {
        state.createRePost(postModel);
      }

      /// If type of post is new comment post
      else {
        state.addcommentToPost(postModel);
      }
    }

    /// Checks for username in post description
    /// If foud sends notification to all tagged user
    /// If no user found or not compost post screen is closed and redirect back to home page.
    await Provider.of<ComposePostState>(context, listen: false)
        .sendNotification(
        postModel, Provider.of<SearchState>(context, listen: false))
        .then((_) {
      /// Hide running loader on screen
      kScreenloader.hideLoader();

      /// Navigate back to home page
      Navigator.pop(context);
    });
  }


  FeedModel createPostModel() {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel;
    var profilePic = myUser.profilePic ?? dummyimage;
    var commentedUser = UserModel(
        displayName: myUser.displayName ?? myUser.email.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        isVerified: authState.userModel.isVerified,
        userName: authState.userModel.userName);
    var tags = getHashTags(_textEditingController.text);
    FeedModel reply = FeedModel(

        description: _textEditingController.text,
        price: _textEditingController1.text,
        duration: _textEditingController2.text,
        location: _textEditingController3.text,
        save: _textEditingController4.text,
        seats: _textEditingController5.text,
        details: _textEditingController6.text,

        user: commentedUser,
        createdAt: DateTime.now().toUtc().toString(),
        tags: tags,
        parentkey: widget.isPost
            ? null
            : widget.isRepost
            ? null
            : state.postToReplyModel.key,
        childRepostkey: widget.isPost
            ? null
            : widget.isRepost
            ? model.key
            : null,
        userId: myUser.userId);
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(''),
        onActionPressed: _submitButton,
        isCrossButton: true,
        submitButtonText: widget.isPost
            ? 'Post'
            : 'Post',
        isSubmitDisable:
        !Provider.of<ComposePostState>(context).enableSubmitButton || Provider.of<FeedState>(context).isBusy,
        isbootomLine: Provider.of<ComposePostState>(context).isScrollingDown,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollcontroller,
              child: _ComposePost(this),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ComposeBottomIconWidget(
                textEditingController: _textEditingController,
                onImageIconSelcted: _onImageIconSelcted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ComposePost extends WidgetView<ComposePostPage, _ComposePostReplyPageState> {
  _ComposePost(this.viewState) : super(viewState);

  final _ComposePostReplyPageState viewState;

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ComposePostImage(
                image: viewState._image,
                onCrossIconPressed: viewState._onCrossIconPressed,
              ),
              _UserList(
                list: Provider.of<SearchState>(context).userlist,
                textEditingController: viewState._textEditingController,
              )
            ],
          ),

          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldTitle(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldPrice(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController1,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldDuration(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController2,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldLocation(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController3,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldSeats(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController4,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldSave(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController5,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextFieldDetails(
                  isPost: widget.isPost,
                  textEditingController: viewState._textEditingController6,
                ),
              )
            ],
          ),
          SizedBox(height: 150),
        ],
      ),
    );
  }
}

class _TextFieldTitle extends StatelessWidget {
  const _TextFieldTitle(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'What\'s happening?\tE.g Camp Fire',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w800,
             ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldPrice extends StatelessWidget {
  const _TextFieldPrice(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Price\tE.g UGX 150,000 per person',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false).onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldDuration extends StatelessWidget {
  const _TextFieldDuration(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Duration\tE.g 21st - 24th Jun 20xx',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldLocation extends StatelessWidget {
  const _TextFieldLocation(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Location\tE.g Jinja',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldSeats extends StatelessWidget {
  const _TextFieldSeats(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Seats available\tE.g 50 seats',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldSave extends StatelessWidget {
  const _TextFieldSave(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Weekly Saving \nE.g\tSave\tas\tlow\tas\t20,000\tper\tweek',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _TextFieldDetails extends StatelessWidget {
  const _TextFieldDetails(
      {Key key,
        this.textEditingController,
        this.isPost = false,
        this.isRepost = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPost;
  final bool isRepost;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Trip details\nE.g\tCamping,\thiking\tnyama\tchoma\tcanoing',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            )
        ),
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            Provider.of<ComposePostState>(context, listen: false)
                .onDescriptionChanged(text, searchState);
          },
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              hintText: isPost
                  ? ''
                  : '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      ],
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({Key key, this.list, this.textEditingController})
      : super(key: key);
  final List<UserModel> list;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return !Provider.of<ComposePostState>(context).displayUserList ||
        list == null ||
        list.length < 0 ||
        list.length == 0
        ? SizedBox.shrink()
        :
    Container(
      padding: EdgeInsetsDirectional.only(bottom: 50),
      color: Colors.white,
      constraints:
      BoxConstraints(minHeight: 30, maxHeight: double.infinity),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _UserTile(
            user: list[index],
            onUserSelected: (user) {
              textEditingController.text =
                  Provider.of<ComposePostState>(context, listen: false)
                      .getDescription(user.userName);
              textEditingController.selection = TextSelection.collapsed(
                  offset: textEditingController.text.length);
              Provider.of<ComposePostState>(context, listen: false)
                  .onUserSelected();
            },
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user, this.onUserSelected}) : super(key: key);
  final UserModel user;
  final ValueChanged<UserModel> onUserSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onUserSelected(user);
      },
      leading: customImage(context, user.profilePic, height: 35),
      title: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints:
            BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) * .5),
            child: TitleText(user.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 3),
          user.isVerified
              ? customIcon(
            context,
            icon: AppIcon.blueTick,
            istwitterIcon: true,
            iconColor: AppColor.primary,
            size: 13,
            paddingIcon: 3,
          )
              : SizedBox(width: 0),
        ],
      ),
      subtitle: Text(user.userName),
    );
  }
}


