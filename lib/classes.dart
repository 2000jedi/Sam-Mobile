import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sam_mobile/dashboard.dart';
import 'package:sam_mobile/class.dart';
import 'package:sam_mobile/parse.dart';

Map classData;

class Classes extends StatelessWidget {
  static String routeName = "classes";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "System of Assignment Manager",
      home: new ClassesHome(),
      routes: <String, WidgetBuilder> {
        Dashboard.routeName : (BuildContext context) => new Dashboard(),
        Class.routeName: (BuildContext context) => new Class(data: classData),
      },
    );
  }
}

class ClassesHome extends StatefulWidget {
  @override
  State createState() => new ClassesState();
}

class ClassesState extends State<ClassesHome>{
  final List<ClassesContent> _content = <ClassesContent>[];

  @override
  initState(){
    _content.clear();
    insertMessages();

    super.initState();
  }

  Widget build(BuildContext context) {
    const TextStyle navi_style = const TextStyle(fontSize: 16.0, fontFamily: "Consolas");

    var naviHeader = new DrawerHeader(child: new Text("Apps", style: navi_style));
    var dashboard = new ListTile(title: const Text("Dashboard", style: navi_style), leading: const Icon(Icons.dashboard), onTap: () {Navigator.popAndPushNamed(context, Dashboard.routeName);});
    var classes = new ListTile(title: const Text("Classes", style: navi_style), leading: const Icon(Icons.class_), onTap: () {Navigator.pop(context);});
    var naviChild = [naviHeader, dashboard, classes];
    Drawer navi = new Drawer(child: new ListView(children: naviChild));

    return new Scaffold(
      appBar: new AppBar(title: new Text("Classes")),
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
    var json = await parseGet("https://wflmssam.sinaapp.com/modules/class/loadClass.php");
    var data = JSON.decode(json);
    for (var elem in data) {
      setState(() {
        _content.add(new ClassesContent(raw: elem, name: elem["name"], subject: capitalize(elem["subject"]),));
      });
    }
  }
}


class ClassesContent extends StatelessWidget {
  ClassesContent(
      {this.raw, this.name, this.subject});

  final Map raw;
  final String name;
  final String subject;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        classData = raw;
        Navigator.pushNamed(context, Class.routeName);
      },
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(subject[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(subject, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(name),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
