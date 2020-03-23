import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './theme_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

var notetitle = TextEditingController();
var notebody = TextEditingController();

Map<String, String> originalData = {};
Map<String, String> modifiedData = {};

void main() {
  runApp(
    ChangeNotifierProvider<DynamicTheme>(
      create: (_) => DynamicTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isModified = false;
  void reading() {
    if (originalData ==
        {
          '1t': 'Notes 1',
          '1b': 'Notes1Body',
          '2t': 'Notes 2',
          '2b': 'Notes2Body',
          '3t': 'Notes 3',
          '3b': 'Notes3Body',
          '4t': 'Notes 4',
          '4b': 'Notes4Body',
          '5t': 'Notes 5',
          '5b': 'Notes5Body',
        }) {
      setState(() {
        isModified = false;
      });
    } else {
      setState(() {
        isModified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return MaterialApp(
      theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.network(
                  'https://avatars2.githubusercontent.com/u/60510869?s=460&u=ea7872a9aa9189cfc2b0910a51e4b83d458709a3&v=4',
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.cyanAccent[200],
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Center(
                  child: Text('CodeNameAKshay'),
                ),
                onTap: () {},
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Enable Dark Mode'),
                    Switch(
                      value: themeProvider.getDarkMode(),
                      onChanged: (value) {
                        setState(() {
                          themeProvider.changeDarkMode(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Notes"),
        ),
        body: isModified
            ? Body1(
                1,
                modifiedData,
                reading,
              )
            : Body1(1, originalData, reading),
      ),
    );
  }
}

class Body1 extends StatefulWidget {
  int isClicked;
  Map<String, String> notesMap;
  Function reading;
  Body1(this.isClicked, this.notesMap, this.reading);
  _Body1State createState() =>
      _Body1State(this.isClicked, this.notesMap, this.reading);
}

class _Body1State extends State<Body1> {
  var isClicked1;
  var notesMap1;
  Function reading;
  var currentNoteTitle;
  var currentNoteBody;
  _Body1State(this.isClicked1, this.notesMap1, this.reading);
  void setIsClicked(var valueIsClicked) {
    setState(
      () {
        isClicked1 = valueIsClicked;
      },
    );
  }

  void showNote(var notekey, var notevalue) {
    currentNoteTitle = notekey;
    currentNoteBody = notevalue;
  }

  String getNoteTitle() {
    return currentNoteTitle;
  }

  String getNoteBody() {
    return currentNoteBody;
  }

  void updateNotesMap(String noteTitle, String noteBody) {
    // setState(
    //   () {
    var l1 = ((notesMap1.length ~/ 2) + 1).toString();
    notesMap1.addAll({l1 + 't': noteTitle, l1 + 'b': noteBody});
    originalData = notesMap1;
    modifiedData = notesMap1;
    reading();

    // },
    // );
  }

  void delNotesMap(String noteTitle, String noteBody) {
    notesMap1.removeWhere((k, v) => v == noteTitle);
    notesMap1.removeWhere((k, v) => v == noteBody);
    print(notesMap1);
    originalData = notesMap1;
    modifiedData = notesMap1;
    reading();
  }

  Map getNotesMap() {
    return notesMap1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Screen1(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          func: setIsClicked,
          func2: getNotesMap,
          func3: showNote,
          func4: updateNotesMap,
          func5: getNoteTitle,
          func6: getNoteBody,
          func7: reading,
          func8: delNotesMap,
        );
      },
    );
  }
}

class Screen1 extends StatefulWidget {
  final double width;
  final double height;
  final Function func;
  final Function func2;
  final Function func3;
  final Function func4;
  final Function func5;
  final Function func6;
  final Function func7;
  final Function func8;

  Screen1({
    this.width,
    this.height,
    this.func,
    this.func2,
    this.func3,
    this.func4,
    this.func5,
    this.func6,
    this.func7,
    this.func8,
  });
  @override
  _Screen1State createState() => _Screen1State(
        width1: width,
        height1: height,
        func1: func,
        func2: func2,
        func3: func3,
        func4: func4,
        func5: func5,
        func6: func6,
        func7: func7,
        func8: func8,
      );
}

class Screen2 extends StatefulWidget {
  final double width;
  final double height;
  final Function func;
  final Function func2;
  Screen2({this.width, this.height, this.func, this.func2});
  @override
  _Screen2State createState() =>
      _Screen2State(width2: width, height2: height, func1: func, func2: func2);
}

class Screen3 extends StatefulWidget {
  final double width;
  final double height;
  final Function func;
  final Function func2;
  final Function func3;
  final Function func4;
  Screen3(
      {this.width, this.height, this.func, this.func2, this.func3, this.func4});
  @override
  _Screen3State createState() => _Screen3State(
        width3: width,
        height3: height,
        func: func,
        func2: func2,
        func3: func3,
        func4: func4,
      );
}

class _Screen1State extends State<Screen1> {
  double width1;
  double height1;
  Function func1;
  Function func2;
  Function func3;
  Function func4;
  Function func5;
  Function func6;
  Function func7;
  Function func8;
  Map notes;
  List notestitle = [];
  List notesbody = [];
  _Screen1State({
    this.width1,
    this.height1,
    this.func1,
    this.func2,
    this.func3,
    this.func4,
    this.func5,
    this.func6,
    this.func7,
    this.func8,
  }) {
    notes = func2();
    for (var i = 1; i <= notes.length; i++) {
      notestitle.add(notes[i.toString() + 't']);
      notesbody.add(notes[i.toString() + 'b']);
    }
    notestitle.removeWhere((value) => value == null);
    notestitle.removeWhere((value) => value == '');
    notesbody.removeWhere((value) => value == null);
    notesbody.removeWhere((value) => value == '');
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to exit the app?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Screen2(
                  width: width1,
                  height: height1,
                  func: func1,
                  func2: func4,
                );
              }));
            },
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 24.0000000000,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            alignment: Alignment.topLeft,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: ((notestitle.length)),
              itemBuilder: (BuildContext context, int index) {
                // String key1 = notestitle.keys.elementAt(index);
                // String key2 = notesbody.keys.elementAt(index);
                return new Column(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: new Text('${notestitle[index].toString()}'),
                        subtitle: new Text('${notesbody[index].toString()}'),
                        // trailing: Icon(
                        //   Icons.more_vert,
                        // ),
                        onLongPress: () {
                          HapticFeedback.vibrate();
                          func8('${notestitle[index].toString()}',
                              '${notesbody[index].toString()}');
                          // setState(() {
                          //   notestitle.removeAt(index);
                          //   notesbody.removeAt(index);
                          // });
                          // notestitle[index] = '';
                          // notesbody[index] = '';
                          // func7();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MyApp();
                          }));
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                HapticFeedback.vibrate();
                                func3('${notestitle[index].toString()}',
                                    '${notesbody[index].toString()}');
                                return Screen3(
                                  width: width1,
                                  height: height1,
                                  func: func1,
                                  func2: func5,
                                  func3: func6,
                                  func4: func7,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // new Divider(
                    //   height: 2.0,
                    // ),
                  ],
                );
              },
            ),
          )),
    );
  }
}

