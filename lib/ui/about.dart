import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: IconButton(
        padding: EdgeInsets.only(bottom: 2),
        onPressed: () {
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => AboutDialog());
        },
        icon: FaIcon(LineAwesomeIcons.info_circle),
        color: Colors.black87,
        iconSize: 30,
      ),
    );
  }
}

class AboutDialog extends StatelessWidget {
  const AboutDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text("Tizeno v1.0.3"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Developed and Maintained by")),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                elevation: 0,
                color: Colors.white54,
                borderRadius: BorderRadius.circular(20),
                child: new ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    String link = "https://www.github.com/Hash-Studios";
                    _launchURL(link);
                  },
                  leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                        border: new Border(
                          right:
                              new BorderSide(width: 1.0, color: Colors.white54),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/dev.png"),
                      )),
                  title: Text(
                    "Hash Studios",
                    key: Key('DevName'),
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text(
                  //   "",
                  //   style: TextStyle(color: Colors.black87),
                  // ),
                ),
              ),
            ),
          ),
          // Text(
          //   "This is an Unofficial App.",
          //   style: TextStyle(fontSize: 12),
          // ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Github"),
          onPressed: () {
            Navigator.of(context).pop();
            String link = "https://www.github.com/Hash-Studios";
            _launchURL(link);
          },
        ),
        // CupertinoDialogAction(
        //   child: Text("LinkedIn"),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //     String link = "https://www.linkedin.com/in/liquidatorcoder/";
        //     _launchURL(link);
        //   },
        // ),
        CupertinoDialogAction(
          key: Key('BackButton'),
          isDestructiveAction: true,
          child: Text("Back"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
