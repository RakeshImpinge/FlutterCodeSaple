
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/settings/settings_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_state.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/check_for_updates.dart';
import 'package:learn_shudh_gurbani/ui/download_sources.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/settings/lanaguage/language_bloc.dart';
import '../bloc/settings/settings_event.dart';
import '../bloc/settings/settings_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_events.dart';
import '../services/preferenecs.dart';
import 'settings_sub_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() =>SettingsState();
}

class SettingsState extends State<Settings> {
  late double _height;
  late double _width;
  String defaultLanguage = Strings.english;
  var languageList =  [Strings.english,Strings.punjabi];
  String? defaultThemeMode = Strings.appModeDefault;
  var themeModeList =  [Strings.appModeDefault,Strings.app_mode_light,Strings.app_mode_dark];
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     defaultThemeMode=Preferences.getTheme().toString();
     defaultLanguage=Preferences.getLanguage().toString();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return backPressGestureDetection(context,Material(
        child: Scaffold(
          appBar:AppBar(backgroundColor: Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(iconSize: 30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
            centerTitle: false, titleSpacing: 10,
            title: const Text(Strings.settings),titleTextStyle: const TextStyle(fontSize: 21),),
          body:SafeArea(
            child: SizedBox(
            height: _height,
            width: _width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top:10,bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.language,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                      // language spinner
                      Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Container(
                        height: 40,
                         margin: const EdgeInsets.only(top: 10),
                         padding:
                         const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                         decoration: BoxDecoration(
                          color:Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.circular(25),),
                         child:DropdownButtonHideUnderline(
                           child:BlocBuilder<LanguageBloc, LanguageState>(
                             builder: (context, language) {
                               return DropdownButton(
                                     value: defaultLanguage,
                                     iconEnabledColor: Theme.of(context).indicatorColor,
                                     iconDisabledColor: Theme.of(context).indicatorColor,
                                     dropdownColor: Theme.of(context).disabledColor,
                                     icon: const Icon(Icons.keyboard_arrow_down),
                                     items:languageList.map((String itemsLanguage) {
                                       return DropdownMenuItem(
                                           value: itemsLanguage,
                                           child: Text(itemsLanguage, style: const TextStyle(
                                             fontFamily: Strings.AcuminFont,
                                           fontWeight: FontWeight.normal,),
                                           )
                                       );
                                     }
                                     ).toList(),
                                      onChanged: (String? value) {
                                        defaultLanguage = value!;
                                        Preferences.saveLanguage(defaultLanguage);
                                        BlocProvider.of<LanguageBloc>(context).add(LanguageEvent(language: defaultLanguage));
                                         },
                                   );
                             },
                           ),
                    ),
                    ),
                    ),
                        _divider(15),
                        // theme mode drop down
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.app_mode,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,10,FontWeight.bold),
                        ),
                      Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          decoration: BoxDecoration(
                            color:Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.circular(25),),
                            child:DropdownButtonHideUnderline(
                             child:BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
                               return DropdownButton(value: defaultThemeMode, iconEnabledColor: Theme.of(context).indicatorColor, iconDisabledColor: Theme.of(context).indicatorColor, dropdownColor: Theme.of(context).disabledColor, icon: const Icon(Icons.keyboard_arrow_down), items: themeModeList.map((String items) {
                                 return DropdownMenuItem(value: items, child:
                                 Text(items, style: const TextStyle(fontWeight: FontWeight.normal,),));
                               }).toList(),
                                 onChanged: (String? value1) {defaultThemeMode = value1;
                                 Preferences.saveTheme(defaultThemeMode.toString());
                                 BlocProvider.of<ThemeBloc>(context).add(ThemeEvent(appTheme: isDarkMode(context) ? AppTheme.darkTheme : AppTheme.lightTheme));
                                 },);
                             })),
                        ),
                      ),
                        //notifications settings
                        _divider(15),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                             text(Strings.other_app_notifications,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,1, FontWeight.bold),
                              SizedBox(
                                height: 35, //set desired REAL HEIGHT
                                width: 60,//set desired REAL WIDTH
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: 0.8,
                                  child: BlocBuilder<SettingsBloc, AppSettingsState>(
                                  builder: (context, state) {
                                   return CupertinoSwitch(
                                    value: state.otherAppNotifications!,
                                    onChanged: (value) {
                                      context.read<SettingsBloc>().add(OtherAppNotificationsChanged(otherAppNotifications: value));
                                    },
                                    activeColor: Theme.of(context).dividerColor,trackColor: AppThemes.lightBlue,
                                  );
                                  },
                                  ),
                                ) ),
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                          child:textItalic(Strings.other_app_notifications_description,false,AppThemes.lightBlue,18.0,1.0, false,false,context,5,FontWeight.normal),
                        ),
                        //daily dose notifications
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text(Strings.daily_notifications,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,1, FontWeight.bold),
                              SizedBox(
                                height: 35, //set desired REAL HEIGHT
                                width: 60,//set desired REAL WIDTH
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: 0.8,
                                  child: BlocBuilder<SettingsBloc, AppSettingsState>(
                                  builder: (context, dailyDoseState) =>
                                  CupertinoSwitch(
                                  value: dailyDoseState.dailyNotifications!,
                                  onChanged: (value) {
                                    context.read<SettingsBloc>().add(DailyDoseNotificationsChanged(dailyDoseNotification: value));
                                    },
                                  activeColor: Theme.of(context).dividerColor,trackColor: AppThemes.lightBlue,
                                ),
                              )),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                          child:textItalic(Strings.daily_notifications_description,false,AppThemes.lightBlue,18.0,1.0, false,false,context,5,FontWeight.normal),
                        ),
                        //offline media
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text(Strings.offline_media,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,1, FontWeight.bold),
                              SizedBox(
                                height: 35, //set desired REAL HEIGHT
                                width: 60,// set desire Real WIDTH
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: 0.8,//set desired REAL WIDTH
                                  child: BlocBuilder<SettingsBloc, AppSettingsState>(
                                    builder: (context, state) =>
                                  CupertinoSwitch(
                                  value: state.offlineMediaEnable!,
                                  onChanged: (value) {
                                    context.read<SettingsBloc>().add(OfflineMediaChanged(offlineMedia: value));
                                  },
                                  activeColor: Theme.of(context).dividerColor,trackColor: AppThemes.lightBlue,
                                ),
                                ),
                                )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:textItalic(Strings.offline_media_description,false,AppThemes.lightBlue,18.0,1.0, false,false,context,5,FontWeight.normal),
                        ),
                        //Home screen introduction
                        _divider(15),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text(Strings.home_screen_introduction,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,1, FontWeight.bold),
                              SizedBox(
                                height: 35, //set desired REAL HEIGHT
                                width: 60,//set desired REAL WIDTH
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: 0.8,
                                  child: BlocBuilder<SettingsBloc, AppSettingsState>(
                                    builder: (context, state) =>
                                  CupertinoSwitch(
                                  value: state.homeScreenIntro!,
                                  onChanged: (value) {
                                    context.read<SettingsBloc>().add(HomeScreenIntroChanged(homeScreenIntro: value));
                                  },
                                  activeColor: Theme.of(context).dividerColor,trackColor: AppThemes.lightBlue,
                                ),
                              ),) ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:textItalic(Strings.home_screen_introduction_description,false,AppThemes.lightBlue,18.0,1.0, false,false,context,5,FontWeight.normal),
                        ),
                        //learn to navigate
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.learn_to_navigate,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
                       // child: Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                           Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(Strings.watch_youtube_tutorials,false,Theme.of(context).indicatorColor,17.5,1.0, false,false,context,1, FontWeight.normal),
                              text(Strings.take_me_on_tour_of_app,false,Theme.of(context).indicatorColor,17.5,1.0, false,false,context,5, FontWeight.normal),
                              text(Strings.translation_index,false,Theme.of(context).indicatorColor,17.5,1.0, false,false,context,5, FontWeight.normal),
                            ],
                           ),
                          Padding(
                            padding: const EdgeInsets.all(3),
                             child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AssetsName.ic_youtube,width:25,height: 25, fit: BoxFit.fill,color: Theme.of(context).dividerColor,),
                              Padding(padding: const EdgeInsets.only(top: 3),
                              child: text(Strings.begin,false,Theme.of(context).dividerColor,15.0,1.0,true,false,context,5, FontWeight.normal),
                            ),
                                ],
                              ),
                          ),
                            ],
                          ),
                        ),
                        // about us
                        _divider(15),
                        Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.about_us,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsSubPage(sectionId:1,index: 1,),
                                  ),
                                );
                                },
                                child:text(Strings.about_us_app,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,1, FontWeight.normal),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SettingsSubPage(sectionId:1,index: 2,),),
                                  );
                                  },
                                child:text(Strings.about_us_gursevak,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,5, FontWeight.normal),

                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsSubPage(sectionId:1,index: 6,),
                                    ),
                                  );
                                },
                                child:text(Strings.acknowledgements,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,5, FontWeight.normal),
                              ),

                            ],
                          ),
                        ),
                        //Contact Us
                        _divider(15),
                         Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                          child:text(Strings.contact_us,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,1,FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(Strings.email,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,1, FontWeight.bold),
                                   InkWell(onTap: (){
                                     String? encodeQueryParameters(Map<String, String> params) {
                                       return params.entries
                                           .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                           .join('&');
                                     }

                                     final Uri emailLaunchUri = Uri(
                                       scheme: 'mailto',
                                       path: 'hello@gursevak.com',
                                       query: encodeQueryParameters(<String, String>{
                                         'subject': 'This is Subject Title!',
                                         'body':'This is Body of Email'

                                       }),
                                     );

                                     launchUrl(emailLaunchUri);
                                     //launch('mailto:hello@gursevak.com?subject=This is Subject Title&body=This is Body of Email');
                                   },
                                     child:text(Strings.contact_us_email,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                   )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:15),
                                  child:SvgPicture.asset(AssetsName.ic_email_contact_us,color: Theme.of(context).dividerColor,),
                                ),
                              ],
                            ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(Strings.website,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,15, FontWeight.bold),
                                      InkWell(
                                        onTap: (){
                                          final Uri toLaunch =
                                          Uri(scheme: 'https', host: 'gursevak.com', );
                                          _launchInBrowser(toLaunch);
                                        },
                                      child:text(Strings.website_link,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20),
                                    child:SvgPicture.asset(AssetsName.ic_web_contact_us,color:Theme.of(context).dividerColor,),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(Strings.facebook,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,15, FontWeight.bold),
                                      GestureDetector(onTap: (){
                                        _launchInBrowser(Uri.parse('https://www.facebook.com/gursevaksevadar'));
                                      },
                                      child:text(Strings.facebook_link,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20),
                                    child:SvgPicture.asset(AssetsName.ic_facebook_contact_us,color: Theme.of(context).dividerColor,),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(Strings.instagram,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,15, FontWeight.bold),
                                      GestureDetector(onTap: (){
                                        _launchInBrowser(Uri.parse('https://www.instagram.com/gursevaksevadar/'));
                                      },
                                      child:text(Strings.instagram_link,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20),
                                    child:SvgPicture.asset(AssetsName.ic_instagram_contact_us,color: Theme.of(context).dividerColor,),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(Strings.sound_cloud,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,15, FontWeight.bold),
                                      GestureDetector(onTap: (){
                                        _launchInBrowser(Uri.parse('https://soundcloud.com/gursevaksevadar'));
                                      },
                                      child:text(Strings.sound_cloud_link,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                      ),
                                        ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20),
                                    child:SvgPicture.asset(AssetsName.ic_sound_cloud,color: Theme.of(context).dividerColor,),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(Strings.youtube,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,15, FontWeight.bold),
                                     GestureDetector(onTap: (){
                                       _launchInBrowser(Uri.parse('https://www.youtube.com/gursevaksevadar'));
                                     },
                                      child:text(Strings.youtube_link,false,Theme.of(context).indicatorColor,14.0,1.0, false,false,context,2, FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20),
                                    child:SvgPicture.asset(AssetsName.ic_youtube_contact_us,color: Theme.of(context).dividerColor,),
                                  ),
                                ],
                              ),
                          ],
                        ),
                          ),
                        //donate
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.donate,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, settingsSubPage,arguments:
                              Strings.donate);
                            },
                          child:textItalic(Strings.donate_description,false,AppThemes.lightBlue,18.0,1.0, false,false,context,10,FontWeight.normal),
                        ),
                        ),
                        //Legal
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.legal,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, settingsSubPage,arguments:
                              Strings.privacy_policy);
                            },
                          child:text(Strings.privacy_policy,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                          ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, settingsSubPage,arguments:
                              Strings.name_of_policy);
                            },
                           child:text(Strings.name_of_policy,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                        ),
                        ),
                        // App updates
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.app_update,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: InkWell(
                            onTap: (){
                              navigationPage(context,checkForUpdates,CheckUpdates());
                            },
                          child:text(Strings.app_update,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: InkWell(
                            onTap: (){
                              navigationPage(context,downloadSources,DownloadSources());
                            },
                              child:text(Strings.download_source,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                          ),

                        ),
                        //app data
                        _divider(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.app_data,false,Theme.of(context).dividerColor,18.0,1.0, false,false,context,15,FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child:text(Strings.export_app_data,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text(Strings.auto_backup,false,Theme.of(context).indicatorColor,18.0,1.0, false,false,context,10,FontWeight.normal),
                              Container(
                                height: 35, //set desired REAL HEIGHT
                                width: 60,//set desired REAL WIDTH
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: 0.8,
                                  child: BlocBuilder<SettingsBloc, AppSettingsState>(
                                    builder: (context, state) =>
                                  CupertinoSwitch(
                                    value: state.autoBackup!,
                                    onChanged: (value) {
                                      context.read<SettingsBloc>().add(AutoBackUpSettingsChanged(autoBackup: value));
                                    },
                                    activeColor: Theme.of(context).dividerColor,trackColor: AppThemes.lightBlue,
                                  ),
                                ),
                                )  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],)),
        ),
        ),
        ),
    );
  }

  /*
   function to show divider
  */
  Widget _divider(double padding){
   return divider(color: AppThemes.greyDivider.withOpacity(0.4),thickness: 0.5, height:5, indent: 1,endIndent: 0.0,padding: padding);
  }
 /*
 launch website url
 */
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url, mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}




