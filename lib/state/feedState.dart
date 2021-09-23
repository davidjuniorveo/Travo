import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:streambox/helper/enum.dart';
import 'package:streambox/model/feedModel.dart';
import 'package:streambox/helper/utility.dart';
import 'package:streambox/model/user.dart';
import 'package:streambox/state/appState.dart';
import 'package:path/path.dart' as Path;
import '../helper/constant.dart';
// import 'authState.dart';


class FeedState extends AppState {

  bool isBusy = false;
  Map<String, List<FeedModel>> postReplyMap = {};
  FeedModel _postToReplyModel;
  FeedModel get postToReplyModel => _postToReplyModel;

  set setPostToReply(FeedModel model) {
    _postToReplyModel = model;
  }

  List<FeedModel> _commentlist;

  List<FeedModel> _feedlist;

  List<FeedModel> _postDetailModelList;
  List<String> _userfollowingList;
  List<String> get followingList => _userfollowingList;

  List<FeedModel> get postDetailModel => _postDetailModelList;

  static final CollectionReference _postCollection = kfirestore.collection(TWEET_COLLECTION);

  List<FeedModel> get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist.reversed);
    }
  }

  List<FeedModel> getPostList(UserModel userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel> list;

    if (!isBusy && feedlist != null && feedlist.isNotEmpty) {
      list = feedlist.where((x) {
        /// If Post is a comment then no need to add it in post list
        if (x.parentkey != null &&
            x.childRepostkey == null &&
            x.user.userId != userModel.userId) {
          return false;
        }
        return true;
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  set setFeedModel(FeedModel model) {
    if (_postDetailModelList == null) {
      _postDetailModelList = [];
    }

    /// [Skip if any duplicate post already present]
    if (_postDetailModelList.length >= 0) {
      _postDetailModelList.add(model);
      cprint(
          "Detail Post added. Total Post: ${_postDetailModelList.length}");
      // notifyListeners();
    }
  }

  void removeLastPostDetail(String postKey) {
    if (_postDetailModelList != null && _postDetailModelList.length > 0) {
      // var index = _postDetailModelList.in
      FeedModel removePost =
          _postDetailModelList.lastWhere((x) => x.key == postKey);
      _postDetailModelList.remove(removePost);
      postReplyMap.removeWhere((key, value) => key == postKey);
      cprint(
          "Last Post removed from stack. Remaining Post: ${_postDetailModelList.length}");
      if (_postDetailModelList.length > 0) {
        print("Last id available: " + _postDetailModelList.last.key);
      }
      notifyListeners();
    }
  }

  void clearAllDetailAndReplyPostStack() {
    if (_postDetailModelList != null) {
      _postDetailModelList.clear();
    }
    if (postReplyMap != null) {
      postReplyMap.clear();
    }
    cprint('Empty posts from stack');
  }

  Future<bool> databaseInit() {
    try {
      _postCollection.snapshots().listen((QuerySnapshot snapshot) {
        // Return if there is no posts in database
        if (snapshot.docChanges.isEmpty) {
          return;
        }
        if (snapshot.docChanges.first.type == DocumentChangeType.added) {
          _onPostAdded(snapshot.docChanges.first.doc);
        } else if (snapshot.docChanges.first.type ==
            DocumentChangeType.removed) {
          _onPostRemoved(snapshot.docChanges.first.doc);
        } else if (snapshot.docChanges.first.type ==
            DocumentChangeType.modified) {
          _onPostChanged(snapshot.docChanges.first.doc);
        }
      });

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  void getDataFromDatabase() async {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
      _postCollection.get().then((QuerySnapshot querySnapshot) {
        _feedlist = List<FeedModel>();
        final data = querySnapshot.docs;
        if (data != null && data.isNotEmpty) {
          for (var i = 0; i < data.length; i++) {
            var model = FeedModel.fromJson(querySnapshot.docs[i].data());
            model.key = querySnapshot.docs[i].id;
            _feedlist.add(model);
          }

          /// Sort Post by time
          /// It helps to display newest Post first.
          _feedlist.sort((x, y) => DateTime.parse(x.createdAt)
              .compareTo(DateTime.parse(y.createdAt)));
          notifyListeners();
        } else {
          _feedlist = null;
        }
      });
      isBusy = false;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  void getpostDetailFromDatabase(String postID, {FeedModel model}) async {
    try {
      FeedModel _postDetail;
      if (model != null) {
        // set post data from post list data.
        // No need to fetch post from firebase db if data already present in post list
        _postDetail = model;
        setFeedModel = _postDetail;
        postID = model.key;
      } else {
        // Fetch post data from firebase
        _postCollection.doc(postID).get().then((DocumentSnapshot snapshot) {
          var map = snapshot.data();
          _postDetail = FeedModel.fromJson(map);
          _postDetail.key = snapshot.id;
          setFeedModel = _postDetail;
        });
      }

      if (_postDetail != null) {
        // Fetch comment posts
        _commentlist = <FeedModel>[];
        // Check if parent post has reply posts or not
        if (_postDetail.replyPostKeyList != null &&
            _postDetail.replyPostKeyList.length > 0) {
          _postDetail.replyPostKeyList.forEach((postKey) {
            if (postKey == null) {
              return;
            }
            _postCollection
                .doc(postKey)
                .get()
                .then((DocumentSnapshot snapshot) {
              if (snapshot.data != null) {
                var map = snapshot.data();
                final commentmodel = FeedModel.fromJson(map);
                commentmodel.key = snapshot.id;
                commentmodel.key = snapshot.id;
                // setFeedModel = _postDetail;

                /// add comment post to list if post is not present in [comment post ]list
                /// To reduce duplicacy
                if (!_commentlist.any((x) => x.key == commentmodel.key)) {
                  _commentlist.add(commentmodel);
                }
              }
              if (postKey == _postDetail.replyPostKeyList.last) {
                /// Sort comment by time
                /// It helps to display newest Post first.
                _commentlist.sort((x, y) => DateTime.parse(y.createdAt)
                    .compareTo(DateTime.parse(x.createdAt)));
                postReplyMap.putIfAbsent(postID, () => _commentlist);
              }
            }).whenComplete(() {
              if (postKey == _postDetail.replyPostKeyList.last) {
                notifyListeners();
              }
            });

          });
        } else {
          postReplyMap.putIfAbsent(postID, () => _commentlist);
          notifyListeners();
        }
      }
    } catch (error) {
      cprint(error, errorIn: 'getpostDetailFromDatabase');
    }
  }

  Future<FeedModel> fetchPost(String postID) async {
    FeedModel _postDetail;

    /// If post is availabe in feedlist then no need to fetch it from firebase
    if (feedlist.any((x) => x.key == postID)) {
      _postDetail = feedlist.firstWhere((x) => x.key == postID);
    }

    /// If post is not available in feedlist then need to fetch it from firebase
    else {
      cprint("Fetched from DB: " + postID);
      var model = await kDatabase.child('post').child(postID).once().then(
        (DataSnapshot snapshot) {
          if (snapshot.value != null) {
            var map = snapshot.value;
            _postDetail = FeedModel.fromJson(map);
            _postDetail.key = snapshot.key;
            print(_postDetail.description);
          }
        },
      );
      if (model != null) {
        _postDetail = model;
      } else {
        cprint("Fetched null value from  DB");
      }
    }
    return _postDetail;
  }

  Future<void> createPost(FeedModel model) async {
    ///  Create post in [Firebase kDatabase]
    isBusy = true;
    notifyListeners();
    try {
      await _postCollection.doc().set(model.toJson());
    } catch (error) {
      cprint(error, errorIn: 'createPost');
    }
    isBusy = false;
    notifyListeners();
  }

  createRePost(FeedModel model) {
    try {
      createPost(model);
      _postToReplyModel.repostCount += 1;
      updatePost(_postToReplyModel);
    } catch (error) {
      cprint(error, errorIn: 'createRePost');
    }
  }

  deletePost(String postId, PostType type, {String parentkey}) {
    try {
      /// Delete post if it is in nested post detail page
      ///  kfirestore

      _postCollection.doc(postId).delete().then((_) {
        if (type == PostType.Detail &&
            _postDetailModelList != null &&
            _postDetailModelList.length > 0) {
          // var deletedPost =
          //     _postDetailModelList.firstWhere((x) => x.key == postId);
          _postDetailModelList.remove(_postDetailModelList);
          if (_postDetailModelList.length == 0) {
            _postDetailModelList = null;
          }

          cprint('Post deleted from nested post detail page post');
        }
      });
    } catch (error) {
      cprint(error, errorIn: 'deletePost');
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child("postImage")
          .child(Path.basename(file.path));
      await storageReference.putFile(file);

      var url = await storageReference.getDownloadURL();
      if (url != null) {
        return url;
      }
      return null;
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  Future<void> deleteFile(String url, String baseUrl) async {
    try {
      String filePath = url.split(".com/o/")[1];
      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
      var storageReference = FirebaseStorage.instance.ref();
      await storageReference.child(filePath).delete().catchError((val) {
        cprint('[Error]' + val);
      }).then((_) {
        cprint('[Sucess] Image deleted');
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  Future<void> updatePost(FeedModel model) async {
    await _postCollection.doc(model.key).update(model.toJson());
    // await kDatabase.child('post').child(model.key).set(model.toJson());
  }

  addLikeToPost(FeedModel post, String userId) {
    try {
      if (post.likeList != null &&
          post.likeList.length > 0 &&
          post.likeList.any((id) => id == userId)) {
        // If user wants to undo/remove his like on post
        post.likeList.removeWhere((id) => id == userId);
        post.likeCount -= 1;
      } else {
        // If user like Post
        if (post.likeList == null) {
          post.likeList = [];
        }
        post.likeList.add(userId);
        post.likeCount += 1;
      }
      // update likelist of a post
      _postCollection
          .doc(post.key)
          .update({"likeCount": post.likeCount, "likeList": post.likeList});
      if (post.likeList.length == 0) {
        kfirestore
            .collection(USERS_COLLECTION)
            .doc(post.userId)
            .collection(NOTIFICATION_COLLECTION)
            .doc(post.key)
            .delete();
      } else {
        kfirestore
            .collection(USERS_COLLECTION)
            .doc(post.userId)
            .collection(NOTIFICATION_COLLECTION)
            .doc(post.key)
            .set({
          'type': NotificationType.Like.toString(),
          'updatedAt': DateTime.now().toUtc().toString(),
        });
      }
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'addLikeToPost');
    }
  }

  addcommentToPost(FeedModel replyPost) {
    try {
      isBusy = true;
      notifyListeners();
      if (_postToReplyModel != null) {
        FeedModel post =
            _feedlist.firstWhere((x) => x.key == _postToReplyModel.key);
        createPost(replyPost).then((value) {
          post.replyPostKeyList.add(_feedlist.last.key);
          updatePost(post);
        });
      }
    } catch (error) {
      cprint(error, errorIn: 'addcommentToPost');
    }
    isBusy = false;
    notifyListeners();
  }

  _onPostChanged(DocumentSnapshot event) {
    if (event.data == null) {
      return;
    }
    var model = FeedModel.fromJson(event.data());
    model.key = event.id;
    if (_feedlist.any((x) => x.key == model.key)) {
      var oldEntry = _feedlist.lastWhere((entry) {
        return entry.key == event.id;
      });
      _feedlist[_feedlist.indexOf(oldEntry)] = model;
    }

    if (_postDetailModelList != null && _postDetailModelList.length > 0) {
      if (_postDetailModelList.any((x) => x.key == model.key)) {
        var oldEntry = _postDetailModelList.lastWhere((entry) {
          return entry.key == event.id;
        });
        _postDetailModelList[_postDetailModelList.indexOf(oldEntry)] = model;
      }
      if (postReplyMap != null && postReplyMap.length > 0) {
        if (true) {
          var list = postReplyMap[model.parentkey];
          //  var list = postReplyMap.values.firstWhere((x) => x.any((y) => y.key == model.key));
          if (list != null && list.length > 0) {
            var index =
                list.indexOf(list.firstWhere((x) => x.key == model.key));
            list[index] = model;
          } else {
            list = [];
            list.add(model);
          }
        }
      }
    }
    if (event.data != null) {
      cprint('Post updated');
      isBusy = false;
      notifyListeners();
    }
  }

  _onPostAdded(DocumentSnapshot event) {
    FeedModel post = FeedModel.fromJson(event.data());
    post.key = event.id;

    /// Check if Post is a comment
    _onCommentAdded(post);
    if (_feedlist == null) {
      _feedlist = <FeedModel>[];
    }
    if ((_feedlist.length == 0 || _feedlist.any((x) => x.key != post.key)) &&
        post.isValidPost) {
      _feedlist.add(post);
      cprint('Post Added');
    }
    isBusy = false;
    notifyListeners();
  }

  _onCommentAdded(FeedModel post) {
    if (post.childRepostkey != null) {
      /// if Post is a type of repost then it can not be a comment.
      return;
    }
    if (postReplyMap != null && postReplyMap.length > 0) {
      if (postReplyMap[post.parentkey] != null) {
        postReplyMap[post.parentkey].add(post);
      } else {
        postReplyMap[post.parentkey] = [post];
      }
      cprint('Comment Added');
    }
    isBusy = false;
    notifyListeners();
  }

  _onPostRemoved(DocumentSnapshot event) async {
    FeedModel post = FeedModel.fromJson(event.data());
    post.key = event.id;
    var postId = post.key;
    var parentkey = post.parentkey;

    ///  Delete post in [Home Page]
    try {
      FeedModel deletedPost;
      if (_feedlist.any((x) => x.key == postId)) {
        /// Delete post if it is in home page post.
        deletedPost = _feedlist.firstWhere((x) => x.key == postId);
        _feedlist.remove(deletedPost);

        if (deletedPost.parentkey != null &&
            _feedlist.isNotEmpty &&
            _feedlist.any((x) => x.key == deletedPost.parentkey)) {
          // Decrease parent Post comment count and update
          var parentModel =
              _feedlist.firstWhere((x) => x.key == deletedPost.parentkey);
          parentModel.replyPostKeyList.remove(deletedPost.key);
          parentModel.commentCount = parentModel.replyPostKeyList.length;
          updatePost(parentModel);
        }
        if (_feedlist.length == 0) {
          _feedlist = null;
        }
        cprint('Post deleted from home page post list');
      }

      /// [Delete post] if it is in nested post detail comment section page
      if (parentkey != null &&
          parentkey.isNotEmpty &&
          postReplyMap != null &&
          postReplyMap.length > 0 &&
          postReplyMap.keys.any((x) => x == parentkey)) {
        // (type == PostType.Reply || postReplyMap.length > 1) &&
        deletedPost =
            postReplyMap[parentkey].firstWhere((x) => x.key == postId);
        postReplyMap[parentkey].remove(deletedPost);
        if (postReplyMap[parentkey].length == 0) {
          postReplyMap[parentkey] = null;
        }

        if (_postDetailModelList != null &&
            _postDetailModelList.isNotEmpty &&
            _postDetailModelList.any((x) => x.key == parentkey)) {
          var parentModel =
              _postDetailModelList.firstWhere((x) => x.key == parentkey);
          parentModel.replyPostKeyList.remove(deletedPost.key);
          parentModel.commentCount = parentModel.replyPostKeyList.length;
          cprint('Parent post comment count updated on child post removal');
          updatePost(parentModel);
        }

        cprint('Post deleted from nested post detail comment section');
      }

      /// Delete post image from firebase storage if exist.
      if (deletedPost.imagePath != null && deletedPost.imagePath.length > 0) {
        deleteFile(deletedPost.imagePath, 'postImage');
      }

      /// If a repost is deleted then repostCount of original post should be decrease by 1.
      if (deletedPost.childRepostkey != null) {
        await fetchPost(deletedPost.childRepostkey).then((repostModel) {
          if (repostModel == null) {
            return;
          }
          if (repostModel.repostCount > 0) {
            repostModel.repostCount -= 1;
          }
          updatePost(repostModel);
        });
      }

      /// Delete notification related to deleted Post.
      if (deletedPost.likeCount > 0) {
        kfirestore
            .collection(USERS_COLLECTION)
            .doc(post.userId)
            .collection(NOTIFICATION_COLLECTION)
            .doc(post.key)
            .delete();

        // kDatabase
        //     .child('notification')
        //     .child(post.userId)
        //     .child(post.key)
        //     .remove();
      }
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: '_onPostRemoved');
    }
  }
}
