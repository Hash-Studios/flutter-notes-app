import 'dart:async';
// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tizeno/data/notes.dart';
import 'package:tizeno/screens/picnote_page.dart';
import 'package:tizeno/data/utility.dart';
import 'package:tizeno/screens/note_page.dart';

class MyStaggeredTile extends StatefulWidget {
  final Note note;
  final int selectedIndex;
  MyStaggeredTile(this.note, this.selectedIndex);
  @override
  _MyStaggeredTileState createState() => _MyStaggeredTileState();
}

class _MyStaggeredTileState extends State<MyStaggeredTile> {
  String _content;
  double _fontSize;
  Color tileColor;
  String title;
  int isPhoto;

  @override
  Widget build(BuildContext context) {
    _content = widget.note.content;
    _fontSize = _determineFontSizeForContent();
    tileColor = widget.note.noteColor;
    title = widget.note.title;
    isPhoto = widget.note.isPhoto;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _noteTapped(context, isPhoto),
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

  void _noteTapped(BuildContext ctx, int isPhoto) {
    CentralStation.updateNeeded = false;
    if (isPhoto == 0) {
      Navigator.push(
          ctx, CupertinoPageRoute(builder: (ctx) => NotePage(widget.note)));
    } else {
      Navigator.push(
          ctx, CupertinoPageRoute(builder: (ctx) => PhotoPage(widget.note)));
    }
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
    if (isPhoto == 0) {
      contentsOfTiles.add(Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: AutoSizeText(
          _content,
          style: TextStyle(fontSize: _fontSize),
          maxLines: 10,
          textScaleFactor: 1.4,
        ),
      ));
    } else {
      File image;
      decodeStringToImage(image, _content);
      contentsOfTiles.add(
        Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Container(
            child: Image(
              image: FileImage(File(_content)),
            ),
          ),
        ),
      );
    }
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

  Future<File> decodeStringToImage(File image, String base64Image) async {
    // Uint8List base64Decode = base64.decode(base64Image);
    // await image.writeAsBytes(base64Decode);
    image = new File(base64Image);
    return image;
  }
}
