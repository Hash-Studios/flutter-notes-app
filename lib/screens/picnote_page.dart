import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tizeno/data/notes.dart';
import 'package:tizeno/data/SqliteHandler.dart';
import 'package:tizeno/screens/photoViewer.dart';
import 'package:tizeno/data/utility.dart';
import 'package:tizeno/ui/options_sheet.dart';
// import 'package:image/image.dart' as Img;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_share_content/flutter_share_content.dart';
import 'package:flutter/services.dart';

class PhotoPage extends StatefulWidget {
  final Note noteInEditing;

  PhotoPage(this.noteInEditing);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final _titleController = TextEditingController();
  // final _contentController = TextEditingController();
  var noteColor;
  bool _isNewNote = false;
  final _titleFocus = FocusNode();
  bool isSaved = false;

  File _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> _allNotesInQueryResult = [];
  bool _hasImages;

  List<Widget> images;
  List<String> imagePaths;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        addImageToList(_image);
        imagePaths.add(_image.path);
      } else {
        _readyToPop();
        Navigator.pop(context);
      }
    });
  }

  String _titleFrominitial;
  String _contentFromInitial;
  // DateTime _lastEditedForUndo;

  var _editableNote;

  // the timer variable responsible to call persistData function every 5 seconds and cancel the timer when the page pops.
  Timer _persistenceTimer;

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    images = new List();
    imagePaths = new List();
    _editableNote = widget.noteInEditing;
    _titleController.text = _editableNote.title;
    decodeStringToImage(_image, _editableNote.content)
        .then((value) => _image = value);
    noteColor = _editableNote.noteColor;
    // _lastEditedForUndo = widget.noteInEditing.dateLastEdited;

    _titleFrominitial = widget.noteInEditing.title;
    _contentFromInitial = widget.noteInEditing.content;

    _hasImages = false;
    if (widget.noteInEditing.id == -1) {
      _isNewNote = true;
    }
    _persistenceTimer = new Timer.periodic(Duration(seconds: 5), (timer) {
      // call insert query here
      print("5 seconds passed");
      print("editable note id: ${_editableNote.id}");
      // _persistData();
    });

    if (!_isNewNote) {
      var noteDB = NotesDBHandler();
      var _testData = noteDB.selectAllPhotosById(widget.noteInEditing.id);
      _testData.then((value) {
        setState(() {
          this._allNotesInQueryResult = value;
        });
        showImagesAdded();
      });
    }
    if (_editableNote.id == -1) {
      getImage();
    }
    if (_editableNote.id == -1) {
      _photoNote();
    }

    super.initState();
  }

  void showImagesAdded() {
    int len = _allNotesInQueryResult.length;
    if (len > 0)
      setState(() {
        _hasImages = true;
      });
    print(
        String.fromCharCodes(_allNotesInQueryResult[0]["content"]).toString());
    addImageToList(
        File(String.fromCharCodes(_allNotesInQueryResult[0]["content"])));
  }

  Future<String> encodeImageToString(File image) async {
    // final bytes = await image.readAsBytes();
    // String base64Image = base64.encode(bytes);
    if (isSaved) {
      String path = 'storage/emulated/0';
      print('$path/Tizeno/' +
          image.path.split('/')[image.path.split('/').length - 1].toString());
      return '$path/Tizeno/' +
          image.path.split('/')[image.path.split('/').length - 1].toString();
    }
    // String base64Image = image.path;
    // return base64Image;
  }

  Future<File> decodeStringToImage(File image, String base64Image) async {
    // Uint8List base64Decode = base64.decode(base64Image);
    // await image.writeAsBytes(base64Decode);
    image = File(base64Image);
    print(base64Image);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    if (_editableNote.id == -1 && _editableNote.title.isEmpty) {
      // FocusScope.of(context).requestFocus(_titleFocus);
    }

    return WillPopScope(
      child: Scaffold(
        backgroundColor: noteColor,
        // resizeToAvoidBottomInset: false,
        key: _globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
            color: Colors.black,
          ),
          actions: _archiveAction(context),
          elevation: 1,
          backgroundColor: noteColor == Colors.white ? Colors.amber : noteColor,
          title: _pageTitle(),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.orange.withOpacity(0.8),
              //       blurRadius: 20,
              //       spreadRadius: 0,
              //       offset: Offset(0, 4))
              // ],
              borderRadius: BorderRadius.circular(100)),
          child: FloatingActionButton(
            heroTag: 'FAB',
            elevation: 0,
            onPressed: () {
              // CentralStation.updateNeeded = true;
              _readyToPop();
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: _body(context)),
      ),
      onWillPop: _readyToPop,
    );
  }

  Widget _body(BuildContext ctx) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scrollbar(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 1290.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
//          decoration: BoxDecoration(border: Border.all(color: CentralStation.borderColor,width: 1 ),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "Heading",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0)),
                  onChanged: (str) => updateNoteObject(),
                  maxLines: null,
                  controller: _titleController,
                  focusNode: _titleFocus,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                  cursorColor: Colors.blue,
                  // backgroundCursorColor: Colors.blue
                ),
              ),
              Divider(
                color: Colors.black45,
              ),
              Expanded(
                child: Visibility(
                    maintainState: false,
                    visible: _hasImages,
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: noteColor,
                      child:
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child:
                          Row(
                        children: images != null
                            ? images
                            : [
                                Container(
                                  child: Text("No Images added"),
                                )
                              ],
                      ),
                      // ),
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: MediaQuery.of(context).size.width,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Text(
      _editableNote.id == -1 ? "New Note" : "View Note",
      style: GoogleFonts.montserrat(),
    );
  }

  List<Widget> _archiveAction(BuildContext context) {
    List<Widget> actions = [];
    // if (widget.noteInEditing.id != -1) {
    //   actions.add(IconButton(
    //     icon: Icon(Icons.undo),
    //     color: Colors.black45,
    //     onPressed: () => _undo(),
    //   ));
    // }
    actions += [
      IconButton(
        icon: (_editableNote.isArchived == 0)
            ? Icon(Icons.archive)
            : Icon(Icons.archive),
        color: Colors.black45,
        onPressed: () => _archivePopup(context),
      ),
      // IconButton(
      //   icon: Icon(Icons.add),
      //   color: Colors.black45,
      //   onPressed: () => _saveAndStartNewNote(context),
      // ),
      IconButton(
        icon: (_editableNote.isStarred == 0)
            ? Icon(Icons.star_border)
            : Icon(Icons.star),
        color: Colors.black45,
        onPressed: () => (_editableNote.isStarred == 0)
            ? _starThisNote(context)
            : _unStarThisNote(context),
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        color: Colors.black45,
        onPressed: () => bottomSheet(context),
      ),
    ];
    return actions;
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return MoreOptionsSheet(
            color: noteColor,
            callBackColorTapped: _changeColor,
            callBackOptionTapped: bottomSheetOptionTappedHandler,
            dateLastEdited: _editableNote.dateLastEdited,
          );
        });
  }

  void _persistData() {
    updateNoteObject();

    if (widget.noteInEditing.title.isNotEmpty) {
      var noteDB = NotesDBHandler();
      if (widget.noteInEditing.id == -1) {
        Future<int> autoIncrementedId =
            noteDB.insertNote(widget.noteInEditing, true); // for new note
        // set the id of the note from the database after inserting the new note so for next persisting
        autoIncrementedId.then((value) {
          widget.noteInEditing.id = value;
        });
      } else {
        noteDB.insertNote(
            widget.noteInEditing, false); // for updating the existing note
      }
    }
  }

