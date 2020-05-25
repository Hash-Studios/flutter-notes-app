import 'package:flutter/material.dart';

Map<String, Map<String, String>> notes = {
  "n1": {"heading": "A", "body": "B"},
  "n2": {"heading": "A", "body": "B"},
  "n3": {"heading": "A", "body": "B"},
  "n4": {"heading": "A", "body": "B"},
  "n5": {"heading": "A", "body": "B"},
  "n6": {"heading": "A", "body": "B"},
  "n7": {"heading": "A", "body": "B"},
  "n8": {"heading": "A", "body": "B"},
  "n9": {"heading": "A", "body": "B"},
  "n10": {"heading": "A", "body": "B"},
  "n11": {"heading": "A", "body": "B"},
  "n12": {"heading": "A", "body": "B"},
  "n13": {"heading": "A", "body": "B"},
  "n14": {"heading": "A", "body": "B"},
  "n15": {"heading": "A", "body": "B"},
  "n16": {"heading": "A", "body": "B"},
};

List heads = [];
List bodies = [];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    notes.forEach((key, value) {
      heads.add(value["heading"]);
      bodies.add(value["body"]);
      // print(heads);
      // print(bodies);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("CREATE"),
          icon: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Notes"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: heads.length,
              itemBuilder: (BuildContext context, int index) => Card(
                    child: ListTile(
                      title: Text(heads[index]),
                      subtitle: Text(bodies[index]),
                      leading: Icon(Icons.edit),
                    ),
                  )),
        ),
      ),
    );
  }
}
