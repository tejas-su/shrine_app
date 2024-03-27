import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/imports.dart';

class CommentsSection extends StatefulWidget {
  final SupabaseClient supabase;

  const CommentsSection({
    super.key,
    required this.supabase,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  //retrieve the selected project name
  final Storage localStorage = window.localStorage;

  final TextEditingController _textController = TextEditingController();
  // final List<String> _messages = [];

  //user images
  List images = [
    "assets/avatars/man (1).png",
    "assets/avatars/man (2).png",
    "assets/avatars/man (3).png",
    "assets/avatars/man (4).png",
    "assets/avatars/man (5).png",
  ];

  @override
  Widget build(BuildContext context) {
    var obj = HelperFunctions();
    String projectName = localStorage['projectName'].toString();
    //first project name if nothing is selected
    String firstProject = localStorage['firstProject'].toString();
    //date current
    DateTime now = DateTime.now();
    //formatted date in dd-mm-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    void clearTextField() {
      _textController.clear();
    }

    //error dialog
    void showErrorDialog(
      BuildContext context,
      String title,
      String message,
    ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    void getChatsAndRefresh() async {
      setState(() {
        obj.getChats(context, widget.supabase, projectName);
      });
    }

    //add the chat to the db
    void _handleSubmitted(String message) async {
      print('Chat screen project name: $projectName $firstProject');
      try {
        if (projectName.isEmpty) {
          projectName = firstProject;
        }
        if (message.isEmpty) {
          showErrorDialog(
            context,
            'Oops, something went wrong',
            'Please fill in all the fields',
          );
        } else {
          //insert into the char table
          await widget.supabase.from('chats').insert({
            'chat': message,
            'project_name': projectName,
            'date': formattedDate,
          });

          getChatsAndRefresh();
          clearTextField();
        }
      } catch (e) {
        showErrorDialog(
            context, 'Oops something went wrong 😭', 'This was thrown $e');
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    HelperFunctions helperFunctions = HelperFunctions();
    final supabase = Supabase.instance.client;
    return SizedBox(
        width: width - 80,
        height: height,
        child: FutureBuilder(
            future: helperFunctions.getChats(context, supabase, firstProject),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else if (snapshot.hasData) {
                final data = snapshot.data;

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          final chatdata = data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                  foregroundImage:
                                      AssetImage(images[Random().nextInt(5)])),
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              focusColor: whiteContainer,
                              hoverColor: whiteContainer,
                              autofocus: true,
                              tileColor: whiteContainer,
                              selectedColor: black,
                              selectedTileColor: whiteContainer,
                              title: Text('${chatdata.chat}', softWrap: true),
                              trailing: Text(
                                '${chatdata.date}',
                              ),
                              subtitle: Text('${chatdata.projectName}'),
                              horizontalTitleGap: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    InputTextField(
                      left: 5,
                      right: 5,
                      bottom: 10,
                      color: whiteContainer,
                      hintText: 'Type Something here',
                      controller: _textController,
                      obscureText: false,
                      onSubmitted: (p0) =>
                          _handleSubmitted(_textController.text),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _handleSubmitted(_textController.text);
                          },
                          icon: const Icon(Icons.send_rounded)),
                    ),
                  ],
                );
              } else {
                return const Text('Something Went Wrong');
              }
            }));
  }
}

 
/*


 Widget _buildMessageInputField() {
    return InputTextField(
      left: 5,
      right: 5,
      bottom: 10,
      color: whiteContainer,
      hintText: 'Type Something here',
      controller: _textController,
      obscureText: false,
      onSubmitted: (p0) => _handleSubmitted(_textController.text),
      suffixIcon: IconButton(
          onPressed: () => _handleSubmitted(_textController.text),
          icon: const Icon(Icons.send_rounded)),
    );
  }


*/