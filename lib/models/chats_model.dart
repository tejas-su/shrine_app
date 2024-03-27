class chats_model {
  int? id;
  String? projectName;
  String? chat;
  String? date;

  chats_model({this.id, this.projectName, this.chat, this.date});

  chats_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['project_name'];
    chat = json['chat'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_name'] = this.projectName;
    data['chat'] = this.chat;
    data['date'] = this.date;
    return data;
  }
}
