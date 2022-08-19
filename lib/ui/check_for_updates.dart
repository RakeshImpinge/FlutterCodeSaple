import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/available_app_updates.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

class CheckUpdates extends StatefulWidget {
  const CheckUpdates({Key? key}) : super(key: key);

  @override
  CheckUpdatesState createState() => CheckUpdatesState();
}

class CheckUpdatesState extends State<CheckUpdates> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return backPressGestureDetection(context,Material(
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
          titleSpacing: 10,
          title: const Text(Strings.check_for_app_updates),
          titleTextStyle: const TextStyle(
            fontSize: 21,
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: _height,
            width: _width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        text(
                            Strings.current_version,
                            false,
                            Theme.of(context).dividerColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            15,
                            FontWeight.bold),
                        text(
                            Strings.app_version,
                            false,
                            Theme.of(context).indicatorColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            5,
                            FontWeight.w300),
                        text(
                            Strings.size,
                            false,
                            Theme.of(context).dividerColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            15,
                            FontWeight.bold),
                        text(
                            Strings.size_in_mb,
                            false,
                            Theme.of(context).indicatorColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            5,
                            FontWeight.w300),
                        _checkForUpdatesButton(context),
                        text(
                            Strings.reset_app,
                            true,
                            Theme.of(context).indicatorColor,
                            18.0,
                            1.0,
                            false,
                            false,
                            context,
                            20,
                            FontWeight.normal),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _checkForUpdatesButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              backgroundColor: Theme.of(context).primaryColor,
              side:
                  BorderSide(width: 2.0, color: Theme.of(context).dividerColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            navigationPage(context, availableUpdates, AvailableUpdates());
          },
          child: const Text(
            Strings.check_for_updates,
            style: TextStyle(
                fontSize: 18,
                color: AppThemes.darkYellowColor,
                fontWeight: FontWeight.w600),
          ),
        ));
  }
}
