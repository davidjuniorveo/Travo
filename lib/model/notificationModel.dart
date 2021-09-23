class NotificationModel {
  String postKey;
  String updatedAt;
  String type;

  NotificationModel({
    this.postKey,
  });

  NotificationModel.fromJson(Map<String, dynamic> json, ) {
    // postKey = postId;
    this.updatedAt = json["updatedAt"];
    this.type = json["type"];
  }

  Map<String, dynamic> toJson() => {
        "postKey": postKey == null ? null : postKey,
      };
}
