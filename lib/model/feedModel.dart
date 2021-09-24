import 'package:streambox/model/user.dart';

class FeedModel {
  String key;
  String parentkey;
  String childRepostkey;

  String imagePath;
  String description;
  String duration;
  String location;
  String seats;
  String save;
  String details;
  String price;

  String userId;
  int likeCount;
  List<String> likeList;
  int commentCount;
  int repostCount;
  String createdAt;
  List<String> tags;
  List<String> replyPostKeyList;
  UserModel user;

  FeedModel(
      {this.key,
        this.imagePath,
        this.description,
        this.duration,
        this.location,
        this.seats,
        this.save,
        this.details,
        this.price,

      this.userId,
      this.likeCount,
      this.commentCount,
      this.repostCount,
      this.createdAt,

      this.likeList,
      this.tags,
      this.user,
      this.replyPostKeyList,
      this.parentkey,
      this.childRepostkey
      });
  toJson() {
    return {
      "userId": userId,
      "description": description,
      "imagePath": imagePath,
      "duration": duration,
      "location": location,
      "save": save,
      "seats": seats,
      "details": details,
      "price": price,
      "likeCount": likeCount,
      "commentCount": commentCount ?? 0,
      "repostCount": repostCount ?? 0,
      "createdAt": createdAt,
      "likeList": likeList,
      "tags": tags,
      "replyPostKeyList": replyPostKeyList,
      "user": user == null ? null : user.toJson(),
      "parentkey": parentkey,
      "childRepostkey": childRepostkey
    };
  }

  FeedModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];

    description = map['description'];
    imagePath = map['imagePath'];
    duration = map['duration'];
    save = map['save'];
    location = map['location'];
    seats = map['seats'];
    details = map['details'];
    price = map['price'];
    userId = map['userId'];
    //  name = map['name'];
    //  profilePic = map['profilePic'];
    likeCount = map['likeCount'];
    commentCount = map['commentCount'];
    repostCount = map["repostCount"] ?? 0;
    createdAt = map['createdAt'];
    //  username = map['username'];
    user = UserModel.fromJson(map['user']);
    parentkey = map['parentkey'];
    childRepostkey = map['childRepostkey'];
    if (map['tags'] != null) {
      tags = List<String>();
      map['tags'].forEach((value) {
        tags.add(value);
      });
    }
    if (map["likeList"] != null) {
      likeList = List<String>();
      final list = map['likeList'];
      if (list is List) {
        map['likeList'].forEach((value) {
          likeList.add(value);
        });
        likeCount = likeList.length;
      }
    } else {
      likeList = [];
      likeCount = 0;
    }
    if (map['replyPostKeyList'] != null &&
        map['replyPostKeyList'].length > 0) {
      map['replyPostKeyList'].forEach((value) {
        replyPostKeyList = List<String>();
        map['replyPostKeyList'].forEach((value) {
          replyPostKeyList.add(value);
        });
      });
      commentCount = replyPostKeyList.length;
    } else {
      replyPostKeyList = [];
      commentCount = 0;
    }
  }

  bool get isValidPost {
    bool isValid = false;
    if (description != null &&
        description.isNotEmpty &&
        this.user != null &&
        this.user.userName != null &&
        this.user.userName.isNotEmpty) {
      isValid = true;
    } else {
      print("Invalid Post found. Id:- $key");
    }
    return isValid;
  }
}
