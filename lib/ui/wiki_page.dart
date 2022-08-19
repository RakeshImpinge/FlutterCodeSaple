import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/audio_player_view.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../services/preferenecs.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({Key? key}) : super(key: key);

  @override
  WikiPageState createState() => WikiPageState();
}

class WikiPageState extends State<WikiPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return backPressGestureDetection(context,Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leading: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: false,
        title: Text('Page Title'),
        titleTextStyle:
            const TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
      ),
      body: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              Flexible(
                flex: 8,
                child: SingleChildScrollView(
                  primary: true,
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        text(
                            "Heading",
                            false,
                            Theme.of(context).hoverColor,
                            30.0,
                            1.0,
                            false,
                            false,
                            context,
                            5,
                            FontWeight.w500,
                            Strings.AcuminFont),
                        text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis",
                            false,
                            textColorTheme(context),
                            18.0,
                            1.0,
                            false,
                            false,
                            context,
                            10,
                            FontWeight.w500,
                            Strings.AcuminFont),
                        Card(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          shadowColor: AppThemes.darkBrownColor,
                          elevation: 2,
                          color: Theme.of(context).cursorColor,
                          semanticContainer: true,
                          child: SizedBox(width: double.infinity, height: 200),
                        ),
                        textItalic(
                          "This is how a caption will look.",
                          true,
                          isDarkMode(context)
                              ? AppThemes.blueColor
                              : AppThemes.brownColor,
                          16.0,
                          1.0,
                          false,
                          false,
                          context,
                          15,
                          FontWeight.w500,
                        ),
                        text(
                            "Subheading",
                            false,
                            Theme.of(context).hoverColor,
                            18.0,
                            3.6,
                            true,
                            false,
                            context,
                            20,
                            FontWeight.bold,
                            Strings.AcuminFont),
                        text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            false,
                            textColorTheme(context),
                            18.0,
                            1.0,
                            false,
                            false,
                            context,
                            10,
                            FontWeight.bold,
                            Strings.AcuminFont),
                      ]),
                ),
              ),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: AudioPlayerView())
            ],
          ),
        ),
      ),
    );
  }
}
