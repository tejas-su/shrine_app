import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_management/presentation/screens/imports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../themes/themes.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    List images = [
      "assets/avatars/man (1).png",
      "assets/avatars/man (2).png",
      "assets/avatars/man (3).png",
      "assets/avatars/man (4).png",
      "assets/avatars/man (5).png",
    ];
    final supabase = Supabase.instance.client;

    return FutureBuilder(
        future: supabase.from('projects').select(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Lottie.asset('lottie/ani1.json', height: 500);
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text("Oops, something went wrong"),
              content: Text('${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          } else {
            final data = snapshot.data as List<dynamic>;
            return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3,
                  crossAxisCount: 3,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final projectdata = data[index] as Map<String, dynamic>;
                  return Card(
                    elevation: 0.2,
                    color: whiteContainer,
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
                                images[Random().nextInt(5)],
                              ),
                            ),
                            title: Text("${projectdata['project_name']}"),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, left: 25, bottom: 2),
                          child: Text("Team :${projectdata['team_name']} "),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 25, bottom: 2),
                          child: Text('Description: ${projectdata['project_description']}',overflow:TextOverflow.ellipsis,
                          softWrap: true,),
                        )
                      ],
                    ),
                  );
                });
          }
        });
  }
}
