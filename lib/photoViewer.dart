import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  final File image;
  PhotoViewer({@required this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: FileImage(image),
      heroAttributes: PhotoViewHeroAttributes(tag: "image"),
      minScale: .5,
    ));
  }
}
