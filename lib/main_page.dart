import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_screen/staggered_page.dart';
import 'package:multi_screen/notes.dart';
import 'package:multi_screen/note_page.dart';
import 'package:multi_screen/utility.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light,
        actions: _appBarActions(),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notes",
          style: GoogleFonts.montserrat(color: Colors.blueGrey),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.blueGrey.withOpacity(0.8),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 4))
        ], borderRadius: BorderRadius.circular(100)),
        child: FloatingActionButton.extended(
          elevation: 0,
          onPressed: () => _newNoteTapped(context),
          label: Text("CREATE"),
          icon: Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: _body(),
        right: true,
        left: true,
        top: true,
        bottom: true,
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
        ctx, MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
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
            color: Colors.blueGrey,
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
