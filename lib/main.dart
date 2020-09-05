import 'package:laugh/test.dart';

import 'screens/wrapper.dart';
import 'services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: TestApp(),
        // Wrapper(),
      ),
    );
  }
}
