import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shrine/models/search_model.dart';
import 'package:shrine/presentation/themes/theme.dart';
import 'package:shrine/presentation/widgets/search_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/bugs_model.dart';
import '../../models/projects_model.dart';
import '../../models/users_model.dart';
import '../helper_functions/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedIndex = 0;
  void onTabChange(value) {
    setState(() {
      selectedIndex = value;
    });
  }

  List<Search> searchResults = [];

  void search(
      {required String searchTerm,
      required String tableName,
      required columnName}) async {
    try {
      //search in user table
      var searchResult = await HelperFunctions().search(
          columnname: columnName,
          context: context,
          query: searchTerm,
          supabase: Supabase.instance.client,
          tablename: tableName) as List;
      setState(() {
        searchResults = searchResult as List<Search>;
      });
    } catch (e) {
      // return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //search term controller
    TextEditingController searchTerm = TextEditingController();

    //tabs
    List<String> options = ['projects', 'users', 'bugs'];

    //column name
    List<String> column = ['project_name', 'user_name', 'bugs_name'];

    //Project icons
    List projectIcon = [
      "assets/projects/p1.png",
      "assets/projects/p2.png",
    ];

    return Column(children: [
      SearchField(
        controller: searchTerm,
        onPressed: () => search(
            columnName: column[selectedIndex],
            searchTerm: searchTerm.text,
            tableName: options[selectedIndex].toString()),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Container(
          decoration: const BoxDecoration(
              color: whiteContainer,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: GNav(
              onTabChange: onTabChange,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              padding: const EdgeInsets.symmetric(vertical: 10),
              tabMargin: const EdgeInsets.symmetric(vertical: 5),
              tabBackgroundColor: whiteBG,
              tabBorderRadius: 10,
              iconSize: 22,
              textSize: 15,
              gap: 8,
              tabs: const [
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.newspaper,
                  text: 'Projects',
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.person_rounded,
                  text: 'Users',
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.bug_report_rounded,
                  text: 'Bugs',
                )
              ]),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      if (searchResults.isNotEmpty)
        Expanded(
          child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final data = searchResults[index];
                switch (options[selectedIndex]) {
                  case 'projects':
                    if (searchResults[index].projectName != null) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: whiteContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 4, bottom: 2),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    projectIcon[Random().nextInt(1)],
                                  ),
                                ),
                                title: Text(
                                    "${options[selectedIndex]} Name:${data.projectName} "),
                                subtitle:
                                    Text("date created: ${data.dateCreated}"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 25, bottom: 2),
                              child: Text("Team: ${data.teamName}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 25, bottom: 2),
                              child: Text(
                                  "Project description: ${data.projectDescription} "),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    }

                  case 'users':
                    if (searchResults[index].name != null) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: whiteContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 4, bottom: 2),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    projectIcon[Random().nextInt(1)],
                                  ),
                                ),
                                title: Text(
                                    "${options[selectedIndex]} Name:${data.name} "),
                                subtitle: Text("email: ${data.userEmail}"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 25, bottom: 2),
                              child:
                                  Text("Designation: ${data.userDesignation}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 25, bottom: 2),
                              child: Text("Project: ${data.projectName}  "),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    }
                  case 'bugs':
                    if (searchResults[index].bugsName != null) {
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
                        title: Text('${data.bugsName}'),
                        subtitle: Text(
                          'Bug status: ${data.bugStatus}\ncreated date: ${data.dateCreated}\nupdated date: ${data.updateDate}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        horizontalTitleGap: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                        child: Divider(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Text('Description: '),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 10, top: 10),
                        child: Text(
                          '${data.bugsDescription}',
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  ),
                );
                    }
                }
              }),
        )
      else
        const Center(
          child: Text(
            "No results found",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        )
    ]);
  }
}
