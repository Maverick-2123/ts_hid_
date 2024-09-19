class CommentsModel {
  int? id;
  int? issue;
  int? user;
  String? content;
  String? createdAt;

  CommentsModel({this.id, this.issue, this.user, this.content, this.createdAt});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    issue = json['issue'];
    user = json['user'];
    content = json['content'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issue'] = this.issue;
    data['user'] = this.user;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    return data;
  }
}
