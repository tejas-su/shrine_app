// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrine/models/bugs_model.dart';
import 'package:shrine/models/chats_model.dart';
import 'package:shrine/models/projects_model.dart';
import 'package:shrine/models/search_model.dart';
import 'package:shrine/models/users_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Oops, something went wrong"),
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

class HelperFunctions {
  String firstProject = '';
  Future<List<project>> getProjects(
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    try {
      //Retrieve group name from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String groupname = prefs.getString('team_name').toString();
      final response = await supabase
          .from('projects')
          .select('*')
          .eq('team_name', groupname)
          .order('project_name');

      final projects =
          (response as List).map((json) => project.fromJson(json)).toList();
      firstProject = projects[0].projectName.toString();
      await prefs.setString('firstproject', firstProject);
      if (response.isEmpty) {
        return [];
      }

      return projects;
    } catch (error) {
      //return empty
      return [];
    }
  }

  Future<List<users>> getUsersForProject(
      BuildContext context, SupabaseClient supabase) async {
    try {
      //to retrieve selected project name from shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String selectedprojectname =
          prefs.getString('selected_project_name').toString();

      //Selecting the project name to fetch its users
      final String projectname =
          selectedprojectname.isEmpty ? firstProject : selectedprojectname;

      //retrieve the users
      final response = await supabase
          .from('users')
          .select()
          .eq('project_name', projectname)
          .order('user_name');
      if (response.isEmpty) {
        return [];
      }
      final project_users =
          (response as List).map((json) => users.fromJson(json)).toList();
      return project_users;
    } catch (error) {
      return [];
    }
  }

  Future<List<bugs>> getBugsForProject(
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    try {
      //to retrieve selected project name from shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String selectedprojectname =
          prefs.getString('selected_project_name').toString();

      //Selecting the project name to fetch its users
      final String finalprojectname =
          selectedprojectname.isEmpty ? firstProject : selectedprojectname;
      //retrieve the bugs table content
      final response = await supabase
          .from('bugs')
          .select()
          .eq('project_name', finalprojectname)
          .order('bugs_name');

      final project_bugs =
          (response as List).map((json) => bugs.fromJson(json)).toList();
      return project_bugs;
    } catch (error) {
      return [];
    }
  }

  //chat retrieval function
  Future<List<chats_model>> getChats(
    BuildContext context,
    SupabaseClient supabase,
    String selectedprojectname,
  ) async {
    //Selecting the project name to fetch its users
    final String finalprojectname =
        selectedprojectname.isEmpty ? firstProject : selectedprojectname;
    try {
      final response = await supabase
          .from('chats')
          .select()
          .eq('project_name', finalprojectname)
          .order('date');

      final project_chats =
          (response as List).map((json) => chats_model.fromJson(json)).toList();
      return project_chats;
    } catch (error) {
      return [];
    }
  }

  // //Function to search a term in User table
  // Future<List<users>> searchInUserTable(
  //   //var column1,
  //   String query,
  //   BuildContext context,
  //   SupabaseClient supabase,
  // ) async {
  //   try {
  //     var response =
  //         await supabase.from('users').select().textSearch('user_name', query);

  //     var response2 =
  //         (response.toList()).map((json) => users.fromJson(json)).toList();
  //     return response2; //as List<project>
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // //Function to search a term in Project table
  // Future<List<project>> searchInProjectTable(
  //   String query,
  //   BuildContext context,
  //   SupabaseClient supabase,
  // ) async {
  //   try {
  //     var response = await supabase
  //         .from('projects')
  //         .select()
  //         .textSearch('project_name', query);

  //     var response2 =
  //         (response.toList()).map((json) => project.fromJson(json)).toList();
  //     return response2; //as List<project>
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // //Function to search a term in Bugs table
  // Future<List<bugs>> searchInBugsTable(
  //   String query,
  //   BuildContext context,
  //   SupabaseClient supabase,
  // ) async {
  //   try {
  //     var response =
  //         await supabase.from('bugs').select().textSearch('bugs_name', query);
  //     var response2 =
  //         (response.toList()).map((json) => bugs.fromJson(json)).toList();
  //     return response2; //as List<project>
  //   } catch (e) {
  //     return [];
  //   }
  // }

  //Function to search a term in Bugs table
  Future<List<Search>> search({
    required String tablename,
    required String columnname,
    required String query,
    required BuildContext context,
    required SupabaseClient supabase,
  }) async {
    try {
      print('Searched items in try:$tablename, $columnname,$query');
      var response = await supabase
          .from('$tablename')
          .select()
          .textSearch(columnname, query);
      var response2 =
          (response.toList()).map((json) => Search.fromJson(json)).toList();
          print('Searched items:${response2[0].projectName}');
      return response2; //as List<project>
    } catch (e) {
      return [];
    }
  }
}
