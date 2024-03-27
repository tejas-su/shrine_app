// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:project_management/models/bugs_model.dart';
import 'package:project_management/models/chats_model.dart';
import 'package:project_management/models/projects_model.dart';
import 'package:project_management/models/users_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/imports.dart';

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

//retrieve the group name from local storage
final Storage localStorage = window.localStorage;
var groupName = localStorage['groupName'];

//retrieve the selected project name from local storage
var projectName = localStorage['projectName'];

class HelperFunctions {
  Future<List<project>> getProjects(BuildContext context,
      SupabaseClient supabase, selectedprojectname) async {
    try {
      //groupName is name of team that login into website so to fetch corresponding teams details
      final response = await supabase
          .from('projects')
          .select('*')
          .eq('team_name', '$groupName')
          .order('project_name');

      final projects =
          (response as List).map((json) => project.fromJson(json)).toList();

      if (response.isEmpty) {
        return [];
      }

      return projects;
    } catch (error) {
      //return empty
      return [];
    }
  }

  Future<List<users>> getUsersForProject(BuildContext context,
      SupabaseClient supabase, selectedprojectname) async {
    try {
      //Default:To fetch first project name  and its details
      var projects = await getProjects(context, supabase, selectedprojectname);
      var firstProject = projects[0];
      String firstProjectName = firstProject.projectName.toString();

      //Selecting the project name to fetch its users
      final String projectname =
          selectedprojectname.isEmpty ? firstProjectName : selectedprojectname;

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
    String selectedprojectname,
  ) async {
    try {
      //Default:To fetch first project name  and its details
      var projects = await getProjects(context, supabase, selectedprojectname);
      var firstProject = projects[0];
      String firstProjectName = firstProject.projectName.toString();

      //Selecting the project name to fetch its users
      final String finalprojectname =
          selectedprojectname.isEmpty ? firstProjectName : selectedprojectname;
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
      // showErrorDialog(context, error.toString());
      return [];
    }
  }

  //chat retrieval function
  Future<List<chats_model>> getChats(
    BuildContext context,
    SupabaseClient supabase,
    String selectedprojectname,
  ) async {
    //Default:To fetch first project name  and its details
    var projects = await getProjects(context, supabase, selectedprojectname);
    var firstProject = projects[0];
    String firstProjectName = firstProject.projectName.toString();

    //Selecting the project name to fetch its users
    final String finalprojectname =
        selectedprojectname.isEmpty ? firstProjectName : selectedprojectname;
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
      // showErrorDialog(context, error.toString());
      return [];
    }
  }

  //Function to search a term in User table
  Future<List<users>> searchInUserTable(
    //var column1,
    String query,
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    try {
      var response =
          await supabase.from('users').select().textSearch('user_name', query);

      var response2 =
          (response.toList()).map((json) => users.fromJson(json)).toList();
      return response2; //as List<project>
    } catch (e) {
      return [];
    }
  }

  //Function to search a term in Project table
  Future<List<project>> searchInProjectTable(
    String query,
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    try {
      var response = await supabase
          .from('projects')
          .select()
          .textSearch('project_name', query);

      var response2 =
          (response.toList()).map((json) => project.fromJson(json)).toList();
      return response2; //as List<project>
    } catch (e) {
      return [];
    }
  }

  //Function to search a term in Bugs table
  Future<List<bugs>> searchInBugsTable(
    String query,
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    try {
      var response =
          await supabase.from('bugs').select().textSearch('bugs_name', query);
      var response2 =
          (response.toList()).map((json) => bugs.fromJson(json)).toList();
      return response2; //as List<project>
    } catch (e) {
      return [];
    }
  }
}