// this function will ne used to save the updated editing value of the note to the local variables as user types
  void updateNoteObject() {
    encodeImageToString(_image).then((value) => _editableNote.content = value);
    _editableNote.title = _titleController.text;
    _editableNote.noteColor = noteColor;
    print("new content: ${_editableNote.content}");
    print(widget.noteInEditing);
    print(_editableNote);

    print("same title? ${_editableNote.title == _titleFrominitial}");
    print("same content? ${_editableNote.content == _contentFromInitial}");

    if (!(_editableNote.title == _titleFrominitial &&
            _editableNote.content == _contentFromInitial) ||
        (_isNewNote)) {
      // No changes to the note
      // Change last edit time only if the content of the note is mutated in compare to the note which the page was called with.
      _editableNote.dateLastEdited = DateTime.now();
      print("Updating dateLastEdited");
      setState(() {
        CentralStation.updateNeeded = true;
      });
    }
  }

  void bottomSheetOptionTappedHandler(moreOptions tappedOption) {
    print("option tapped: $tappedOption");
    switch (tappedOption) {
      case moreOptions.delete:
        {
          if (_editableNote.id != -1) {
            _deleteNote(_globalKey.currentContext);
          } else {
            _exitWithoutSaving(context);
          }
          break;
        }
      // case moreOptions.archive:
      //   {
      //     _archivePopup(context);
      //   }
      //   break;
      case moreOptions.share:
        {
          if (_editableNote.content.isNotEmpty) {
            // FlutterShareContent.shareContent(
            //     imageUrl: '${widget.noteInEditing.content}',
            //     title: '${widget.noteInEditing.title}',
            //     msg: '${widget.noteInEditing.title}');
            // Share.shareFile(
            //   File('${widget.noteInEditing.content}'),
            //   subject: '${widget.noteInEditing.title}',
            //   text: '${widget.noteInEditing.title}',
            // );
            // FlutterShareFile.shareImage(
            //     widget.noteInEditing.content,
            //     '${widget.noteInEditing.title}.png',
            //     '${widget.noteInEditing.title}');
          }
          break;
        }
      case moreOptions.copy:
        {
          _copy();
          break;
        }
    }
  }

  void _deleteNote(BuildContext context) {
    if (_editableNote.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm ?"),
              content: Text("This note will be deleted permanently"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      // print(widget.noteInEditing.content);
                      // final dir = Directory(widget.noteInEditing.content);
                      // dir.delete(recursive: false);
                      _persistenceTimer.cancel();
                      var noteDB = NotesDBHandler();
                      Navigator.of(context).pop();
                      noteDB.deleteNote(_editableNote);
                      CentralStation.updateNeeded = true;
                      _hasImages = false;
                      Navigator.of(context).pop();
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
    }
  }

  void _changeColor(Color newColorSelected) {
    print("note color changed");
    setState(() {
      noteColor = newColorSelected;
      _editableNote.noteColor = newColorSelected;
    });
    _persistColorChange();
    CentralStation.updateNeeded = true;
  }

  void _persistColorChange() {
    if (_editableNote.id != -1) {
      var noteDB = NotesDBHandler();
      _editableNote.noteColor = noteColor;
      noteDB.insertNote(_editableNote, false);
    }
  }

  Future<bool> _readyToPop() async {
    _persistenceTimer.cancel();
    //show saved toast after calling _persistData function.
    // _globalKey.currentState.showSnackBar(new SnackBar(
    //     content: Text("Saved"), duration: Duration(milliseconds: 500)));
    _persistData();
    return true;
  }

  void _archivePopup(BuildContext context) {
    if (_editableNote.isArchived == 0) {
      if (_editableNote.id != -1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm ?"),
                content: Text("This note will be archived"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => _archiveThisNote(context),
                      child: Text("Yes")),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("No"))
                ],
              );
            });
      } else {
        _exitWithoutSaving(context);
      }
    } else {
      if (_editableNote.id != -1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm ?"),
                content: Text("This note will be unarchived"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => _unArchiveThisNote(context),
                      child: Text("Yes")),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("No"))
                ],
              );
            });
      } else {
        _exitWithoutSaving(context);
      }
    }
  }

  // void _starPopup(BuildContext context) {
  //   if (_editableNote.isStarred == 0) {
  //     if (_editableNote.id != -1) {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Confirm ?"),
  //               content: Text("This note will be starred"),
  //               actions: <Widget>[
  //                 FlatButton(
  //                     onPressed: () => _starThisNote(context),
  //                     child: Text("Yes")),
  //                 FlatButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     child: Text("No"))
  //               ],
  //             );
  //           });
  //     } else {
  //       _exitWithoutSaving(context);
  //     }
  //   } else {
  //     if (_editableNote.id != -1) {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Confirm ?"),
  //               content: Text("This note will be unstarred"),
  //               actions: <Widget>[
  //                 FlatButton(
  //                     onPressed: () => _unStarThisNote(context),
  //                     child: Text("Yes")),
  //                 FlatButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     child: Text("No"))
  //               ],
  //             );
  //           });
  //     } else {
  //       _exitWithoutSaving(context);
  //     }
  //   }
  // }

  void _exitWithoutSaving(BuildContext context) {
    _persistenceTimer.cancel();
    CentralStation.updateNeeded = false;
    Navigator.of(context).pop();
  }

  void _archiveThisNote(BuildContext context) {
    Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    _editableNote.isArchived = 1;
    _editableNote.isStarred = 0;
    var noteDB = NotesDBHandler();
    noteDB.archiveNote(_editableNote);
    // update will be required to remove the archived note from the staggered view
    CentralStation.updateNeeded = true;
    _persistenceTimer.cancel(); // shutdown the timer

    // Navigator.of(context).pop(); // pop back to staggered view
    // TODO: OPTIONAL show the toast of archive completion
    _globalKey.currentState.showSnackBar(new SnackBar(
      content: Text("Archived"),
      duration: Duration(milliseconds: 500),
    ));
  }

  void _starThisNote(BuildContext context) {
    // Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    setState(() {
      _editableNote.isStarred = 1;
      _editableNote.isArchived = 0;
    });
    var noteDB = NotesDBHandler();
    noteDB.starNote(_editableNote);
    // update will be required to remove the archived note from the staggered view
    CentralStation.updateNeeded = true;
    _persistenceTimer.cancel(); // shutdown the timer

    // Navigator.of(context).pop(); // pop back to staggered view
    // TODO: OPTIONAL show the toast of star completion
    _globalKey.currentState.showSnackBar(new SnackBar(
        content: Text("Starred"), duration: Duration(milliseconds: 500)));
  }

  void _unArchiveThisNote(BuildContext context) {
    Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    _editableNote.isArchived = 0;
    var noteDB = NotesDBHandler();
    noteDB.archiveNote(_editableNote);
    // update will be required to remove the archived note from the staggered view
    CentralStation.updateNeeded = true;
    _persistenceTimer.cancel(); // shutdown the timer

    // Navigator.of(context).pop(); // pop back to staggered view
    // TODO: OPTIONAL show the toast of unarchive completion
    _globalKey.currentState.showSnackBar(new SnackBar(
        content: Text("Unarchived"), duration: Duration(milliseconds: 500)));
  }

  void _unStarThisNote(BuildContext context) {
    // Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    setState(() {
      _editableNote.isStarred = 0;
    });
    var noteDB = NotesDBHandler();
    noteDB.starNote(_editableNote);
    // update will be required to remove the archived note from the staggered view
    CentralStation.updateNeeded = true;
    // _persistenceTimer.cancel(); // shutdown the timer

    // Navigator.of(context).pop(); // pop back to staggered view
    // TODO: OPTIONAL show the toast of unstar completion
    _globalKey.currentState.showSnackBar(new SnackBar(
        content: Text("Unstarred"), duration: Duration(milliseconds: 500)));
  }

  void _photoNote() {
    // Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    setState(() {
      _editableNote.isPhoto = 1;
    });
    var noteDB = NotesDBHandler();
    noteDB.photoNote(_editableNote);
    // update will be required to remove the archived note from the staggered view
    CentralStation.updateNeeded = true;
    // _persistenceTimer.cancel(); // shutdown the timer

    // Navigator.of(context).pop(); // pop back to staggered view
    // TODO: OPTIONAL show the toast of unstar completion
    // _globalKey.currentState.showSnackBar(new SnackBar(
    //     content: Text("Unstarred"), duration: Duration(milliseconds: 500)));
  }

  void _copy() {
    var noteDB = NotesDBHandler();
    Note copy = Note(-1, _editableNote.title, _editableNote.content,
        DateTime.now(), DateTime.now(), _editableNote.noteColor, 0, 0, 1);

    var status = noteDB.copyNote(copy);
    status.then((query_success) {
      if (query_success) {
        CentralStation.updateNeeded = true;
        Navigator.of(_globalKey.currentContext).pop();
      }
    });
  }

  // void _undo() {
  //   _titleController.text = _titleFrominitial; // widget.noteInEditing.title;
  //   _contentController.text =
  //       _contentFromInitial; // widget.noteInEditing.content;
  //   _editableNote.dateLastEdited =
  //       _lastEditedForUndo; // widget.noteInEditing.dateLastEdited;
  // }

  void addImageToList(File image) async {
    if (_editableNote.id == -1) {
      if (File == null) return;
      // Img.Image img = Img.decodeImage(image.readAsBytesSync());
      // Img.Image thumbnail = Img.copyResize(img, width: 400);
      await GallerySaver.saveImage(image.path, albumName: "Tizeno");
      // Directory tempDir = await getTemporaryDirectory();
      // String tempPath = tempDir.path;
      // File(tempPath + 'thumbnail.png')
      //   ..writeAsBytesSync(Img.encodePng(thumbnail));
      // File resizedImg = File(String.fromCharCodes(
      //     File(tempPath + 'thumbnail.png').readAsBytesSync()));
      setState(() {
        isSaved = true;
        _hasImages = true;
        if (image != null)
          images.add(Container(
            width: 720.w,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhotoViewer(image: image))),
              child: image != null
                  ? Ink(
                      child: Hero(
                        tag: "image",
                        child: Image.file(
                          image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : Text("Not Selected"),
            ),
          ));
      });
    } else {
      // Img.Image img = Img.decodeImage(image.readAsBytesSync());
      // Img.Image thumbnail = Img.copyResize(img, width: 400);
      // Directory tempDir = await getTemporaryDirectory();
      // String tempPath = tempDir.path;
      // File(tempPath + 'thumbnail.png')
      //   ..writeAsBytesSync(Img.encodePng(thumbnail));
      // File resizedImg = File(String.fromCharCodes(
      //     File(tempPath + 'thumbnail.png').readAsBytesSync()));
      images.add(
        Container(
          width: 720.w,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoViewer(image: image))),
            child: Ink(
              child: Hero(
                tag: "image",
                child: Image.file(
                  image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
