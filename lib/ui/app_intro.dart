import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_events.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/services/preferenecs.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/splash_screen.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../utils/database_handler.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({Key? key}) : super(key: key);

  @override
  AppIntroState createState() => AppIntroState();
}

class AppIntroState extends State<AppIntroScreen> {
  bool _checkbox = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    DatabaseHandler.instance.unlockDatabase();
    return Scaffold(
        body: SizedBox(
          height: _height,
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, right: 15, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      value: _checkbox,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0),),
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(
                            width: 1.5,
                            color: Theme.of(context).indicatorColor),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _checkbox = Preferences.getAppSettings(Strings.home_screen_introduction);
                          Preferences.saveAppSettings(Strings.home_screen_introduction,!_checkbox);
                        });
                      },
                    ),
                    Flexible(
                      child: Text(Strings.app_intro_message,
                        style:TextStyle(fontWeight: FontWeight.normal,
                            fontSize: _large ? 25 : (_medium ? 20 : 18),
                            color: Colors.white,
                            fontFamily: Strings.AcuminFont),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 15, bottom: 25, right: 20, top: 0),
                child: GestureDetector(
                  onTap: () {
                    navigationPage(context, splashScreen, const SplashScreen());
                  },
                  child: Text(Strings.skip_intro,
                    style: TextStyle(fontWeight: FontWeight.normal,
                        fontSize: _large ? 25 : (_medium ? 20 : 18),
                        color: Theme.of(context).dividerColor,
                        fontFamily: Strings.AcuminFont),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
  @override
  void didChangeDependencies() {
    BlocProvider.of<ThemeBloc>(context).add(ThemeEvent(appTheme:isDarkMode(context)?AppTheme.darkTheme:AppTheme.lightTheme));
    super.didChangeDependencies();
  }
}
