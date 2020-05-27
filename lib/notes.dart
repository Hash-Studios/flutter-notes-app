import 'dart:convert';

import 'package:flutter/material.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime dateCreated;
  DateTime dateLastEdited;
  Color noteColor;
  int isStarred;
  int isArchived;
  

  Note(this.id, this.title, this.content, this.dateCreated, this.dateLastEdited,
      this.noteColor, this.isStarred, this.isArchived);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode(content),
      'dateCreated': epochFromDate(dateCreated),
      'dateLastEdited': epochFromDate(dateLastEdited),
      'noteColor': noteColor.value,
      'isArchived': isArchived,
      'isStarred': isStarred,
    };

    if (forUpdate) {
      data["id"] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime now) {
    return now.millisecondsSinceEpoch ~/ 1000;
  }

  void archiveNote() {
    isArchived = 1;
  }
  void starNote() {
    isStarred = 1;
  }
  void unArchiveNote() {
    isArchived = 0;
  }
  void unStarNote() {
    isStarred = 0;
  }
}
