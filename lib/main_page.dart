import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: FloatingActionButton.extended(
          heroTag: 'FAB',
          elevation: 0,
          onPressed: () => _newNoteTapped(context),
          label: Text("CREATE"),
          icon: Icon(Icons.add),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            height: 1440.h,
            width: 604.5.w,
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
          NavigationRail(
              labelType: NavigationRailLabelType.selected,
              backgroundColor: Colors.amber,
              onDestinationSelected: (int index) {
                setState(() {
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
        -1, "", "", DateTime.now(), DateTime.now(), Colors.white, [], 0);
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => NotePage(emptyNote)));
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
