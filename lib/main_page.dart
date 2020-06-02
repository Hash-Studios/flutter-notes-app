import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_screen/picnote_page.dart';
import 'package:multi_screen/staggered_page.dart';
import 'package:multi_screen/notes.dart';
import 'package:multi_screen/note_page.dart';
import 'package:multi_screen/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          "Notes",
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100))),
                      color: Colors.orange,
                      // elevation: 0,
                      onPressed: () => _newNoteTapped(context),
                      child: Icon(
                        Icons.edit,
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: 56,
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
                      child: Icon(Icons.photo, size: 28),
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              height: 1440.h,
              // width: 604.5.w,
              child: Container(
                padding: EdgeInsets.only(top: 8),
                child: SafeArea(
                  child: _body(),
                  right: true,
                  left: true,
                  top: true,
                  bottom: true,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: NavigationRail(
                unselectedIconTheme: IconThemeData(color: Colors.black54),
                labelType: NavigationRailLabelType.selected,
                backgroundColor: Colors.amber,
                onDestinationSelected: (int index) {
                  setState(() {
                    CentralStation.updateNeeded = true;
                    _selectedIndex = index;
                  });
                },
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.insert_emoticon),
                    selectedIcon: Icon(
                      Icons.note,
                      color: Colors.black,
                    ),
                    label: Text(
                      'All',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.black),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.star_border),
                    selectedIcon: Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Starred',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.black),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.arrow_downward),
                    selectedIcon: Icon(
                      Icons.archive,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Archived',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
                selectedIndex: _selectedIndex),
          ),
        ],
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
                ? Icon(Icons.view_compact)
                : Icon(Icons.view_agenda),
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
