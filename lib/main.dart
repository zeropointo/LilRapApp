import 'package:flutter/material.dart';

import 'features/artist_list/presentation/pages/rapper_list_page.dart';
import 'features/artist_list/presentation/pages/rapper_profile_page.dart';
import 'injection_container.dart' as inject;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inject.init();
  runApp(MyApp());
}

/// Builds a MaterialApp with routes to 2 pages.
///
/// 1. /list - A list of rapper people.
/// 2. /profile - The expanded profile of a rapper person.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LilRapApp',
      initialRoute: '/list',
      routes: <String, WidgetBuilder>{
        RapperListPage.routeName: (context) => RapperListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == RapperProfilePage.routeName) {
          final rapperId = settings.arguments as String;

          return MaterialPageRoute(builder: (context) {
            return RapperProfilePage(rapperId: rapperId);
          });
        }
      },
    );
  }
}