class _Screen2State extends State<Screen2> {
  double width2;
  double height2;
  Function func1;
  Function func2;
  var notesMap = {};
  _Screen2State({this.width2, this.height2, this.func1, this.func2});

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            'Do you really want to go back?\nNote - This note will not be saved'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              notetitle.text = '';
              notebody.text = '';
              func1(1);
              Navigator.pop(context, true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MaterialApp(
          theme: themeProvider.getDarkMode()
              ? ThemeData.dark()
              : ThemeData.light(),
          home: Scaffold(
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Image.network(
                        'https://avatars2.githubusercontent.com/u/60510869?s=460&u=ea7872a9aa9189cfc2b0910a51e4b83d458709a3&v=4',
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.cyanAccent[200],
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Text('CodeNameAKshay'),
                      ),
                      onTap: () {},
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Enable Dark Mode'),
                          Switch(
                            value: themeProvider.getDarkMode(),
                            onChanged: (value) {
                              setState(() {
                                themeProvider.changeDarkMode(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text("Create Note"),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: () {
                  func2(notetitle.text, notebody.text);
                  notetitle.text = '';
                  notebody.text = '';
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
              body: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: notetitle,
                      // autofocus: true,
                      style: TextStyle(
                        fontFamily: 'Altasi',
                        fontSize: 20.0000000000,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter title...'),
                    ),
                    Container(
                      height: height2 * 0.3,
                      child: TextField(
                        controller: notebody,
                        style: TextStyle(
                          fontFamily: 'Altasi',
                          fontSize: 18.0000000000,
                        ),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Start writing your note here...'),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}

class _Screen3State extends State<Screen3> {
  double width3;
  double height3;
  Function func;
  Function func2;
  Function func3;
  Function func4;
  String currentNotesT;
  String currentNotesB;
  _Screen3State(
      {this.width3,
      this.height3,
      this.func,
      this.func2,
      this.func3,
      this.func4}) {
    currentNotesT = func2();
    currentNotesB = func3();
  }
  // Future<bool> _onBackPressed() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //           'Do you want to go back?'),
  //       actions: <Widget>[
  //         FlatButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text('No'),
  //         ),
  //         FlatButton(
  //           onPressed: () {
  //             Navigator.pop(context, true);
  //           },
  //           child: Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return MaterialApp(
      theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
      home: WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image.network(
                    'https://avatars2.githubusercontent.com/u/60510869?s=460&u=ea7872a9aa9189cfc2b0910a51e4b83d458709a3&v=4',
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.cyanAccent[200],
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Center(
                    child: Text('CodeNameAKshay'),
                  ),
                  onTap: () {},
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Enable Dark Mode'),
                      Switch(
                        value: themeProvider.getDarkMode(),
                        onChanged: (value) {
                          setState(() {
                            themeProvider.changeDarkMode(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Notes"),
          ),
          body: Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(width3 * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentNotesT,
                    style: TextStyle(
                      fontFamily: 'Altasi',
                      fontSize: 24.0000000000,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    thickness: width3 * 0.01,
                    height: 2.0,
                  ),
                  Text(
                    currentNotesB,
                    style: TextStyle(
                      fontFamily: 'Altasi',
                      fontSize: 18.0000000000,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
