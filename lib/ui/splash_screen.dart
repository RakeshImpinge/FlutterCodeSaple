import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_shudh_gurbani/bloc/login/login_scaffold.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/splash_data.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/bal_oupdesh_learn_mode.dart';
import 'package:learn_shudh_gurbani/ui/literature_screen.dart';
import 'package:learn_shudh_gurbani/ui/sehaj_paath_listing.dart';
import 'package:learn_shudh_gurbani/ui/settings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/tab_view.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../app_themes.dart';
import '../bloc/tabView/tab_bloc.dart';
import '../bloc/tabView/tab_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_events.dart';
import '../services/preferenecs.dart';
import '../utils/database_handler.dart';
import 'media_list_songs.dart';
import 'search_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
    // with SingleTickerProviderStateMixin {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  // late AnimationController animationController;
  // late Animation<double> animation;
  List<SplashData> itemList = [
    SplashData(Strings.sehajPath, AssetsName.ic_sehaj_paath),
    SplashData(Strings.sundarGutka, AssetsName.ic_sundar_gutka),
    SplashData(Strings.bal_oupdesh,AssetsName.ic_bal_Oupdesh),
    SplashData(Strings.randomShabad,AssetsName.ic_random_shabad),
    SplashData(Strings.multimedia, AssetsName.ic_multimedia),
    SplashData(Strings.resources, AssetsName.ic_resource),
  ];

  @override
  void initState() {
    super.initState();
    // final credential =  FirebaseAuth.instance.currentUser;
    // print("userDetails>>${credential}");



    // animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // animation = CurvedAnimation(parent: animationController, curve: Curves.bounceIn);
    // animation.addListener(() { setState(() {
    // });});
    // animationController.forward();
    // DatabaseHandler.instance.queryAll(DatabaseHandler.databasePath);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
     DatabaseHandler.instance.unlockDatabase();
    return backPressGestureDetection(
        context,
        Scaffold(
            body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
              child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                          child:Row(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  final credential =  FirebaseAuth.instance.currentUser;
                                  if(credential!=null|| (Preferences.getUserDetails(Preferences.KEY_USER_DETAILS)!=null  && Preferences.getUserDetails(Preferences.KEY_USER_DETAILS)!='')){
                                    navigationPage(context,searchGurbani,const SearchGurbani());
                                  }else {
                                    navigationPage(context, loginScreen, const LoginScaffold());
                                  }
                                },
                                child: Image.asset(
                                  AssetsName.ic_login_account,
                                  height: 25,
                                  width: 25,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  navigationPage(context, settings, const Settings());
                                },
                                child: SvgPicture.asset(
                                    AssetsName.ic_settings,
                                    height: 25,
                                    width: 25,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                      //<- top row options
                      Stack(fit: StackFit.passthrough,
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(isDarkMode(context) ? AssetsName.ic_splash_dark_mode : AssetsName.ic_splash, fit: BoxFit.fill,
                              height: _large ? 230 : (_medium ? (_height>=730?230:200) : 200)),),//<= image background
                          Center(child:Text(Strings.gurbani_ji_tuk,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: Strings.gurmukhiFont,
                                fontSize: _large ? 18 : (_medium ? 16 : 14),
                                color: Theme.of(context).indicatorColor),
                          )),
                          //<= gurbani text
                         Center(child: Padding(padding: EdgeInsets.only(top:_large ? 220: (_medium ? (_height>=730?220:190):190),),
                         child:Text(
                            Strings.app_name,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: _large ? 27 : (_medium ? 25 : 23),
                                color: Theme.of(context).dividerColor,
                                fontFamily: Strings.AcuminFont),
                         ))),
                        ]),

                      //<= app name
                      Expanded(child: GridView.count(
                              padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 150),
                              shrinkWrap: true,
                              childAspectRatio: 1.9,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: List.generate(itemList.length, (index) {
                                return InkWell(splashColor: Colors.transparent,
                                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      switch (index) {
                                        case 0:
                                          navigationPage(context, sehajPaathListing, SehajPaathListingScreen());
                                          break;
                                        case 1:
                                          break;
                                        case 2:
                                          navigationPage(context, balOupdeshLearnMode, LearnModeScreen());
                                          break;
                                        case 3:
                                          break;
                                        case 4:
                                          navigationPage(context, mediaListSongs, MediaListSongs());
                                          break;
                                        case 5:
                                          navigationPage(context, resource, LiteratureScreen());
                                          break;
                                      }
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                itemList[index].image.toString().endsWith(".png")
                                                    ? Image.asset(itemList[index].image,
                                                        width: 55,
                                                        height: 30,
                                                        // width: animation.value * 70,
                                                        // height: animation.value * 30,
                                                        color: Theme.of(context).indicatorColor)
                                                    : SvgPicture.asset(
                                                    itemList[index].image, width: 30, height: 30,
                                                        // width: animation.value * 30,
                                                        // height: animation.value * 30,
                                                        color: Theme.of(context).indicatorColor),
                                                SizedBox(
                                                  width: 40,
                                                  child: Divider(thickness: 3, color: Theme.of(context).dividerColor),
                                                ),
                                                Text(itemList[index].title,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: _large ? 17 : (_medium ? 15 : 14),
                                                        fontFamily: Strings.AcuminFont,
                                                        color: Theme.of(context).indicatorColor)),
                                              ]),
                                        )));
                              }))),
                      //<= list of options with grid view
                    ],
                  ),
                  Align(alignment: AlignmentDirectional.bottomCenter,
                      child: _showModalBottomSheet(context))
                ],
              ),
            ),
          ),
        )));
  }
/*
bottom search view
 */
  Widget _showModalBottomSheet(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 140),
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<TabBloc, TabState>(
          builder: (BuildContext context, TabState tabState) {
        return CustomTabBarView(isColoChange: false,);
      }),
    );
  }
  @override
  void didChangeDependencies() {
    BlocProvider.of<ThemeBloc>(context).add(ThemeEvent(appTheme:isDarkMode(context)?AppTheme.darkTheme:AppTheme.lightTheme));
    super.didChangeDependencies();
  }
}
