import 'dart:io';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class PhotoViewer extends StatefulWidget {
  final File image;
  PhotoViewer({@required this.image});
  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: PhotoView(
        imageProvider: FileImage(widget.image),
        heroAttributes: PhotoViewHeroAttributes(tag: "image"),
        minScale: .35,
      ),
    );
  }
}
