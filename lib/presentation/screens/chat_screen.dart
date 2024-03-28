import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrine/presentation/screens/imports.dart';
import 'package:shrine/presentation/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helper_functions/helper_functions.dart';

class ChatScreen extends StatefulWidget {
  final SupabaseClient supabase;
  const ChatScreen({super.key, required this.supabase});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    retrieveSelectedProject();
  }

  final TextEditingController _textController = TextEditingController();
  // final List<String> _messages = [];
  String selectedprojectname = '';

  //user images
  List images = [
    "assets/avatars/man (1).png",
    "assets/avatars/man (2).png",
    "assets/avatars/man (3).png",
    "assets/avatars/man (4).png",
    "assets/avatars/man (5).png",
  ];
  retrieveSelectedProject() async {
    //to retrieve selected project name from shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedprojectname = prefs.getString('selected_project_name').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    //date current
    DateTime now = DateTime.now();
    //formatted date in dd-mm-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    var obj = HelperFunctions();

    void clearTextField() {
      _textController.clear();
    }

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
        obj.getChats(context, widget.supabase, selectedprojectname);
      });
    }

    void _handleSubmitted(
        {required String message, required String projectName}) async {
      try {
        //Retrieve group name from shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String firstProject = prefs.getString('firstproject').toString();
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

    return Drawer(
      backgroundColor: whiteBG,
      width: width,
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: obj.getChats(
                      context, widget.supabase, selectedprojectname),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      return ListView.builder(
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
                      );
                    } else {
                      return const Text('Something Went Wrong');
                    }
                  })),
          InputTextField(
            left: 5,
            right: 5,
            bottom: 10,
            color: whiteContainer,
            hintText: 'Type Something here',
            controller: _textController,
            obscureText: false,
            suffixIcon: IconButton(
                onPressed: () async {
                  _handleSubmitted(
                      message: _textController.text,
                      projectName: selectedprojectname);
                },
                icon: const Icon(Icons.send_rounded)),
          ),
        ],
      ),
    );
  }
}
