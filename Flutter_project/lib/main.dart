import 'package:flutter/material.dart';

import '../routing/routes.dart';

void main() async {
  runApp(new AppEntry());
}

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Routes.routeGenerator,
    );
  }
}
