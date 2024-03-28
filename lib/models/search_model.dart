class Search {
  int? userId;
  String? userName;
  String? userEmail;
  String? projectName;
  String? userDesignation;
  String? name;
  int? projectid;
  String? teamName;
  String? projectDescription;
  String? dateCreated;
  int? bugsId;
  String? bugsName;
  String? bugsDescription;
  String? updateDate;
  String? bugStatus;

  Search(
      {this.userId,
      this.userName,
      this.userEmail,
      this.projectName,
      this.userDesignation,
      this.name,
      this.projectid,
      this.teamName,
      this.projectDescription,
      this.dateCreated,
      this.bugsId,
      this.bugsName,
      this.bugsDescription,
      this.updateDate,
      this.bugStatus});

  Search.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    projectName = json['project_name'];
    userDesignation = json['user_designation'];
    name = json['name'];
    projectid = json['projectid'];
    teamName = json['team_name'];
    projectDescription = json['project_description'];
    dateCreated = json['date_created'];
    bugsId = json['bugs_id'];
    bugsName = json['bugs_name'];
    bugsDescription = json['bugs_description'];
    updateDate = json['update_date'];
    bugStatus = json['bug_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['project_name'] = this.projectName;
    data['user_designation'] = this.userDesignation;
    data['name'] = this.name;
    data['projectid'] = this.projectid;
    data['team_name'] = this.teamName;
    data['project_description'] = this.projectDescription;
    data['date_created'] = this.dateCreated;
    data['bugs_id'] = this.bugsId;
    data['bugs_name'] = this.bugsName;
    data['bugs_description'] = this.bugsDescription;
    data['update_date'] = this.updateDate;
    data['bug_status'] = this.bugStatus;
    return data;
  }
}
