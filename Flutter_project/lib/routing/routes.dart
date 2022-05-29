import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/edit.dart';
import '../theme/colors.dart';

class Routes {
  static Route<dynamic> routeGenerator(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Home());
      case '/edit':
        return MaterialPageRoute(
            builder: (context) => Edit(settings.arguments));
      default:
        return _unknownRoute();
    }
  }
}

Route<dynamic> _unknownRoute() {
  return MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No such route'),
      ),
      body: Center(
        child: Text('Sorry, but no such route exists. Try again!'),
      ),
    );
  });
}
