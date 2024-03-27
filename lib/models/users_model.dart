class users {
  int? userId;
  String? userName;
  String? userEmail;
  String? projectName;
  String? userDesignation;
  String? name;

  users(
      {this.userId,
      this.userName,
      this.userEmail,
      this.projectName,
      this.userDesignation,
      this.name});

  users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    projectName = json['project_name'];
    userDesignation = json['user_designation'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['project_name'] = this.projectName;
    data['user_designation'] = this.userDesignation;
    data['name'] = this.name;
    return data;
  }
}
