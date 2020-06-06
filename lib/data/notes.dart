import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tizeno/data/SqliteHandler.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime dateCreated;
  DateTime dateLastEdited;
  Color noteColor;
  int isStarred;
  int isArchived;
  int isPhoto;

  Note(this.id, this.title, this.content, this.dateCreated, this.dateLastEdited,
      this.noteColor, this.isStarred, this.isArchived, this.isPhoto);

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> data = {};
    var contentData;
    if (isPhoto == 1 && forUpdate) {
      var noteDB = NotesDBHandler();
      var _testData = noteDB.selectAllPhotosById(this.id);
      _testData.then((value) async {
        contentData = value;
        print(contentData);
        data = {
          'id': contentData[0]['id'],
          'title': utf8.encode(title),
          'content': contentData[0]['content'],
          'dateCreated': epochFromDate(dateCreated),
          'dateLastEdited': epochFromDate(dateLastEdited),
          'noteColor': noteColor.value,
          'isPhoto': isPhoto,
          'isArchived': isArchived,
          'isStarred': isStarred,
        };
      });
    } else {
      data = {
        'title': utf8.encode(title),
        'content': content.toString().isNotEmpty
            ? utf8.encode(content)
            : utf8.encode(content),
        'dateCreated': epochFromDate(dateCreated),
        'dateLastEdited': epochFromDate(dateLastEdited),
        'noteColor': noteColor.value,
        'isPhoto': isPhoto,
        'isArchived': isArchived,
        'isStarred': isStarred,
      };
    }

    if (forUpdate && isPhoto == 1) {
    } else if (forUpdate) {
      data["id"] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime now) {
    return now.millisecondsSinceEpoch ~/ 1000;
  }
}
