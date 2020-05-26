import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:multi_screen/notes.dart';
import 'package:multi_screen/utility.dart';
import 'package:multi_screen/note_page.dart';

class MyStaggeredTile extends StatefulWidget {
  final Note note;
  MyStaggeredTile(this.note);
  @override
  _MyStaggeredTileState createState() => _MyStaggeredTileState();
}

class _MyStaggeredTileState extends State<MyStaggeredTile> {
  String _content;
  double _fontSize;
  Color tileColor;
  String title;
  List labels;

  @override
  Widget build(BuildContext context) {
    _content = widget.note.content;
    _fontSize = _determineFontSizeForContent();
    tileColor = widget.note.noteColor;
    title = widget.note.title;
    labels = widget.note.labels;

    return InkWell(
      onTap: () => _noteTapped(context),
      child: Ink(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            gradient: LinearGradient(
                colors: [
                  tileColor.withOpacity(0.6),
                  tileColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.8]),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
        child: constructChild(),
      ),
    );
  }

  void _noteTapped(BuildContext ctx) {
    CentralStation.updateNeeded = false;
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => NotePage(widget.note)));
  }

  Widget constructChild() {
    List<Widget> contentsOfTiles = [];

    if (widget.note.title.length != 0) {
      contentsOfTiles.add(
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            ),
            child: AutoSizeText(
              title,
              style:
                  TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
              maxLines: widget.note.title.length == 0 ? 1 : 3,
              textScaleFactor: 1.5,
            ),
          ),
        ),
      );
      // contentsOfTiles.add(
      //   Divider(
      //     color: widget.note.noteColor,
      //     height: 6,
      //   ),
      // );
    }

    contentsOfTiles.add(Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: AutoSizeText(
        _content,
        style: TextStyle(fontSize: _fontSize),
        maxLines: 10,
        textScaleFactor: 1.4,
      ),
    ));

    // contentsOfTiles.add(
    //   Divider(
    //     color: widget.note.noteColor,
    //     height: 6,
    //   ),
    // );
    contentsOfTiles.add(Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          CentralStation.stringForDatetime(widget.note.dateLastEdited),
          textAlign: TextAlign.right,
        ),
      ),
    ));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contentsOfTiles);
  }

  double _determineFontSizeForContent() {
    int charCount = _content.length + widget.note.title.length;
    double fontSize = 16;
    if (charCount > 110) {
      fontSize = 8;
    } else if (charCount > 80) {
      fontSize = 10;
    } else if (charCount > 50) {
      fontSize = 12;
    } else if (charCount > 20) {
      fontSize = 14;
    }
    return fontSize;
  }
}
