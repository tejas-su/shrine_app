import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrine/app.dart';
import 'package:shrine/presentation/helper_functions/helper_functions.dart';
import 'package:shrine/presentation/screens/imports.dart';
import 'package:shrine/presentation/screens/loading_screen.dart';
import 'package:shrine/presentation/themes/theme.dart';
import 'package:shrine/presentation/widgets/cta_button.dart';
import 'package:shrine/presentation/widgets/text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeContent extends StatefulWidget {
  final SupabaseClient supabase;
  const HomeContent({super.key, required this.supabase});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  //helpful functions to retrieve project and user details of team that login to website
  HelperFunctions helperFunctions = HelperFunctions();

  //selected project name
  String selectedprojectname = '';

  //user taps on project
  bool selected = false;

  //Selected Project Index
  int selectedIndex = -1;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getgroupname();
  
  }
String groupname = '';

  getgroupname() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        groupname = prefs.getString('team_name').toString();
      });
    }

  //on tap of list tile event handler
  void projectselected(BuildContext context, projectname, index) {
    setState(() {
      selectedprojectname = projectname;
      selectedIndex = index;
    });
  }

  //update user function
  void updateProject(
      projectName, projectDescription, BuildContext context, supabase) {
    TextEditingController projectcontroller =
        TextEditingController(text: projectName);
    TextEditingController projectDescriptionController =
        TextEditingController(text: projectDescription);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 500,
          height: 400,
          child: Column(
            children: [
              Text(
                "Team $groupname currently working on $projectName",
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InputTextField(
                left: 0,
                right: 0,
                hintText: 'Project',
                controller: projectcontroller,
              ),
              const SizedBox(height: 20),
              InputTextField(
                left: 0,
                right: 0,
                hintText: 'Project Description',
                controller: projectDescriptionController,
              ),
              const SizedBox(height: 20),
              const SizedBox(
                height: 25,
              ),
              CTAButton(
                text: 'Save',
                onTap: () async {
                  try {
                    await supabase.from('projects').upsert({
                      'project_name': projectcontroller.text.toString(),
                      'project_description':
                          projectDescriptionController.text.toString(),
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

  Future<dynamic> deleteproject(selectedproject) async {
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
          .from('projects')
          .delete()
          .eq('project_name', selectedproject);

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

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 800,
        // width: 400,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            border: Border(right: BorderSide(width: 3, color: whiteContainer))),
        child: FutureBuilder(
            future: helperFunctions.getProjects(context, widget.supabase),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        Lottie.asset('assets/lottie/ani1.json', height: 500));
              } else if (snapshot.hasError) {
                return showErrorDialog(context, 'Error in retreiving data');
              } else if (snapshot.data!.isEmpty) {
                return ListTile(
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusColor: whiteContainer,
                  hoverColor: whiteContainer,
                  autofocus: true,
                  selected: selected,
                  selectedColor: black,
                  selectedTileColor: whiteContainer,
                  tileColor: whiteBG,
                  leading: const CircleAvatar(
                      child: Text('😒', style: TextStyle(fontSize: 30))),
                  title: const Text(
                    'Add a project',
                    style: TextStyle(fontSize: 12),
                  ),
                );
              } else if (snapshot.hasData) {
                final project = snapshot.data;
                return ListView.builder(
                    itemCount: project!.length, //
                    itemBuilder: (context, index) {
                      final projects = project[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: ListTile(
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusColor: whiteContainer,
                          hoverColor: whiteContainer,
                          autofocus: true,
                          selected:
                              selectedIndex == index, // selectedIndex == index
                          selectedColor: black,
                          selectedTileColor: whiteContainer,
                          onTap: () async {
                            projectselected(
                                context, projects.projectName, index);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('selected_project_name',
                                '${projects.projectName}');
                          },
                          enabled: true,
                          tileColor: whiteBG,
                          leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/avatars/man (1).png')),
                          title: Text('${projects.projectName}'),
                          subtitle: Text(
                            maxLines: 2,
                            '${projects.projectDescription}',
                            softWrap: true,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: SizedBox(
                            width: 96,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => updateProject(
                                        projects.projectName,
                                        projects.projectDescription,
                                        context,
                                        widget.supabase),
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      size: 20,
                                      color: black,
                                    )),
                                IconButton(
                                    onPressed: () =>
                                        deleteproject(projects.projectName),
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 20,
                                      color: black,
                                    )),
                              ],
                            ),
                          ),
                          horizontalTitleGap: 10,
                        ),
                      );
                    });
              } else {
                return const Text('');
              }
            }));
  }
}
