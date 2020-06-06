import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tizeno/ui/about.dart';
import 'package:tizeno/screens/picnote_page.dart';
import 'package:tizeno/ui/staggered_page.dart';
import 'package:tizeno/data/notes.dart';
import 'package:tizeno/screens/note_page.dart';
import 'package:tizeno/data/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tizeno/data/SqliteHandler.dart';

enum viewType { List, Staggered }

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var notesViewType;

  @override
  void initState() {
    notesViewType = viewType.Staggered;
    super.initState();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light,
        actions: _appBarActions(),
        elevation: 0,
        backgroundColor: Colors.amber,
        // centerTitle: true,
        title: Text(
          "Tizeno",
          style: GoogleFonts.montserrat(color: Colors.black),
        ),
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              //   boxShadow: [
              //   BoxShadow(
              //       color: Colors.orange.withOpacity(0.8),
              //       blurRadius: 20,
              //       spreadRadius: 0,
              //       offset: Offset(0, 4))
              // ],
              borderRadius: BorderRadius.circular(100)),
          child: Hero(
            tag: 'FAB',
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 80,
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(5, 14, 0, 14),
                      key: Key('NewNote'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100))),
                      color: Colors.orange,
                      // elevation: 0,
                      onPressed: () => _newNoteTapped(context),
                      child: Icon(
                        LineAwesomeIcons.edit,
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: 60,
                    width: 2,
                  ),
                  SizedBox(
                    width: 80,
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(0, 14, 5, 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100))),
                      color: Colors.orange,
                      // elevation: 0,
                      onPressed: () => _newPhotoNoteTapped(context),
                      child: Icon(LineAwesomeIcons.file_image_o, size: 32),
                    ),
                  ),
                ],
              ),
            ),
          )
          // FloatingActionButton.extended(
          //   heroTag: 'FAB',
          //   elevation: 0,
          //   onPressed: () => _newNoteTapped(context),
          //   label: Text("CREATE"),
          //   icon: Icon(Icons.add),
          // ),
          ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Stack(
                children: <Widget>[
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     color: Colors.amber,
                  //     child: SizedBox(
                  //       width: 20.w,
                  //       height: 20.h,
                  //       child: Text(''),
                  //     ),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: SizedBox(
                  //       width: 20.w,
                  //       height: 20.h,
                  //     ),
                  //   ),
                  // ),
                  Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //   topRight: Radius.circular(15),
                        // ),
                        // border: Border.all(color: Colors.black, width: 2),
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 2),
                          top: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      height: 1440.h,
                      // width: 604.5.w,
                      child: Center(
                        child: Text(''),
                      )),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 2, 2, 0),
                  //   child: Align(
                  //     alignment: Alignment.bottomLeft,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         border: Border(
                  // left: BorderSide(color: Colors.white, width: 3),
                  // bottom: BorderSide(color: Colors.white, width: 3),
                  //         ),
                  //       ),
                  //       child: Center(
                  //         child: Text(''),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: SafeArea(
                      child: _body(),
                      right: true,
                      left: true,
                      top: true,
                      bottom: true,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: NavigationRail(
                  unselectedIconTheme: IconThemeData(color: Colors.black87),
                  selectedIconTheme: IconThemeData(color: Colors.black),
                  labelType: NavigationRailLabelType.selected,
                  backgroundColor: Colors.amber,
                  onDestinationSelected: (int index) {
                    if (index != 4 || index != 5) {
                      setState(() {
                        CentralStation.updateNeeded = true;
                        _selectedIndex = index;
                      });
                    }
                  },
                  trailing: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                            icon: Icon(
                              LineAwesomeIcons.trash_o,
                              size: 30,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm ?"),
                                      content: Text(
                                          "All notes will be deleted permanently and the app will quit."),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () async {
                                              final dir = Directory(
                                                  'storage/emulated/0/Tizeno');
                                              dir.deleteSync(recursive: true);
                                              await NotesDBHandler().deleteDB();
                                              await NotesDBHandler().initDB();
                                              CentralStation.updateNeeded =
                                                  true;
                                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                            },
                                            child: Text("Yes")),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No"))
                                      ],
                                    );
                                  });

                              setState(() {});
                            }),
                      ),
                      AboutButton(),
                    ],
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(
                        LineAwesomeIcons.sticky_note_o,
                        size: 30,
                      ),
                      selectedIcon: FaIcon(
                        FontAwesomeIcons.solidStickyNote,
                        color: Colors.black,
                      ),
                      label: Text(
                        'All',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.black),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        LineAwesomeIcons.star_o,
                        size: 30,
                      ),
                      selectedIcon: FaIcon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Starred',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.black),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        LineAwesomeIcons.archive,
                        size: 30,
                      ),
                      selectedIcon: FaIcon(
                        FontAwesomeIcons.archive,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Archived',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.black),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        LineAwesomeIcons.photo,
                        size: 28,
                      ),
                      selectedIcon: FaIcon(
                        FontAwesomeIcons.solidImage,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Images',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                  selectedIndex: _selectedIndex),
            ),
          ],
        ),
      ),
      // bottomSheet: _bottomBar(),
    );
  }

  Widget _body() {
    print(notesViewType);
    return Container(
        child: StaggeredGridPage(
      notesViewType: notesViewType,
      selectedIndex: _selectedIndex,
    ));
  }

  // Widget _bottomBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       FlatButton(
  //         child: Text(
  //           "New Note\n",
  //           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
  //         ),
  //         onPressed: () => _newNoteTapped(context),
  //       )
  //     ],
  //   );
  // }

  void _newNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = new Note(
        -1, "", "", DateTime.now(), DateTime.now(), Colors.white, 0, 0, 0);
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  void _newPhotoNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = new Note(
        -1, "", "", DateTime.now(), DateTime.now(), Colors.white, 0, 0, 1);
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => PhotoPage(emptyNote)));
  }

  void _toggleViewType() {
    setState(() {
      CentralStation.updateNeeded = true;
      if (notesViewType == viewType.List) {
        notesViewType = viewType.Staggered;
      } else {
        notesViewType = viewType.List;
      }
    });
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            color: Colors.black,
            icon: notesViewType == viewType.List
                ? FaIcon(
                    LineAwesomeIcons.copy,
                    size: 30,
                    color: Colors.black87,
                  )
                : FaIcon(
                    LineAwesomeIcons.list,
                    size: 30,
                    color: Colors.black87,
                  ),
            onPressed: () => _toggleViewType(),
          )
          // InkWell(
          //   child: GestureDetector(
          //     onTap: () => _toggleViewType(),
          //     child: Icon(
          //       notesViewType == viewType.List
          //           ? Icons.developer_board
          //           : Icons.view_headline,
          //       color: CentralStation.fontColor,
          //     ),
          //   ),
          // ),
          ),
    ];
  }
}
