import 'package:flutter/material.dart';
import 'package:jh_mobile/src/authentication/_authentication_lib.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SENAI',
      builder: (context, child) {
        return SafeArea(
          child: child!,
        );
      },
      home: Wrapper(),
    );
  }
}
