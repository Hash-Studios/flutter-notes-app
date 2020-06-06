import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tizeno/data/notes.dart';
import 'package:tizeno/data/SqliteHandler.dart';
import 'package:tizeno/data/utility.dart';
import 'package:tizeno/ui/staggered_tile.dart';
import 'package:tizeno/screens/main_page.dart';

class StaggeredGridPage extends StatefulWidget {
  final notesViewType;
  final int selectedIndex;
  const StaggeredGridPage({Key key, this.notesViewType, this.selectedIndex})
      : super(key: key);
  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  var noteDB = NotesDBHandler();
  List<Map<String, dynamic>> _allNotesInQueryResult = [];
  viewType notesViewType;

  @override
  void initState() {
    super.initState();
    this.notesViewType = widget.notesViewType;
  }

  @override
  void setState(fn) {
    super.setState(fn);
    this.notesViewType = widget.notesViewType;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _stagKey = GlobalKey();

    if (widget.selectedIndex == 0) {
      if (CentralStation.updateNeeded) {
        retrieveAllNotesFromDatabase();
      }
    } else if (widget.selectedIndex == 1) {
      if (CentralStation.updateNeeded) {
        retrieveStarredNotesFromDatabase();
      }
    } else if (widget.selectedIndex == 2) {
      if (CentralStation.updateNeeded) {
        retrieveArchivedNotesFromDatabase();
      }
    } else if (widget.selectedIndex == 3) {
      if (CentralStation.updateNeeded) {
        retrievePhotoNotesFromDatabase();
      }
    }

    return Container(
        child: Padding(
      padding: _paddingForView(context),
      child: new StaggeredGridView.count(
        key: _stagKey,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: _colForStaggeredView(context),
        children: List.generate(_allNotesInQueryResult.length, (i) {
          return _tileGenerator(i, widget.selectedIndex);
        }),
        staggeredTiles: _tilesForView(),
      ),
    ));
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.notesViewType == viewType.List) {
      return 1;
    }
    // for width larger than 600, return 3 irrelevant of the orientation to accommodate more notes horizontally
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  List<StaggeredTile> _tilesForView() {
    // Generate staggered tiles for the view based on the current preference.
    return List.generate(_allNotesInQueryResult.length, (index) {
      return StaggeredTile.fit(1);
    });
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    // double top_bottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(left: padding, right: padding, top: 0, bottom: 0);
  }

  MyStaggeredTile _tileGenerator(int i, int selectedIndex) {
    return MyStaggeredTile(
        Note(
            _allNotesInQueryResult[i]["id"],
            _allNotesInQueryResult[i]["title"] == null
                ? ""
                : utf8.decode(_allNotesInQueryResult[i]["title"]),
            _allNotesInQueryResult[i]["content"] == null
                ? ""
                : utf8.decode(_allNotesInQueryResult[i]["content"]),
            DateTime.fromMillisecondsSinceEpoch(
                _allNotesInQueryResult[i]["dateCreated"] * 1000),
            DateTime.fromMillisecondsSinceEpoch(
                _allNotesInQueryResult[i]["dateLastEdited"] * 1000),
            Color(_allNotesInQueryResult[i]["noteColor"]),
            _allNotesInQueryResult[i]["isStarred"],
            _allNotesInQueryResult[i]["isArchived"],
            _allNotesInQueryResult[i]["isPhoto"]),
        selectedIndex);
  }

  void retrieveAllNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _testData = noteDB.selectAllNotes();
    _testData.then((value) {
      setState(() {
        this._allNotesInQueryResult = value;
        CentralStation.updateNeeded = false;
      });
    });
  }

  void retrieveStarredNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _testData = noteDB.selectStarredNotes();
    _testData.then((value) {
      setState(() {
        this._allNotesInQueryResult = value;
        CentralStation.updateNeeded = false;
      });
    });
  }

  void retrieveArchivedNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _testData = noteDB.selectArchivedNotes();
    _testData.then((value) {
      setState(() {
        this._allNotesInQueryResult = value;
        CentralStation.updateNeeded = false;
      });
    });
  }

  void retrievePhotoNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _testData = noteDB.selectPhotoNotes();
    _testData.then((value) {
      setState(() {
        this._allNotesInQueryResult = value;
        CentralStation.updateNeeded = false;
      });
    });
  }
}
