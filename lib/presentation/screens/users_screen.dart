import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shrine/app.dart';
import 'package:shrine/presentation/helper_functions/helper_functions.dart';
import 'package:shrine/presentation/screens/imports.dart';
import 'package:shrine/presentation/screens/loading_screen.dart';
import 'package:shrine/presentation/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersScreen extends StatefulWidget {
  final SupabaseClient supabase;
  const UsersScreen({super.key, required this.supabase});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    void updateUser(projectName, name, userDesignation, userName, userEmail,
        BuildContext context) {
      TextEditingController userController =
          TextEditingController(text: userName);
      TextEditingController userDesignationController =
          TextEditingController(text: userDesignation);
      TextEditingController nameController = TextEditingController(text: name);
      TextEditingController emailController =
          TextEditingController(text: userEmail);
      TextEditingController projectController =
          TextEditingController(text: projectName);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Update User Details'),
          content: SizedBox(
            width: 500,
            height: 495,
            child: Column(
              children: [
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Project',
                  controller: projectController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Username',
                  controller: userController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Name',
                  controller: nameController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Designation',
                  controller: userDesignationController,
                ),
                const SizedBox(
                  height: 25,
                ),
                CTAButton(
                  text: 'Save',
                  onTap: () async {
                    try {
                      await widget.supabase.from('users').upsert({
                        'name': userController.text.toString(),
                        'user_name': nameController.text.toString(),
                        'user_designation':
                            userDesignationController.text.toString(),
                        'user_email': emailController.text.toString(),
                        'project_name': projectController.text.toString(),
                      });
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Update user error: $e');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    }

    Future<dynamic> deleteUser(selectedUser) async {
      try {
        showDialog(
          context: context,
          builder: (context) => Container(
            color: whiteBG,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/ani1.json', height: 500),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    'Crunching your data, this might take some time',
                    style: GoogleFonts.dmSerifDisplay(
                        fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                )
              ],
            ),
          ),
        );
        await widget.supabase
            .from('users')
            .delete()
            .eq('user_name', selectedUser);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoadingScreen(
              screen: HomeScreen(
                supabase: widget.supabase,
              ),
              supabase: widget.supabase,
            ),
          ),
        );
      } catch (e) {
        // showDialog(

        // );
      }
    }

    //helpful functions to retrieve project and user details of team that login to website
    HelperFunctions helperFunctions = HelperFunctions();

    List images = [
      "assets/avatars/man (1).png",
      "assets/avatars/man (2).png",
      "assets/avatars/man (3).png",
      "assets/avatars/man (4).png",
      "assets/avatars/man (5).png",
    ];

    return Container(
      // height: 800,
      // width: 400,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          border: Border(right: BorderSide(width: 3, color: whiteContainer))),
      child: FutureBuilder(
          future: helperFunctions.getUsersForProject(context, widget.supabase),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Lottie.asset('assets/lottie/ani1.json', height: 500));
            } else if (snapshot.hasError) {
              return showErrorDialog(context, 'error in retriewing data');
            } else if (snapshot.data!.isEmpty) {
              return const ListTile(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusColor: whiteContainer,
                hoverColor: whiteContainer,
                autofocus: true,
                selectedColor: black,
                selectedTileColor: whiteContainer,
                tileColor: whiteBG,
                leading:  CircleAvatar(
                    child: Text('😒', style: TextStyle(fontSize: 30))),
                title: Text(
                  'Add a user',
                  style: TextStyle(fontSize: 12),
                ),
              );
            } else {
              final data = snapshot.data;
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final userdata = data[index];
                    return Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10),
                        child: ListTile(
                          selectedColor: black,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          selected: true,
                          selectedTileColor: whiteContainer,
                          leading: CircleAvatar(
                            child: Image.asset(images[Random().nextInt(5)]),
                          ),
                          title: Text('${userdata.name}'),
                          subtitle: Text(
                            '${userdata.userEmail}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          horizontalTitleGap: 10,
                          trailing: SizedBox(
                            width: 96,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => updateUser(
                                        userdata.projectName,
                                        userdata.name,
                                        userdata.userDesignation,
                                        userdata.userName,
                                        userdata.userEmail,
                                        context),
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      size: 20,
                                      color: black,
                                    )),
                                IconButton(
                                    onPressed: () =>
                                        deleteUser(userdata.userName),
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 20,
                                      color: black,
                                    )),
                              ],
                            ),
                          ),
                        ));
                  });
            }
          }),
    );
  }
}
