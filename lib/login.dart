import 'package:flutter/material.dart';
import 'package:sam_mobile/dashboard.dart';
import 'package:sam_mobile/parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  static String routeName = "login";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "System of Assignment Manager",
      home: new LoginNavi(),
      routes: <String, WidgetBuilder>{
        Dashboard.routeName: (BuildContext context) => new Dashboard(),
      },
    );
  }
}


class LoginNavi extends StatefulWidget {
  @override
  State createState() => new DashboardState();
}


class DashboardState extends State<LoginNavi> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _cookie = "";
  String _username;
  String _password;

  Widget builder(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          new TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: "username",
            ),
            onSaved: (String username) {
              _username = username;
            },
            maxLines: 1,
          ),
          new TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: "password",
            ),
            obscureText: true,
            onSaved: (String password) {
              _password = password;
            },
            maxLines: 1,
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            alignment: const FractionalOffset(0.5, 0.5),
            child: new RaisedButton(
              child: const Text('Login'),
              onPressed: () {
                setState(() {
                  final FormState form = _formKey.currentState;
                  form.save();
                  _cookie = "username=$_username; password=$_password";
                  Parse.cookie = _cookie;
                  // TODO: Validation
                  parseGet(
                      "https://wflmssam.sinaapp.com/modules/user/checkValidWithoutInput.php")
                      .then((data) {
                    if (data == "1") {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('cookie', Parse.cookie);
                      });
                      Navigator.popAndPushNamed(context, Dashboard.routeName);
                    } else {
                      Scaffold.of(context).showSnackBar(
                        new SnackBar(
                          content: new Text(
                              "Invalid Username or Password")
                        )
                      );
                    }
                  });
                });
              },
            ),
          ),
        ]
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Login")),
      body: new Builder(
        builder: builder,
      )
    );
  }
}