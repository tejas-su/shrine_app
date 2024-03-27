class team {
  int? teamId;
  String? teamName;
  String? teamEmail;
  String? teamPassword;

  team({this.teamId, this.teamName, this.teamEmail, this.teamPassword});

  team.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    teamName = json['team_name'];
    teamEmail = json['team_email'];
    teamPassword = json['team_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    data['team_email'] = this.teamEmail;
    data['team_password'] = this.teamPassword;
    return data;
  }
}
