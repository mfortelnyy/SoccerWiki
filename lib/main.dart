import 'package:flutter/material.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/HomeScreen.dart';
import 'package:mp5/views/LoginScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SoccerO',
    home: Start()
  ));
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late bool isLoggedIn = false;
  String username ="";
 

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }


  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    if(loggedIn){
      username = (await SessionManager.getUsername())!;
      
    }
    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoccerO',
      home: isLoggedIn ? HomeScreen(username: username,) : const LoginScreen()
    );
  }
}

