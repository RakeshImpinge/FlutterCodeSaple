import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/bal_oupdesh_learn_mode_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/display_settings/bloc.dart';
import 'package:learn_shudh_gurbani/bloc/favorites/favorite_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/folders/folder_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/pothi_sahib/pothi_sahib_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/raag/raag_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/reminders/reminders_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/report_mistake/report_mistake_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/searchMenu/search_menu_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/settings/lanaguage/language_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/settings/settings_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/sourceList/sources_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/tabView/tab_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_state.dart';
import 'package:learn_shudh_gurbani/bloc/tracker/trackers_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/writers/writers_bloc.dart';
import 'package:learn_shudh_gurbani/services/repository.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/app_intro.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/add_notes/add_notes_bloc.dart';
import 'bloc/login/login_scaffold.dart';
import 'bloc/signup/signup_scaffold.dart';
import 'constants/constants.dart';
import 'services/preferenecs.dart';
import 'ui/available_app_updates.dart';
import 'ui/bal_oupdesh.dart';
import 'ui/bal_oupdesh_learn_mode.dart';
import 'ui/bal_oupdesh_list.dart';
import 'ui/check_for_updates.dart';
import 'ui/download_sources.dart';
import 'ui/literature_pdf_view.dart';
import 'ui/literature_screen.dart';
import 'ui/media_list_songs.dart';
import 'ui/now_playing.dart';
import 'ui/pothi_sahib_viewer.dart';
import 'ui/report_mistake_form.dart';
import 'ui/search_menu.dart';
import 'ui/search_screen.dart';
import 'ui/section_help.dart';
import 'ui/sehaj_paath_listing.dart';
import 'ui/settings.dart';
import 'ui/settings_sub_page.dart';
import 'ui/splash_screen.dart';
import 'ui/wiki_page.dart';
// import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Preferences.preferences = await SharedPreferences.getInstance();
  Preferences.init();
  Firebase.initializeApp();
  runApp(MyApp());
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}
// AppLifecycleState appLifecycleState = AppLifecycleState.detached;

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
     initClearNotificationsState();
   // WidgetsBinding.instance.addObserver(MyApp());
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      initClearNotificationsState();

      // await flutterLocalNotificationsPlugin
      //     .cancelAll();
    }
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   appLifecycleState = state;
  //   print("test>>>${appLifecycleState}====");
  // }
  // // @override
  // // void didChangeAppLifecycleState(AppLifecycleState state) {
  // //   super.didChangeAppLifecycleState(state);
  // // }
  // // if (appLifecycleState == AppLifecycleState.paused) {
  // // // in background
  // // }
  @override
  void dispose() {
   // WidgetsBinding.instance.removeObserver(MyApp());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<ThemeBloc>(create: (context) => ThemeBloc()),
        Provider<TabBloc>(create: (context) => TabBloc()),
        Provider<LanguageBloc>(create: (context) => LanguageBloc()),
        Provider<SettingsBloc>(create: (context) => SettingsBloc()),
        Provider<ReportMistakeBloc>(create: (context) => ReportMistakeBloc()),
        Provider<DisplaySettingsBloc>(create: (context) => DisplaySettingsBloc()),
        Provider<AddNotesBloc>(create: (context) => AddNotesBloc(Repository())),
        Provider<LearnModeBloc>(create: (context) => LearnModeBloc()),
        Provider<SearchMenuBloc>(create: (context) => SearchMenuBloc()),
        Provider<WritersBloc>(create: (context) => WritersBloc(Repository())),
        Provider<SourcesBloc>(create: (context) => SourcesBloc(Repository())),
        Provider<PothiSahibBloc>(create: (context) => PothiSahibBloc(Repository())),
        Provider<RaagBloc>(create: (context) => RaagBloc(Repository())),
        Provider<FolderBloc>(create: (context) => FolderBloc(Repository()),),
        Provider<RemindersBloc>(create: (context) => RemindersBloc(Repository())),
        Provider<TrackersBloc>(create: (context) => TrackersBloc(Repository())),
        Provider<FavoriteBloc>(create: (context) => FavoriteBloc(Repository())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return MaterialApp(color: Theme.of(context).primaryColor,
              title: Strings.app_name,
              debugShowCheckedModeBanner: false,
              theme: themeState.themeData,
              routes: <String, WidgetBuilder>{
              splashScreen: (BuildContext context) => const SplashScreen(),
              appIntro: (BuildContext context) => const AppIntroScreen(),
              loginScreen: (BuildContext context) => const LoginScaffold(),
              signupScreen: (BuildContext context) => const SignupScreen(),
              settings: (BuildContext context) => const Settings(),
              settingsSubPage: (BuildContext context) => SettingsSubPage(),
              checkForUpdates: (BuildContext context) => const CheckUpdates(),
              availableUpdates: (BuildContext context) => const AvailableUpdates(),
              downloadSources: (BuildContext context) => const DownloadSources(),
              searchGurbani: (BuildContext context) => const SearchGurbani(),
              searchMenu: (BuildContext context) => const SearchMenu(),
              sectionHelp: (BuildContext context) => const SectionHelp(),
              pothiSahibViewer: (BuildContext context) => const PothiSahibViewer(),
              reportMistakeForm: (BuildContext context) => const ReportMistakeForm(),
              sehajPaathListing: (BuildContext context) => const SehajPaathListingScreen(),
              literatureScreen: (BuildContext context) => const LiteratureScreen(),
              balOupdeshScreen: (BuildContext context) => const BalOupdeshScreen(),
              balOupdeshLearnMode: (BuildContext context) => const LearnModeScreen(),
              balOupdeshListScreen: (BuildContext context) => const BalOupdeshListScreen(),
              wikiPageScreen: (BuildContext context) => const WikiPage(),
              mediaListSongs: (BuildContext context) => const MediaListSongs(),
              nowPlaying: (BuildContext context) => const NowPlaying(),
              literatureViewPDF: (BuildContext context) => const LiteratureViewPDF(),
              resourceAddTrackerCounter: (BuildContext context) => const LiteratureScreen(),
            },
            initialRoute: Preferences.getAppSettings(Strings.home_screen_introduction)==true?appIntro : splashScreen,
          );
        },

      ),

    );
  }
}
Future<void> initClearNotificationsState() async {
  ClearAllNotifications.clear();
}
