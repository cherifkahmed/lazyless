import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:lazyless/screens/user/phone_usage/mark_app.dart';


class ListApps extends StatelessWidget {
  const ListApps({super.key});

  Future<List<AppInfo>> getInstalledApps() {
    return InstalledApps.getInstalledApps(true, true, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installed Apps")),
      body: FutureBuilder<List<AppInfo>>(
        future: getInstalledApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No apps found."));
          }

          final apps = snapshot.data!;
          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: app.icon != null ? Image.memory(app.icon!, width: 40, height: 40) : null,
                  title: Text(app.name),
                  subtitle: Text(app.packageName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarkApp(
                          appName: app.name,
                          appPackageName: app.packageName,
                          appIcon: app.icon!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
