import 'package:flutter/material.dart';
import 'package:mp5/models/user.dart';
import 'package:mp5/utils/database_helper.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/HomeScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text("Invalid credentials"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _signIn(BuildContext context) async {
    final username = _usernameontroller.text;
    final password = _passwordController.text;
    final dbHelper = DBHelper();

    final user = await dbHelper.getUserByUsername(username);
    
    if (user != null && user.password == password) {
      await SessionManager.setUsername(username);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: username,),
        ),
      );
    } else {
      _showErrorDialog('Invalid email or password');
    }
  }

  void _signUp(BuildContext context) async {
    final username = _usernameontroller.text;
    final password = _passwordController.text;
    final dbHelper = DBHelper();

    User u = User(username: username, password: password);

    if(username.isNotEmpty && password.isNotEmpty){
      int res = await dbHelper.insertUser(u);
      if(res !=0){
        await SessionManager.setUsername(username);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(username: username,),
          ),
        );
      }
    }
    else {
      _showErrorDialog('Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameontroller,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () => _signIn(context),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}