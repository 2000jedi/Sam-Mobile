import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sam_mobile/assignment.dart';
import 'package:sam_mobile/classes.dart';
import 'package:sam_mobile/parse.dart';

Map classData;
Map assignment;

class Class extends StatelessWidget {
  Class({this.data});
  final Map data;

  static String routeName = "class";

  @override
  Widget build(BuildContext context) {
    classData = data;
    return new MaterialApp(
      title: "Class",
      home: new ClassHome(),
      routes: <String, WidgetBuilder> {
        Assignment.routeName: (BuildContext context) => new Assignment(assignment: assignment),
        Classes.routeName : (BuildContext context) => new Classes(),
      },
    );
  }
}

class ClassHome extends StatefulWidget {
  @override
  State createState() => new ClassState();
}

class ClassState extends State<ClassHome>{
  final String id = classData["id"];
  final String name = classData["name"];
  final String subject = capitalize(classData["subject"]);

  final List<ClassAssignmentContent> _content = <ClassAssignmentContent>[];

  @override
  initState() {
    _content.clear();
    insertMessages();
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("$name"),
          leading: new IconButton(
            icon: const BackButtonIcon(),
            tooltip: 'Back',
            onPressed: () {
              Navigator.popAndPushNamed(context, Classes.routeName);
            },
          )
      ),
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
    var json = await parseGet("https://wflmssam.sinaapp.com/modules/assignment/classLoadAssignment.php?class=$id");
    var data = JSON.decode(json);
    for (var elem in data){
      String state = elem["type"] == "1" ? "Assignment" : "Information";

      setState(() {
        _content.add(new ClassAssignmentContent(
          raw: elem,
          state: state,
          subject: capitalize(elem["subject"]),
          teacher: elem["teacher"],
          content: elem["content"],
          pubdate: parseTime(elem["publish"]),
          duedate: parseTime(elem["dueday"]),
        ));
      });
    }
  }
}


class ClassAssignmentContent extends StatelessWidget {
  ClassAssignmentContent(
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
