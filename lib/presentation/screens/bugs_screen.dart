import 'package:flutter/material.dart';
import 'package:shrine/app.dart';
import 'package:shrine/presentation/helper_functions/helper_functions.dart';
import 'package:shrine/presentation/screens/imports.dart';
import 'package:shrine/presentation/screens/loading_screen.dart';
import 'package:shrine/presentation/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BugsScreen extends StatelessWidget {
  const BugsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HelperFunctions helperFunctions = HelperFunctions();
    final supabase = Supabase.instance.client;

    //fetch the date
    DateTime now = DateTime.now();
    //formatted date in the format dd-mm-yyyy
    String updatedDate = DateFormat('dd-MM-yyyy').format(now);

    //delete function for bugs
    Future<dynamic> deleteBug(selectedbug) async {
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Crunching your data, this might take some time',
                      style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.w500, fontSize: 25),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        await supabase.from('bugs').delete().eq('bugs_name', selectedbug);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoadingScreen(
              screen: HomeScreen(
                supabase: supabase,
              ),
              supabase: supabase,
            ),
          ),
        );
      } catch (e) {}
    }

    //update user function
    void updateBugs(
      bugName,
      bugStatus,
      bugDescription,
      BuildContext context,
    ) {
      TextEditingController bugController =
          TextEditingController(text: bugName);
      TextEditingController bugStatusController =
          TextEditingController(text: bugStatus);
      TextEditingController updatedDateController =
          TextEditingController(text: updatedDate);
      TextEditingController bugDescriptionController =
          TextEditingController(text: bugDescription);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Update Bug Details'),
          content: SizedBox(
            width: 500,
            height: 460,
            child: Column(
              children: [
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Bug',
                  controller: bugController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Status',
                  controller: bugStatusController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Updated Date',
                  controller: updatedDateController,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  left: 0,
                  right: 0,
                  hintText: 'Description',
                  controller: bugDescriptionController,
                ),
                const SizedBox(
                  height: 25,
                ),
                CTAButton(
                  text: 'Save',
                  onTap: () async {
                    try {
                      await supabase.from('bugs').upsert({
                        'bugs_name': bugController.text.toString(),
                        'bug_status': bugStatusController.text.toString(),
                        'bugs_description':
                            bugDescriptionController.text.toString(),
                        'update_date': updatedDateController.text.toString(),
                        // 'project_name': projectController.text.toString(),
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

    return FutureBuilder(
        future: helperFunctions.getBugsForProject(context, supabase),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/lottie/ani1.json', height: 500));
          } else if (snapshot.hasError) {
            return showErrorDialog(context, 'Error in retreiving data');
          } else if (snapshot.data!.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusColor: whiteContainer,
                  hoverColor: whiteContainer,
                  autofocus: true,
                  selected: false,
                  selectedColor: black,
                  selectedTileColor: whiteContainer,
                  enabled: true,
                  tileColor: whiteBG,
                  leading: CircleAvatar(
                      child: Text('🥳', style: TextStyle(fontSize: 30))),
                  title: Text(
                    'No bugs found, 🥳 ',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(
                    'Feels like everything\'s good ',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            final bugs = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                final bug = bugs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusColor: whiteContainer,
                        hoverColor: whiteContainer,
                        autofocus: true,
                        selectedTileColor: whiteContainer,
                        selectedColor: black,
                        selected: true,
                        title: Text('${bug.bugsName}'),
                        subtitle: Text(
                          'Bug status: ${bug.bugStatus}\ncreated date: ${bug.dateCreated}\nupdated date: ${bug.updateDate}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                  updateBugs(
                                      bug.bugsName,
                                      bug.bugStatus,
                                      bug.bugsDescription,
                                      context)
                                  ,
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    size: 20,
                                    color: black,
                                  )),
                              IconButton(
                                  onPressed: () => deleteBug(bug.bugsName),

                                  //deleteproject(projects.projectName),
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
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Divider(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: Text('Description: '),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: Text(
                          '${bug.bugsDescription}',
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: bugs!.length,
            );
          } else {
            return const Text('');
          }
        });
  }
}
