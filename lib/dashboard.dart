import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sam_mobile/classes.dart';
import 'package:sam_mobile/parse.dart';
import 'package:sam_mobile/assignment.dart';
import 'package:sam_mobile/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map assignment;

class Dashboard extends StatelessWidget {
  static String routeName = "dashboard";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "System of Assignment Manager",
      home: new DashboardNavi(),
      routes: <String, WidgetBuilder>{
        Classes.routeName: (BuildContext context) => new Classes(),
        Assignment.routeName: (BuildContext context) => new Assignment(assignment: assignment),
        Login.routeName: (BuildContext context) => new Login(),
      },
    );
  }
}

class DashboardNavi extends StatefulWidget {
  @override
  State createState() => new DashboardState();
}

class DashboardState extends State<DashboardNavi> {
  final List<DashboardContent> _content = <DashboardContent>[];

  @override
  initState() {
    _content.clear();
    insertMessages();
    super.initState();
  }

  Widget build(BuildContext context) {
    const TextStyle navi_style = const TextStyle(
        fontSize: 16.0, fontFamily: "Consolas");
    var naviHeader = new DrawerHeader(
        child: new Text("Apps", style: navi_style));
    var dashboard = new ListTile(
      title: const Text("Dashboard", style: navi_style),
      leading: const Icon(Icons.dashboard),
      onTap: () {
        Navigator.pop(context);
      }
    );
    var classes = new ListTile(
        title: const Text("Classes", style: navi_style),
        leading: const Icon(Icons.class_),
        onTap: () {
          Navigator.popAndPushNamed(context, Classes.routeName);
        }
    );
    var logout = new ListTile(
        title: const Text("Log Out", style: navi_style),
        leading: const Icon(Icons.exit_to_app),
        onTap: () {
          SharedPreferences.getInstance().then((prefs){prefs.setString('cookie', "");});
          Navigator.popAndPushNamed(context, Login.routeName);
        }
    );
    var naviChild = [naviHeader, dashboard, classes, logout];
    Drawer navi = new Drawer(child: new ListView(children: naviChild));

    return new Scaffold(
      appBar: new AppBar(title: new Text("Dashboard")),
      drawer: navi,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _content[index],
              itemCount: _content.length,
            ),
          ),
        ]
      ),
    );
  }

  insertMessages() async {
    var json = await parseGet(
        "http://wflmssam.sinaapp.com/modules/dashboard/getDashboard.php");
    var data = JSON.decode(json);
    for (var elem in data) {
      String state = elem["type"] == "1" ? "Assignment" : "Information";

      setState(() {
        _content.add(new DashboardContent(
          raw: elem,
          state: state,
          subject: capitalize(elem["subject"]),
          teacher: elem["teacher"],
          content: elem["content"],
          pubdate: parseTime(elem["publish"]),
          duedate: parseTime(elem["dueday"])
        ));
      });
    }
  }
}

class DashboardContent extends StatelessWidget {
  DashboardContent(
      {this.raw, this.state, this.subject, this.teacher, this.content, this.pubdate, this.duedate});

  final Map raw;
  final String state;
  final String subject;
  final String teacher;
  final String content;
  final DateTime pubdate;
  final DateTime duedate;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        assignment = raw;
        Navigator.pushNamed(context, Assignment.routeName);
      },
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(state[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(subject, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(content.split("\n")[0]),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
