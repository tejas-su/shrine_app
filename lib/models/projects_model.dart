class project {
  int? projectid;
  String? projectName;
  String? teamName;
  String? projectDescription;
  String? dateCreated;

  project(
      {this.projectid,
      this.projectName,
      this.teamName,
      this.projectDescription,
      this.dateCreated});

  project.fromJson(Map<String, dynamic> json) {
    projectid = json['projectid'];
    projectName = json['project_name'];
    teamName = json['team_name'];
    projectDescription = json['project_description'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectid'] = this.projectid;
    data['project_name'] = this.projectName;
    data['team_name'] = this.teamName;
    data['project_description'] = this.projectDescription;
    data['date_created'] = this.dateCreated;
    return data;
  }
}
