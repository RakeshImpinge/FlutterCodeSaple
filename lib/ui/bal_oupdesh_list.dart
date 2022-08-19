import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/pothiSahibDataModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/wiki_page.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../services/preferenecs.dart';

class BalOupdeshListScreen extends StatefulWidget {
  const BalOupdeshListScreen({Key? key}) : super(key: key);

  @override
  BalOupdeshListState createState() => BalOupdeshListState();
}

class BalOupdeshListState extends State<BalOupdeshListScreen> {
  List<PothiSahibData> list = [
    PothiSahibData('1', "nym", 'Item Name', 60),
    PothiSahibData('1', "nym", 'Item Name', 35),
    PothiSahibData('1', "nym", 'Item Name', 90),
    PothiSahibData('1', "nym", 'Item Name', 90),
    PothiSahibData('1', "nym", 'Item Name', 90),
    PothiSahibData('1', "nym", 'Item Name', 35),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return backPressGestureDetection(
      context,
      Material(
          child: Scaffold(
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
          color: isDarkMode(context)
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).canvasColor,
          child: SafeArea(
              child: Container(
            color: isDarkMode(context)
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).canvasColor,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 25, bottom: 20),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _ItemView(context, index);
                    },
                  ),
                ),
              ],
            ),
          )),
        ),
      )),
    );
  }

  /*
   *   child view of list
   */
  Widget _ItemView(BuildContext context, int index) {
    return Wrap(key: Key('$index'), direction: Axis.horizontal, children: [
      Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
          child: InkWell(
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                navigationPage(context, wikiPageScreen, WikiPage());
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textList(
                        list[index].title,
                        false,
                        Theme.of(context).hoverColor,
                        24.0,
                        1.0,
                        false,
                        1,
                        context,
                        5,
                        FontWeight.w300,
                        Strings.gurmukhiAkkharThickFont),
                    textList(
                        list[index].description,
                        false,
                        textColorTheme(context),
                        16.0,
                        1.0,
                        false,
                        2,
                        context,
                        7,
                        FontWeight.w500,
                        Strings.AcuminFont),
                  ]))),
      const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Divider(height: 2, color: AppThemes.greyColor),
      ),
    ]);
  }
}
