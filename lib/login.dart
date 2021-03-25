import 'package:note_flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/Note.dart';
import 'Models/Server.dart';
import 'package:flutter/material.dart';
import 'Models/User.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {
  final username = TextEditingController();
  User user = new User();
  Server server = new Server();

  final password = TextEditingController();
  
  @override
  void initState() {
    checkLogin(context);
    super.initState();
  }

  void login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    user = await server.login(username.text, password.text);
    if (user.username != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new NoteOverview(user: user)));

      prefs.setString('user_id', user.id.toHexString());
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("username or password wrong"),
            );
          });
    }
  }

  void register() {
    Server server = new Server();
    User user = new User();
    user.username = username.text;
    user.name = username.text;
    user.password = password.text;

    user.notes = <Note>[];
    server.registerNewUser(user);
  }

  void checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? false;

    if (userId != false) {
      user = await server.loginWithId(userId);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new NoteOverview(user: user)));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D416F),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: username,
              decoration: InputDecoration(
                labelText: "Username",
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF21E6C1),
                    ),
                    child: Text('register'),
                    onPressed: () => {register()},
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF21E6C1),
                    ),
                    child: Text('Login'),
                    onPressed: () => {login(context)},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
