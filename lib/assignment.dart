import 'package:flutter/material.dart';
import 'package:sam_mobile/dashboard.dart';
import 'package:sam_mobile/parse.dart';

Map assign;

class Assignment extends StatelessWidget {
  Assignment({this.assignment});
  final Map assignment;

  static String routeName = "assignment";

  @override
  Widget build(BuildContext context) {
    assign = assignment;
    return new MaterialApp(
      title: "Assignment",
      home: new AssignmentHome(),
      routes: <String, WidgetBuilder> {
        Dashboard.routeName : (BuildContext context) => new Dashboard(),
      },
    );
  }
}

class AssignmentHome extends StatefulWidget {
  @override
  State createState() => new AssignmentState();
}

class AssignmentState extends State<AssignmentHome>{
  final String className = assign["class"];
  final String subject = capitalize(assign["subject"]);
  final String state = assign["type"] == "1" ? "Assignment" : "Information";
  final String content = assign["content"];
  final String attachment = assign["attachment"];
  final String pubDate = assign["publish"];
  final String dueDate = assign["dueday"];

  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(subject),
        leading: new IconButton(
          icon: const BackButtonIcon(),
          tooltip: 'Back',
          onPressed: () {
            Navigator.popAndPushNamed(context, Dashboard.routeName);
          },
        )
      ),
      body: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("$state from $className"),
            new Text(content),
            new Text("Publish Date: $pubDate"),
            new Text("Due Date: $dueDate"),
          ],
        ),
      ),
    );
  }
}