class bugs {
  int? bugsId;
  String? bugsName;
  String? bugsDescription;
  String? projectName;
  String? dateCreated;
  String? updateDate;
  String? bugStatus;

  bugs(
      {this.bugsId,
      this.bugsName,
      this.bugsDescription,
      this.projectName,
      this.dateCreated,
      this.updateDate,
      this.bugStatus});

  bugs.fromJson(Map<String, dynamic> json) {
    bugsId = json['bugs_id'];
    bugsName = json['bugs_name'];
    bugsDescription = json['bugs_description'];
    projectName = json['project_name'];
    dateCreated = json['date_created'];
    updateDate = json['update_date'];
    bugStatus = json['bug_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bugs_id'] = this.bugsId;
    data['bugs_name'] = this.bugsName;
    data['bugs_description'] = this.bugsDescription;
    data['project_name'] = this.projectName;
    data['date_created'] = this.dateCreated;
    data['update_date'] = this.updateDate;
    data['bug_status'] = this.bugStatus;
    return data;
  }
}
