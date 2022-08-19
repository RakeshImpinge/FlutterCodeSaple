// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/display_settings/event.dart';
import 'package:learn_shudh_gurbani/bloc/favorites/favorite_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/favorites/favorite_state.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/favorite_data_item.dart';
import 'package:learn_shudh_gurbani/models/folder_model.dart';
import 'package:learn_shudh_gurbani/models/mahakoshModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/media_list_songs.dart';
import 'package:learn_shudh_gurbani/ui/section_help.dart';
import 'package:learn_shudh_gurbani/utils/database_handler.dart';
import 'package:learn_shudh_gurbani/widgets/custom_shape_popup.dart';
import 'package:learn_shudh_gurbani/widgets/expandable.dart';
import 'package:learn_shudh_gurbani/widgets/seek_bar_widget.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../bloc/display_settings/bloc.dart';
import '../bloc/display_settings/state.dart';
import '../bloc/folders/folder_bloc.dart';
import '../bloc/folders/folder_event.dart';
import '../bloc/folders/folder_state.dart';
import '../services/preferenecs.dart';
import '../services/repository.dart';
import '../utils/assets_name.dart';
import '../utils/validator.dart';

class PothiSahibViewer extends StatefulWidget {
  const PothiSahibViewer({Key? key}) : super(key: key);

  @override
  PothiSahibViewerState createState() => PothiSahibViewerState();
}

class PothiSahibViewerState extends State<PothiSahibViewer> with WidgetsBindingObserver {
  bool isSwitched = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  String name ="";
  final _player = AudioPlayer();
  var textController= TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  String defaultItem = 'auQwnkw ieQy [';
  var dropDownList = ['auQwnkw ieQy [', 'auQwnkw ieQy 2'];
  bool isFullScreen = false,
      autoScrollEnable = true,
      isFadingBarEnable = false,
      isTopViewVisible = true,
      isTextOptionsVisible = false,
      isDisplaySettingsVisible = false,
      isParagraphEnable = false,
      isAddNotes = false,
      isFavorite = false,
      isBookmark = false,
      isAudioEnable = false,
      isMahakoshAudioEnable = false,
      createNote = false,
      isMoreOptions = false,
      isReportText = false,
      isReportTextSelected = false,
      isReportTextSelectedPangti = false,
      isDropDownOpen = false,
      isNextButtonVisible = false;
   int i=0;
  late List<bool> isSearchTypeSelected;
  final List<String> pangtiList = [
    'Gurbani pangti here',
    'Gurbani pangti here',
  ];
  String? defaultThemeMode = Strings.appModeDefault;
  String defaultFolderName = 'Folder Name';
  FolderModel? folderName = FolderModel(id: 0, name: Strings.selectFolder,date: currentDate());
  String defaultSelectFolder = Strings.selectFolder;
  String? defaultSelectBookMark = Strings.selectBookmark;
  var backgroundModeList = [
    Strings.appModeDefault,
    Strings.yellowBackground,
    Strings.puratanBackground
  ];
  var folderNameList = ['Folder Name', 'Folder Name 1', 'Folder Name 2'];
  List<FolderModel> folderNameList1 = [FolderModel(id: 0, name: Strings.selectFolder,date: currentDate())];
  var bookMarkList = [
    Strings.selectBookmark,
    'Folder Name',
    'Folder Name 1',
    'Folder Name 2'
  ];

  var moreOptionsList = [
    Strings.help,
    Strings.openAudio,
    Strings.downloadAudio,
    Strings.shareScreenshot,
    Strings.shareText,
    Strings.reportMistake
  ];
  final folderNameFocusNode = FocusNode();
  static GlobalKey previewContainer = GlobalKey();
  var count = 00;
  var index = 0;
  List<MahankoshData> mahanKoshList = [
    const MahankoshData('1', 'Sbd', 'Sbd dy ArQ', 'Source: [kosh name]1'),
    const MahankoshData('2', 'Sbd 2', 'Sbd dy ArQ 2', 'Source: [kosh name]2'),
    const MahankoshData('3', 'Sbd 3', 'Sbd dy ArQ 3', 'Source: [kosh name]3'),
    const MahankoshData('4', 'Sbd 4', 'Sbd dy ArQ 4', 'Source: [kosh name]4')
  ];

  @override
  void initState() {
    super.initState();
    isReportText = false;
    isSearchTypeSelected = List<bool>.filled(pangtiList.length, false);
    _init();
    getFolderList();
    folderNameFocusNode.addListener(() {
      if (!folderNameFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(folderNameFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return WillPopScope(
        onWillPop: () async {
      if((isDisplaySettingsVisible|| isAddNotes||createNote||isMoreOptions)==true){
        manageWidget(ManageWidgets.defaultSettings);
        return false;

      }else {
        isDisplaySettingsVisible = false;
        isAddNotes = false;
        createNote = false;
        isMoreOptions = false;
        isReportText = false;
        isTextOptionsVisible = false;
        isNextButtonVisible = false;
        isFadingBarEnable = false;
        // Do something here
        return true;
      }
    },
    child:backPressGestureDetection(
        context,
        Material(child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            elevation: 0,
            leading: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if((isDisplaySettingsVisible|| isAddNotes||createNote||isMoreOptions)==true) {
                    manageWidget(ManageWidgets.defaultSettings);
                  }else {
                    Navigator.of(context).pop();
                  }
                }),
            actions: [
              IconButton(
                  iconSize: 40,
                  padding: const EdgeInsets.only(right: 15),
                  onPressed: () {
                    isFullScreen = !isFullScreen;
                    isFadingBarEnable = !isFadingBarEnable;
                    manageWidget(ManageWidgets.defaultSettings);
                    if (isFullScreen) {
                      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
                      // to hide only status bar:
                      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
                      // to hide both, enable complete fullscreen:
                      SystemChrome.setEnabledSystemUIOverlays([]);
                    } else {
                      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                    }
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    color: Theme.of(context).dividerColor,
                    size: 40,
                  )),
              IconButton(
                color: Theme.of(context).dividerColor,
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  manageWidget(ManageWidgets.displaySettings);
                },
                icon: Image.asset(AssetsName.gurbaniViewSettings,),
              ),
              IconButton(
                iconSize: 30,
                padding: const EdgeInsets.only(right: 5),
                onPressed: () {
                  manageWidget(ManageWidgets.createNoteSettings);
                },
                icon: SvgPicture.asset(AssetsName.ic_resource, color: Theme.of(context).dividerColor,),
              ),
              IconButton(
                iconSize: 30,
                padding: const EdgeInsets.only(right: 25),
                onPressed: () {
                  manageWidget(ManageWidgets.moreOptionsSettings);
                },
                icon: Image.asset(AssetsName.ic_more_options),
              ),
            ],
            centerTitle: false,
            title: const Text(''),
            titleTextStyle: const TextStyle(fontSize: 21),
            flexibleSpace: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _displaySettingsPopUpTopView(context, isDisplaySettingsVisible, 130, Theme.of(context).scaffoldBackgroundColor),
                  _displaySettingsPopUpTopView(context, isAddNotes, 80, Theme.of(context).scaffoldBackgroundColor),
                  _displaySettingsPopUpTopView(context, createNote, 80, Theme.of(context).cursorColor),
                  _displaySettingsPopUpTopView(context, isMoreOptions, 40, isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).primaryColor),
                ]),
          ),
          body: Container(
            color: changeBackgroundColor(defaultThemeMode),
            child: RepaintBoundary(
              key: previewContainer,
              child: Container(
                color: changeBackgroundColor(defaultThemeMode),
                child:GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => manageWidget(ManageWidgets.defaultSettings),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              image: !isTopViewVisible
                                  ?  DecorationImage(
                                      image:AssetImage(isDarkMode(context)?AssetsName.bg_dark:AssetsName.bg),
                                      fit: BoxFit.fill)
                                  : null),
                          child: GestureDetector(
                              onLongPress: () {},
                              onTap: () {
                                manageWidget(ManageWidgets.reportText);
                              },
                              child: BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                                  builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                        visible: !state.paragraphStyle!,
                                        child: _topView(isTopViewVisible)),
                                    _topViewFloralBg(!isTopViewVisible),
                                    Visibility(
                                        visible: !state.paragraphStyle!,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(padding: const EdgeInsets.only(left: 25, right: 25),
                                              child: Container(
                                                  margin: !isTopViewVisible ? const EdgeInsets.only(top: 70, left: 7, right: 7)
                                                      : const EdgeInsets.only(top: 15),
                                                  padding: const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 15,
                                                          right: 15),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode(context)
                                                        ? AppThemes.greyLightColor3
                                                        : Theme.of(context).hintColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  // Top Card View
                                                  child: BlocBuilder<
                                                          DisplaySettingsBloc,
                                                          DisplaySettingsState>(
                                                      builder:
                                                          (context, fontSize) {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text("auQwnkw", style: TextStyle(fontFamily: Strings.gurmukhiAkkharThickFont,
                                                            fontSize: fontSize.gurmukhiFontSize,
                                                            color: isDarkMode(context) ? AppThemes.darkYellowColor : AppThemes.darkBlueColor,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                        ),
                                                        DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            value: defaultItem,
                                                            style: const TextStyle(fontFamily: Strings.gurmukhiAkkharThickFont),
                                                                iconEnabledColor: isDarkMode(context)
                                                                ? AppThemes.blueEditTextBgColor
                                                                : Theme.of(context).hoverColor,
                                                            iconDisabledColor: isDarkMode(context)
                                                                ? AppThemes.blueEditTextBgColor
                                                                : Theme.of(context).hoverColor,
                                                            dropdownColor: isDarkMode(context)
                                                                ? AppThemes.greyLightColor3
                                                                : Theme.of(context).indicatorColor,
                                                            icon: const Icon(
                                                              Icons.keyboard_arrow_down,
                                                              size: 30,
                                                            ),
                                                            items: dropDownList
                                                                .map((String
                                                                    items) {
                                                              return DropdownMenuItem(
                                                                  value: items,
                                                                  child: Text(
                                                                    items,
                                                                    style: TextStyle(
                                                                      fontFamily: Strings.gurmukhiAkkharThickFont,
                                                                      fontSize: fontSize.gurmukhiFontSize! - 10,
                                                                      color: isDarkMode(context)
                                                                          ? Theme.of(context).indicatorColor
                                                                          : Theme.of(context).primaryColor,
                                                                          fontWeight: FontWeight.normal,
                                                                    ),
                                                                  ));
                                                            }).toList(),
                                                            onChanged: (String?value) {
                                                              setState(() {
                                                                defaultItem = value!;
                                                              });
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  })),
                                            ),
                                            Card(
                                                color: isBackgroundModeYellow(defaultThemeMode) ? AppThemes.yellowColorCardBg : Colors.transparent,
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                elevation: 0,
                                                child: Wrap(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 25,
                                                              right: 25),
                                                      child: BlocBuilder<
                                                              DisplaySettingsBloc,
                                                              DisplaySettingsState>(
                                                          builder: (context, state) {
                                                        return Wrap(children: [
                                                          Visibility(visible: state.larrivarStyle!,child: SelectableText.rich(TextSpan(
                                                            children: <
                                                                InlineSpan>[
                                                              TextSpan(
                                                                text:'AwKihmMgihdyihdyihdwiqkrydwqwru]',
                                                                style: TextStyle(
                                                                  fontSize: state.larrivarFontSize,
                                                                  fontFamily: Strings.gurmukhiAkkharThickFont,
                                                                  color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                                                ),
                                                                recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                   // manageWidget(ManageWidgets.reportText);
                                                                  },
                                                              ),
                                                            ],
                                                          ),)),
                                                          Padding(padding: EdgeInsets.only(top:state.larrivarStyle!?5 :0),
                                                           child: SelectableText.rich(TextSpan(
                                                          children: <InlineSpan>[
                                                          WidgetSpan(
                                                          alignment: ui.PlaceholderAlignment.middle,
                                                          child: Visibility(
                                                            visible: isReportText,
                                                            child:
                                                            IconButton(
                                                              iconSize:
                                                              25,
                                                              padding:
                                                              const EdgeInsets.all(1.0),
                                                              onPressed:
                                                                  () {
                                                                setState(
                                                                        () {
                                                                      isReportTextSelectedPangti = false;
                                                                      isReportTextSelected = !isReportTextSelected;
                                                                      isNextButtonVisible = isReportTextSelected;
                                                                    });
                                                              },
                                                              icon: isReportTextSelected
                                                                  ? Image.asset(AssetsName.ic_checkbox_checked, color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColor, width: 25, height: 25)
                                                                  : Image.asset(AssetsName.ic_checkbox_unchecked,
                                                                color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColor,
                                                                width: 20,
                                                                height: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                                TextSpan(
                                                                text: state.larrivarStyle!?'AwKihmMgihdyihdyihdwiqkrydwqwru]':'AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                                                                style: TextStyle(
                                                                fontSize: state.larrivarStyle!?state.gurmukhiFontSize!:state.gurmukhiFontSize,
                                                                fontFamily:
                                                                Strings.gurmukhiAkkharThickFont,
                                                                color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                                                ),
                                                                recognizer:
                                                                TapGestureRecognizer()
                                                                ..onTap =
                                                                () {
                                                                  manageWidget(ManageWidgets.reportText);
                                                                },
                                                                ),
                                                                WidgetSpan(
                                                                child: Padding(
                                                                padding: const EdgeInsets.only(
                                                                left: 2,
                                                                top: 0,
                                                                right: 5),
                                                                child:
                                                                SvgPicture.asset(
                                                                AssetsName.ic_resource,
                                                                color: isDarkMode(
                                                                context) ? AppThemes.darkYellowColor : AppThemes.brownColor,
                                                                width: 30,
                                                                ),
                                                                ),),],
                                                          ),
                                                         )),
                                                        ]);
                                                      }),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
                                                        child: BlocBuilder<
                                                                DisplaySettingsBloc,
                                                                DisplaySettingsState>(
                                                            buildWhen: (previous, current) => previous
                                                                    .pronunciationTipFontSize != current.pronunciationTipFontSize,
                                                            builder: (context,
                                                                state) {
                                                              return Text(
                                                                "AwK-ih | mMg-ih | dyih",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily: Strings.gurmukhiAkkharThickFont,
                                                                  fontSize: state.pronunciationTipFontSize,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: isDarkMode(context) ? Theme.of(context).dividerColor : AppThemes.darkBlueColor,
                                                                ),
                                                              );
                                                            })),
                                                    Padding(
                                                        padding: const EdgeInsets.only(top: 7, left: 25, right: 25),
                                                        child: BlocBuilder<
                                                                DisplaySettingsBloc,
                                                                DisplaySettingsState>(
                                                            buildWhen: (previous, current) =>
                                                                previous.pronunciationTipFontSize != current.pronunciationTipFontSize,
                                                            builder: (context,
                                                                state) {
                                                              return Text(
                                                                'mMgih: K`Kw Aqy g`gw mukqw bolo, ishwrI sMkoc ky bolo, ksky nhI bolxIAW',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: state.pronunciationTipFontSize! - 2,
                                                                  fontFamily: Strings.gurmukhiFont,
                                                                  color: isDarkMode(context) ? Theme.of(context).dividerColor : const Color(0xFF525252),
                                                                ),
                                                              );
                                                            })),
                                                    BlocBuilder<
                                                            DisplaySettingsBloc,
                                                            DisplaySettingsState>(
                                                        builder:
                                                            (context, state) {
                                                      return Visibility(
                                                        visible: state
                                                            .transLiteration!,
                                                        child: Padding(
                                                            padding:const EdgeInsets
                                                                    .only(
                                                                top: 7,
                                                                left: 25,
                                                                right: 25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                buildWhen: (previous,
                                                                        current) =>
                                                                    previous
                                                                        .transliterationFontSize !=
                                                                    current
                                                                        .transliterationFontSize,
                                                                builder: (context, state) {
                                                                  return Text(
                                                                    'Aakhehi mangehi dhaehi dhaehi daath karae daathaar',
                                                                    style: TextStyle(
                                                                      fontSize: state.transliterationFontSize,
                                                                      fontWeight:
                                                                          FontWeight.w600,
                                                                      color: isDarkMode(context)
                                                                          ? AppThemes.blueColor
                                                                          : Theme.of(context).primaryColor,
                                                                    ),
                                                                  );
                                                                })),
                                                      );
                                                    }),
                                                    BlocBuilder<
                                                            DisplaySettingsBloc,
                                                            DisplaySettingsState>(
                                                        builder: (context, state) {
                                                      return Visibility(
                                                          visible: state
                                                              .englishTranslation!,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      top: 7,
                                                                      left: 25,
                                                                      right: 25),
                                                              child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                  buildWhen: (previous,
                                                                          current) =>
                                                                      previous
                                                                          .englishTranslationFontSize !=
                                                                      current
                                                                          .englishTranslationFontSize,
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return Text(
                                                                      'People beg and pray, “Give to us, give to us”, and the Great Giver gives His Gifts.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            state.englishTranslationFontSize,
                                                                        fontFamily:
                                                                            Strings.AcuminFont,
                                                                        color: isDarkMode(context)
                                                                            ? AppThemes.blueColor
                                                                            : Theme.of(context).primaryColor,
                                                                      ),
                                                                    );
                                                                  })));
                                                    }),
                                                    BlocBuilder<
                                                        DisplaySettingsBloc,
                                                        DisplaySettingsState>(
                                                      builder:
                                                          (context, state) {
                                                        return Visibility(
                                                          visible:
                                                              state.akhriAarth!,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(top: 15, left: 25, right: 25),
                                                              child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                  buildWhen: (previous,
                                                                          current) =>
                                                                      previous.akhriArthFontSize !=
                                                                      current.akhriArthFontSize,
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return SelectableText
                                                                        .rich(
                                                                      TextSpan(
                                                                        children: <
                                                                            InlineSpan>[
                                                                          TextSpan(
                                                                            text:
                                                                                '|',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: state.akhriArthFontSize,
                                                                              letterSpacing: 2,
                                                                              wordSpacing: 2,
                                                                              color: const Color(0xFFC91E86),
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                              text: ' pihlw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                              style: TextStyle(
                                                                                fontSize: state.akhriArthFontSize,
                                                                                fontFamily: Strings.gurmukhiFont,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                              )),
                                                                          TextSpan(
                                                                              text: '  view more…',
                                                                              style: TextStyle(
                                                                                fontSize: state.akhriArthFontSize! - 4,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  })),
                                                        );
                                                      },
                                                    ),
                                                    BlocBuilder<
                                                        DisplaySettingsBloc,
                                                        DisplaySettingsState>(
                                                      builder:
                                                          (context, state) {
                                                        return Visibility(
                                                          visible: state
                                                              .detailedAarth!,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(top: 15,
                                                                      left: 25,
                                                                      right: 25),
                                                              child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                  buildWhen: (previous,
                                                                          current) =>
                                                                      previous
                                                                          .detailedArthFontSize !=
                                                                      current
                                                                          .detailedArthFontSize,
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return SelectableText
                                                                        .rich(
                                                                      TextSpan(
                                                                        children: <
                                                                            InlineSpan>[
                                                                          TextSpan(
                                                                            text:
                                                                                '|',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: state.detailedArthFontSize,
                                                                              letterSpacing: 2,
                                                                              wordSpacing: 2,
                                                                              color: const Color(0xFF288DD8),
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                              text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                              style: TextStyle(
                                                                                fontSize: state.detailedArthFontSize,
                                                                                fontFamily: Strings.gurmukhiFont,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                              )),
                                                                          TextSpan(
                                                                              text: '  view more…',
                                                                              style: TextStyle(
                                                                                fontSize: state.detailedArthFontSize! - 4,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  })),
                                                        );
                                                      },
                                                    ),
                                                    BlocBuilder<
                                                        DisplaySettingsBloc,
                                                        DisplaySettingsState>(
                                                      builder:
                                                          (context, state) {
                                                        return Visibility(
                                                          visible: state
                                                              .detailedAarth!,
                                                          child:Padding(
                                                              padding: const EdgeInsets.only(
                                                                      top: 15,
                                                                      left: 25,
                                                                      right: 25),
                                                              child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                  buildWhen: (previous,
                                                                          current) =>
                                                                      previous
                                                                          .detailedArthFontSize !=
                                                                      current
                                                                          .detailedArthFontSize,
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return SelectableText
                                                                        .rich(
                                                                      TextSpan(
                                                                        children: <
                                                                            InlineSpan>[
                                                                          TextSpan(
                                                                            text:
                                                                                '|',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: state.detailedArthFontSize,
                                                                              letterSpacing: 2,
                                                                              wordSpacing: 2,
                                                                              color: const Color(0xFFD86816),
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                              text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                              style: TextStyle(
                                                                                fontSize: state.detailedArthFontSize,
                                                                                fontFamily: Strings.gurmukhiFont,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                              )),
                                                                          TextSpan(
                                                                              text: '  view more…',
                                                                              style: TextStyle(
                                                                                fontSize: state.detailedArthFontSize! - 4,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  })),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )),

                                            //_mahankoshPopup(context, true),
                                            Screenshot(
                                              controller: screenshotController,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: BlocBuilder<
                                                            DisplaySettingsBloc,
                                                            DisplaySettingsState>(
                                                        buildWhen: (previous,
                                                                current) => previous.gurmukhiFontSize != current.gurmukhiFontSize,
                                                        builder:
                                                            (context, state) {
                                                          return  Wrap(
                                                            direction: Axis.horizontal,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 5,
                                                                    left: 25,
                                                                    right: 25),
                                                                child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                    builder: (context, state) {
                                                                      return Wrap(children: [
                                                                        Visibility(visible: state.larrivarStyle!,child: SelectableText.rich(TextSpan(
                                                                          children: <
                                                                              InlineSpan>[
                                                                            TextSpan(
                                                                              text:'AwKihmMgihdyihdyihdwiqkrydwqwru]',
                                                                              style: TextStyle(
                                                                                fontSize: state.larrivarFontSize,
                                                                                fontFamily: Strings.gurmukhiAkkharThickFont,
                                                                                color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                                                              ),
                                                                              recognizer:
                                                                              TapGestureRecognizer()
                                                                                ..onTap = () {
                                                                                  manageWidget(ManageWidgets.moreOptionsSettings);
                                                                                },
                                                                            ),
                                                                          ],
                                                                        ),)),
                                                                        Padding(padding: EdgeInsets.only(top:state.larrivarStyle!?5 :0),
                                                                            child: SelectableText.rich(TextSpan(
                                                                              children: <InlineSpan>[
                                                                                WidgetSpan(
                                                                                  alignment: ui.PlaceholderAlignment.middle,
                                                                                  child: Visibility(
                                                                                    visible: isReportText,
                                                                                    child:
                                                                                    IconButton(
                                                                                      iconSize:
                                                                                      25,
                                                                                      padding:
                                                                                      const EdgeInsets.all(
                                                                                          1.0),
                                                                                      onPressed:
                                                                                          () {
                                                                                        setState(
                                                                                                () {
                                                                                              isReportTextSelectedPangti =
                                                                                              false;
                                                                                              isReportTextSelected =
                                                                                              !isReportTextSelected;
                                                                                              isNextButtonVisible =
                                                                                                  isReportTextSelected;
                                                                                            });
                                                                                      },
                                                                                      icon: isReportTextSelected
                                                                                          ? Image.asset(AssetsName.ic_checkbox_checked, color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColor, width: 25, height: 25)
                                                                                          : Image.asset(AssetsName.ic_checkbox_unchecked,
                                                                                        color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColor,
                                                                                        width: 20,
                                                                                        height: 20,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: state.larrivarStyle!?'AwKihmMgihdyihdyihdwiqkrydwqwru]':'AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                                                                                  style: TextStyle(
                                                                                    fontSize: state.larrivarStyle!?state.gurmukhiFontSize!:state.gurmukhiFontSize,
                                                                                    fontFamily:
                                                                                    Strings.gurmukhiAkkharThickFont,
                                                                                    color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                                                                  ),
                                                                                  recognizer:
                                                                                  TapGestureRecognizer()
                                                                                    ..onTap =
                                                                                        () {

                                                                                          manageWidget(ManageWidgets.reportText);
                                                                                    },
                                                                                ),
                                                                                WidgetSpan(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(
                                                                                        left: 2,
                                                                                        top: 0,
                                                                                        right: 5),
                                                                                    child:
                                                                                    SvgPicture.asset(
                                                                                      AssetsName.ic_resource,
                                                                                      color: isDarkMode(
                                                                                          context) ? AppThemes.darkYellowColor : AppThemes.brownColor,
                                                                                      width: 30,
                                                                                    ),
                                                                                  ),),],
                                                                            ),
                                                                            )),
                                                                      ]);
                                                                    }),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
                                                                  child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                      buildWhen: (previous, current) => previous
                                                                          .pronunciationTipFontSize != current.pronunciationTipFontSize,
                                                                      builder: (context,
                                                                          state) {
                                                                        return Text(
                                                                          "AwK-ih | mMg-ih | dyih",
                                                                          style:
                                                                          TextStyle(
                                                                            fontFamily: Strings.gurmukhiAkkharThickFont,
                                                                            fontSize: state.pronunciationTipFontSize,
                                                                            fontWeight: FontWeight.normal,
                                                                            color: isDarkMode(context) ? Theme.of(context).dividerColor : AppThemes.darkBlueColor,
                                                                          ),
                                                                        );
                                                                      })),
                                                              Padding(
                                                                  padding: const EdgeInsets.only(top: 7, left: 25, right: 25),
                                                                  child: BlocBuilder<
                                                                      DisplaySettingsBloc,
                                                                      DisplaySettingsState>(
                                                                      buildWhen: (previous, current) =>
                                                                      previous.pronunciationTipFontSize != current.pronunciationTipFontSize,
                                                                      builder: (context,
                                                                          state) {
                                                                        return Text(
                                                                          'mMgih: K`Kw Aqy g`gw mukqw bolo, ishwrI sMkoc ky bolo, ksky nhI bolxIAW',
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize: state.pronunciationTipFontSize! - 2,
                                                                            fontFamily: Strings.gurmukhiFont,
                                                                            color: isDarkMode(context) ? Theme.of(context).dividerColor : const Color(0xFF525252),
                                                                          ),
                                                                        );
                                                                      })),
                                                              BlocBuilder<
                                                                  DisplaySettingsBloc,
                                                                  DisplaySettingsState>(
                                                                  builder:
                                                                      (context, state) {
                                                                    return Visibility(
                                                                      visible: state
                                                                          .transLiteration!,
                                                                      child: Padding(
                                                                          padding:const EdgeInsets
                                                                              .only(
                                                                              top: 7,
                                                                              left: 25,
                                                                              right: 25),
                                                                          child: BlocBuilder<
                                                                              DisplaySettingsBloc,
                                                                              DisplaySettingsState>(
                                                                              buildWhen: (previous,
                                                                                  current) =>
                                                                              previous
                                                                                  .transliterationFontSize !=
                                                                                  current.transliterationFontSize,
                                                                              builder: (context, state) {
                                                                                return Text(
                                                                                  'Aakhehi mangehi dhaehi dhaehi daath karae daathaar',
                                                                                  style: TextStyle(
                                                                                    fontSize: state.transliterationFontSize,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w600,
                                                                                    color: isDarkMode(
                                                                                        context)
                                                                                        ? AppThemes
                                                                                        .blueColor
                                                                                        : Theme.of(context)
                                                                                        .primaryColor,
                                                                                  ),
                                                                                );
                                                                              })),
                                                                    );
                                                                  }),
                                                              BlocBuilder<
                                                                  DisplaySettingsBloc,
                                                                  DisplaySettingsState>(
                                                                  builder:
                                                                      (context, state) {
                                                                    return Visibility(
                                                                        visible: state
                                                                            .englishTranslation!,
                                                                        child: Padding(
                                                                            padding:
                                                                            const EdgeInsets.only(
                                                                                top: 7,
                                                                                left: 25,
                                                                                right: 25),
                                                                            child: BlocBuilder<
                                                                                DisplaySettingsBloc,
                                                                                DisplaySettingsState>(
                                                                                buildWhen: (previous,
                                                                                    current) =>
                                                                                previous
                                                                                    .englishTranslationFontSize !=
                                                                                    current
                                                                                        .englishTranslationFontSize,
                                                                                builder:
                                                                                    (context,
                                                                                    state) {
                                                                                  return Text(
                                                                                    'People beg and pray, “Give to us, give to us”, and the Great Giver gives His Gifts.',
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontSize:
                                                                                      state.englishTranslationFontSize,
                                                                                      fontFamily:
                                                                                      Strings.AcuminFont,
                                                                                      color: isDarkMode(context)
                                                                                          ? AppThemes.blueColor
                                                                                          : Theme.of(context).primaryColor,
                                                                                    ),
                                                                                  );
                                                                                })));
                                                                  }),
                                                              BlocBuilder<
                                                                  DisplaySettingsBloc,
                                                                  DisplaySettingsState>(
                                                                builder:
                                                                    (context, state) {
                                                                  return Visibility(
                                                                    visible:
                                                                    state.akhriAarth!,
                                                                    child: Padding(
                                                                        padding:
                                                                        const EdgeInsets.only(top: 15, left: 25, right: 25),
                                                                        child: BlocBuilder<
                                                                            DisplaySettingsBloc,
                                                                            DisplaySettingsState>(
                                                                            buildWhen: (previous,
                                                                                current) =>
                                                                            previous
                                                                                .akhriArthFontSize !=
                                                                                current
                                                                                    .akhriArthFontSize,
                                                                            builder:
                                                                                (context,
                                                                                state) {
                                                                              return SelectableText
                                                                                  .rich(
                                                                                TextSpan(
                                                                                  children: <
                                                                                      InlineSpan>[
                                                                                    TextSpan(
                                                                                      text:
                                                                                      '|',
                                                                                      style:
                                                                                      TextStyle(
                                                                                        fontSize: state.akhriArthFontSize,
                                                                                        letterSpacing: 2,
                                                                                        wordSpacing: 2,
                                                                                        color: const Color(0xFFC91E86),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                        text: ' pihlw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.akhriArthFontSize,
                                                                                          fontFamily: Strings.gurmukhiFont,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                                        )),
                                                                                    TextSpan(
                                                                                        text: '  view more…',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.akhriArthFontSize! - 4,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            })),
                                                                  );
                                                                },
                                                              ),
                                                              BlocBuilder<
                                                                  DisplaySettingsBloc,
                                                                  DisplaySettingsState>(
                                                                builder:
                                                                    (context, state) {
                                                                  return Visibility(
                                                                    visible: state
                                                                        .detailedAarth!,
                                                                    child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            top: 15,
                                                                            left: 25,
                                                                            right:
                                                                            25),
                                                                        child: BlocBuilder<
                                                                            DisplaySettingsBloc,
                                                                            DisplaySettingsState>(
                                                                            buildWhen: (previous,
                                                                                current) =>
                                                                            previous
                                                                                .detailedArthFontSize !=
                                                                                current
                                                                                    .detailedArthFontSize,
                                                                            builder:
                                                                                (context,
                                                                                state) {
                                                                              return SelectableText
                                                                                  .rich(
                                                                                TextSpan(
                                                                                  children: <
                                                                                      InlineSpan>[
                                                                                    TextSpan(
                                                                                      text:
                                                                                      '|',
                                                                                      style:
                                                                                      TextStyle(
                                                                                        fontSize: state.detailedArthFontSize,
                                                                                        letterSpacing: 2,
                                                                                        wordSpacing: 2,
                                                                                        color: const Color(0xFF288DD8),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                        text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.detailedArthFontSize,
                                                                                          fontFamily: Strings.gurmukhiFont,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                                        )),
                                                                                    TextSpan(
                                                                                        text: '  view more…',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.detailedArthFontSize! - 4,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            })),
                                                                  );
                                                                },
                                                              ),
                                                              BlocBuilder<
                                                                  DisplaySettingsBloc,
                                                                  DisplaySettingsState>(
                                                                builder:
                                                                    (context, state) {
                                                                  return Visibility(
                                                                    visible: state
                                                                        .detailedAarth!,
                                                                    child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            top: 15,
                                                                            left: 25,
                                                                            right:
                                                                            25),
                                                                        child: BlocBuilder<
                                                                            DisplaySettingsBloc,
                                                                            DisplaySettingsState>(
                                                                            buildWhen: (previous,
                                                                                current) =>
                                                                            previous
                                                                                .detailedArthFontSize !=
                                                                                current
                                                                                    .detailedArthFontSize,
                                                                            builder:
                                                                                (context,
                                                                                state) {
                                                                              return SelectableText
                                                                                  .rich(
                                                                                TextSpan(
                                                                                  children: <
                                                                                      InlineSpan>[
                                                                                    TextSpan(
                                                                                      text:
                                                                                      '|',
                                                                                      style:
                                                                                      TextStyle(
                                                                                        fontSize: state.detailedArthFontSize,
                                                                                        letterSpacing: 2,
                                                                                        wordSpacing: 2,
                                                                                        color: const Color(0xFFD86816),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                        text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.detailedArthFontSize,
                                                                                          fontFamily: Strings.gurmukhiFont,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF525252),
                                                                                        )),
                                                                                    TextSpan(
                                                                                        text: '  view more…',
                                                                                        style: TextStyle(
                                                                                          fontSize: state.detailedArthFontSize! - 4,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: isDarkMode(context) ? const Color(0xFFDDDDDD) : const Color(0xFF142849),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            })),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            left: 25,
                                                            right: 25),
                                                    child: BlocBuilder<
                                                            DisplaySettingsBloc,
                                                            DisplaySettingsState>(
                                                        builder:
                                                            (context, state) {
                                                      return Text(
                                                        "AwK-ih | mMg-ih | dyih",
                                                        style: TextStyle(
                                                          fontFamily: Strings
                                                              .gurmukhiAkkharThickFont,
                                                          fontSize: state
                                                              .pronunciationTipFontSize,
                                                          fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                          color: isDarkMode(
                                                                  context)
                                                              ? Theme.of(
                                                                      context)
                                                                  .dividerColor
                                                              : AppThemes
                                                                  .darkBlueColor,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7,
                                                            left: 25,
                                                            right: 25),
                                                    child: Text(
                                                      'mMgih: K`Kw Aqy g`gw mukqw bolo, ishwrI sMkoc ky bolo, ksky nhI bolxIAW',
                                                      style: TextStyle(
                                                        fontSize: Preferences
                                                                .getPronunciationTipFontSize() -
                                                            2,
                                                        fontFamily: Strings
                                                            .gurmukhiFont,
                                                        color: isDarkMode(
                                                                context)
                                                            ? Theme.of(
                                                                    context)
                                                                .dividerColor
                                                            : const Color(
                                                                0xFF525252),
                                                      ),
                                                    ),
                                                  ),
                                                  BlocBuilder<
                                                      DisplaySettingsBloc,
                                                      DisplaySettingsState>(
                                                    builder:
                                                        (context, state) {
                                                      return Visibility(
                                                        visible: state
                                                            .transLiteration!,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 7,
                                                                    left: 25,
                                                                    right:
                                                                        25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return Text(
                                                                'Aakhehi mangehi dhaehi dhaehi daath karae daathaar',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: state
                                                                      .transliterationFontSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: isDarkMode(context) ? AppThemes.blueColor : Theme.of(context).primaryColor,
                                                                ),
                                                              );
                                                            })),
                                                      );
                                                    },
                                                  ),
                                                  BlocBuilder<
                                                          DisplaySettingsBloc,
                                                          DisplaySettingsState>(
                                                      builder:
                                                          (context, state) {
                                                    return Visibility(
                                                        visible: state
                                                            .englishTranslation!,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 7,
                                                                    left: 25,
                                                                    right:
                                                                        25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return Text(
                                                                'People beg and pray, “Give to us, give to us”, and the Great Giver gives His Gifts.',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: state
                                                                      .englishTranslationFontSize,
                                                                  fontFamily:
                                                                      Strings
                                                                          .AcuminFont,
                                                                  color: isDarkMode(
                                                                          context)
                                                                      ? AppThemes
                                                                          .blueColor
                                                                      : Theme.of(context)
                                                                          .primaryColor,
                                                                ),
                                                              );
                                                            })));
                                                  }),
                                                  BlocBuilder<
                                                      DisplaySettingsBloc,
                                                      DisplaySettingsState>(
                                                    builder:
                                                        (context, state) {
                                                      return Visibility(
                                                        visible:
                                                            state.akhriAarth!,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(top: 15, left: 25, right: 25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return SelectableText
                                                                  .rich(
                                                                TextSpan(
                                                                  children: <
                                                                      InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '|',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            state.akhriArthFontSize,
                                                                        letterSpacing:
                                                                            2,
                                                                        wordSpacing:
                                                                            2,
                                                                        color:
                                                                            const Color(0xFFC91E86),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text: 'pihlw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.akhriArthFontSize,
                                                                          fontFamily:
                                                                              Strings.gurmukhiFont,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF525252),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            '  view more…',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.akhriArthFontSize! - 6,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF142849),
                                                                        )),
                                                                  ],
                                                                ),
                                                              );
                                                            })),
                                                      );
                                                    },
                                                  ),
                                                  BlocBuilder<
                                                      DisplaySettingsBloc,
                                                      DisplaySettingsState>(
                                                    builder:
                                                        (context, state) {
                                                      return Visibility(
                                                        visible: state
                                                            .detailedAarth!,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    left: 25,
                                                                    right:
                                                                        25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return SelectableText
                                                                  .rich(
                                                                TextSpan(
                                                                  children: <
                                                                      InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '|',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            state.detailedArthFontSize,
                                                                        letterSpacing:
                                                                            2,
                                                                        wordSpacing:
                                                                            2,
                                                                        color:
                                                                            const Color(0xFF288DD8),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text:
                                                                            ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.detailedArthFontSize,
                                                                          fontFamily:
                                                                              Strings.gurmukhiFont,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF525252),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            '  view more…',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.detailedArthFontSize! - 4,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF142849),
                                                                        )),
                                                                  ],
                                                                ),
                                                              );
                                                            })),
                                                      );
                                                    },
                                                  ),
                                                  BlocBuilder<
                                                      DisplaySettingsBloc,
                                                      DisplaySettingsState>(
                                                    builder:
                                                        (context, state) {
                                                      return Visibility(
                                                        visible: state
                                                            .detailedAarth!,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    left: 25,
                                                                    right:
                                                                        25),
                                                            child: BlocBuilder<
                                                                    DisplaySettingsBloc,
                                                                    DisplaySettingsState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return SelectableText
                                                                  .rich(
                                                                TextSpan(
                                                                  children: <
                                                                      InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '|',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            state.detailedArthFontSize,
                                                                        letterSpacing:
                                                                            2,
                                                                        wordSpacing:
                                                                            2,
                                                                        color:
                                                                            const Color(0xFFD86816),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text:
                                                                            ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.detailedArthFontSize,
                                                                          fontFamily:
                                                                              Strings.gurmukhiFont,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF525252),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            '  view more…',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              state.detailedArthFontSize! - 4,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: isDarkMode(context)
                                                                              ? const Color(0xFFDDDDDD)
                                                                              : const Color(0xFF142849),
                                                                        )),
                                                                  ],
                                                                ),
                                                              );
                                                            })),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Visibility(
                                        visible: state.paragraphStyle!,
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: _height,
                                            child: _paragraphStyle()))
                                  ],
                                );
                              })),
                        ),
                      ),
                    ),
                    _textToReport(context, isReportText),
                    _displaySettingsPopup(context, isDisplaySettingsVisible),
                    _addNotesPopup(context, isAddNotes),
                    _createNotePopup(context, createNote),
                    _moreOptionsPopUp(context, isMoreOptions),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 130),
                            child: _optionsPopup(context, isTextOptionsVisible),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child:
                                _mahankoshPopup(context, isTextOptionsVisible),
                          ),
                        ]),
                    _nextButton(context, isNextButtonVisible),
                    _showFadingBarOptions(isFadingBarEnable),
                  ],
                ),
              ),
            ),
          ),
        )))));
  }

  /*
   * return vew for paragraph style
   */
  Widget _paragraphStyle() {
    return Screenshot(
        key: Key('$index'),
        controller: screenshotController,
        child: Card(
            color: isBackgroundModeYellow(defaultThemeMode) ? AppThemes.yellowColorCardBg : Colors.transparent,
            margin: const EdgeInsets.only(top: 10),
            elevation: 0,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
                    child: BlocBuilder<DisplaySettingsBloc,
                        DisplaySettingsState>(builder: (context, state) {
                      return
                        Wrap(children: [
                            Visibility(visible: state.larrivarStyle!,child: SelectableText.rich(TextSpan(
                              children: <
                                  InlineSpan>[
                                TextSpan(
                                  text:'AwKihmMgihdyihdyihdwiqkrydwqwru]',
                                  style: TextStyle(
                                    fontSize: state.larrivarFontSize,
                                    fontFamily: Strings.gurmukhiAkkharThickFont,
                                    color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                  ),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      manageWidget(ManageWidgets.moreOptionsSettings);
                                    },
                                ),
                              ],
                            ),)),
                        Padding(padding: EdgeInsets.only(top: state.larrivarStyle!?5:0),
                        child:SelectableText.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(
                              alignment: ui.PlaceholderAlignment.middle,
                              child: Visibility(
                                visible: isReportText,
                                child: IconButton(
                                  iconSize: 25,
                                  padding: const EdgeInsets.all(1.0),
                                  onPressed: () {
                                    setState(() {
                                      isReportTextSelected =
                                          !isReportTextSelected;
                                      isNextButtonVisible =
                                          isReportTextSelected;
                                    });
                                  },
                                  icon: isReportTextSelected
                                      ? Image.asset(
                                          AssetsName.ic_checkbox_checked,
                                          color: isDarkMode(context)
                                              ? Theme.of(context)
                                                  .indicatorColor
                                              : Theme.of(context)
                                                  .primaryColor,
                                          width: 25,
                                          height: 25)
                                      : Image.asset(
                                          AssetsName.ic_checkbox_unchecked,
                                          color: isDarkMode(context)
                                              ? Theme.of(context)
                                                  .indicatorColor
                                              : Theme.of(context)
                                                  .primaryColor,
                                          width: 20,
                                          height: 20,
                                        ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: '(AwK-ih) (mMg-ih)',
                              style: TextStyle(
                                fontSize: state.gurmukhiFontSize! - 6,
                                fontFamily: Strings.gurbaniAkharLightFont,
                                color: isDarkMode(context)
                                    ? Theme.of(context).indicatorColor
                                    : AppThemes.greyTextColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _optionsPopup(
                                      context, isTextOptionsVisible);
                                },
                            ),
                            TextSpan(
                              text: 'AwKih mMgih dyih dyih dwiq kry dwqwru ] Pyir ik AgY rKIAY ijqu idsY drbwru ] muhO ik bolxu bolIAY ijqu suix Dry ipAwru ] AMimRq vylw scu nwau vifAweI vIcwru ] krmI AwvY kpVw ndrI moKu duAwru ] nwnk eyvY jwxIAY sBu Awpy sicAwru ]4] QwipAw n jwie kIqw n hoie ] Awpy Awip inrMjnu soie ] ijin syivAw iqin pwieAw mwnu ] nwnk gwvIAY guxI inDwnu ] gwvIAY suxIAY min rKIAY Bwau ] duKu prhir suKu Gir lY jwie ] gurmuiK nwdM gurmuiK vydM gurmuiK rihAw smweI ] guru eIsru guru gorKu brmw guru pwrbqI mweI ] jy hau jwxw AwKw nwhI khxw kQnu n jweI ] gurw iek dyih buJweI ] sBnw jIAw kw ieku dwqw so mY ivsir n jweI ]5] qIriQ nwvw jy iqsu Bwvw ivxu Bwxy ik nwie krI ] jyqI isriT aupweI vyKw ivxu krmw ik imlY leI ] miq ivic rqn jvwhr mwixk jy iek gur kI isK suxI ] gurw iek dyih buJweI ] sBnw jIAw kw ieku dwqw so mY ivsir n jweI ]6] jy jug cwry Awrjw hor dsUxI hoie ] nvw KMfw ivic jwxIAY nwil clY sBu koie ] cMgw nwau rKwie kY jsu kIriq jig lyie ] jy iqsu ndir n AwveI q vwq n puCY ky ] kItw AMdir kItu kir dosI dosu Dry ] nwnk inrguix guxu kry guxvMiqAw guxu dy ] qyhw koie n suJeI ij iqsu guxu koie kry ]7] suixAY isD pIr suir nwQ ] suixAY Driq Dvl Awkws ] suixAY dIp loA pwqwl ] suixAY poih n skY kwlu ] nwnk Bgqw sdw ivgwsu ] suixAY dUK pwp kw nwsu ]8] suixAY eIsru brmw ieMdu ] suixAY muiK swlwhx mMdu ] suixAY jog jugiq qin Byd ] suixAY swsq isimRiq vyd ] nwnk Bgqw sdw ivgwsu ] suixAY dUK pwp kw nwsu ]9] suixAY squ sMqoKu igAwnu ] suixAY ATsiT kw iesnwnu ] suixAY piV piV pwvih mwnu ] suixAY lwgY shij iDAwnu ] nwnk Bgqw sdw ivgwsu ] suixAY dUK pwp kw nwsu ]10] suixAY srw guxw ky gwh ] suixAY syK pIr pwiqswh ] suixAY AMDy pwvih rwhu ] suixAY hwQ hovY Asgwhu ] nwnk Bgqw sdw ivgwsu ] suixAY dUK pwp kw nwsu ]11] mMny kI giq khI n jwie ] jy ko khY ipCY pCuqwie ] kwgid klm n ilKxhwru ] mMny kw bih krin vIcwru ] AYsw nwmu inrMjnu hoie ] jy ko mMin jwxY min koie ]12] mMnY suriq hovY min buiD ] mMnY sgl Bvx kI suiD ] mMnY muih cotw nw Kwie ] mMnY jm kY swiQ n jwie ] AYsw nwmu inrMjnu hoie ] jy ko mMin jwxY min koie ]13]',
                              style: TextStyle(
                                fontSize: state.gurmukhiFontSize,
                                fontFamily: Strings.gurmukhiAkkharThickFont,
                                color: isDarkMode(context)
                                    ? Theme.of(context).indicatorColor
                                    : Theme.of(context).primaryColorDark,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _optionsPopup(
                                      context, isTextOptionsVisible);
                                },
                            ),
                          ],
                        ),
                     ),)]);
                    })),
              ],
            )));
  }

  /*
   *  return view according selected bg
   */
  Widget _topViewFloralBg(
    bool isVisible,
  ) {
    return Visibility(
      visible: isVisible,
      child: BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
          builder: (context, state) {
        return Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                        "rwg",
                        false,
                        textColorTheme(context),
                        state.gurmukhiFontSize! - 6,
                        1.0,
                        false,
                        false,
                        context,
                        20,
                        FontWeight.normal,
                        Strings.gurmukhiAkkharThickFont),
                    text(
                        'AMg 1238',
                        false,
                        textColorTheme(context),
                        state.gurmukhiFontSize! - 6,
                        1.0,
                        false,
                        false,
                        context,
                        20,
                        FontWeight.normal,
                        Strings.gurmukhiAkkharThickFont),
                    text(
                        'lyKwrI',
                        false,
                        textColorTheme(context),
                        state.gurmukhiFontSize! - 6,
                        1.0,
                        false,
                        false,
                        context,
                        20,
                        FontWeight.normal,
                        Strings.gurmukhiAkkharThickFont),
                  ],
                )));
      }),
    );
  }

  /*
   custom top view
   */
  Widget _topView(
    bool isVisible,
  ) {
    return Visibility(
      visible: isVisible,
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 15, left: 25, right: 25),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                builder: (context, state) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(
                          'lyKwrI',
                          false,
                          Theme.of(context).indicatorColor,
                          state.gurmukhiFontSize! - 10,
                          1.0,
                          false,
                          false,
                          context,
                          5,
                          FontWeight.normal,
                          Strings.gurmukhiAkkharThickFont),
                      text(
                          "rwg",
                          false,
                          Theme.of(context).indicatorColor,
                          state.gurmukhiFontSize! - 10,
                          1.0,
                          false,
                          false,
                          context,
                          5,
                          FontWeight.normal, Strings.gurmukhiAkkharThickFont),
                    ],
                  ),
                  text(
                      'AMg 1238',
                      false,
                      Theme.of(context).indicatorColor,
                      state.gurmukhiFontSize! - 10,
                      1.0,
                      false,
                      false,
                      context,
                      5,
                      FontWeight.normal,
                      Strings.gurmukhiAkkharThickFont),
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  /*
   * audio, bookmark, favorite etc options
   */
  Widget _optionsPopup(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: 170,
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(1),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                                _addToFavorite();
                              });
                            },
                            icon: isFavorite
                                ? SvgPicture.asset(
                                    AssetsName.ic_favourite_selected,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill,
                                    color: Theme.of(context).dividerColor,
                                  )
                                : Image.asset(AssetsName.ic_favourite,
                                    width: 30, height: 30, fit: BoxFit.fill),
                          ),
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(1),
                            onPressed: () {
                              manageWidget(ManageWidgets.AddNoteSettings);
                            },
                            icon: SvgPicture.asset(AssetsName.ic_resource,
                                color: Theme.of(context).dividerColor,
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill),
                          ),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            text(
                                Strings.favorites,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                            text(
                                Strings.addNotes,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                          ]),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(1),
                            onPressed: () {
                              setState(() {
                                isBookmark = !isBookmark;
                                _updateBookMark();
                              });
                            },
                            icon: isBookmark
                                ? SvgPicture.asset(
                                    AssetsName.ic_bookmark_selected,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill,
                                    color: Theme.of(context).dividerColor,
                                  )
                                : Image.asset(AssetsName.ic_bookmark,
                                    color: Theme.of(context).dividerColor,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill),
                          ),
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(1),
                            onPressed: () {
                              setState(() {
                                isAudioEnable = !isAudioEnable;
                              });
                            },
                            icon: isAudioEnable
                                ? Icon(
                                    Icons.volume_off_sharp,
                                    size: 40,
                                    color: Theme.of(context).dividerColor,
                                  )
                                : Image.asset(AssetsName.ic_audio,
                                    color: Theme.of(context).dividerColor,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill),
                          ),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            text(
                                Strings.bookMarkTuk,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                            text(
                                Strings.audio,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                          ])
                    ],
                  ),
                ),
              )
            ]));
  }

  /*
   * Mahankosh Options
   */
  Widget _mahankoshPopup(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(20))),
                width: 150,
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            iconSize: 35,
                            padding: const EdgeInsets.only(left: 20),
                            onPressed: () {
                              _showMahankoshShabadAlert();
                            },
                            icon: Image.asset(AssetsName.ic_mahakosh,
                                width: 40, height: 30, fit: BoxFit.fill),
                          ),
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.only(right: 10),
                            onPressed: () {
                              setState(() {
                                isMahakoshAudioEnable = !isMahakoshAudioEnable;
                              });
                            },
                            icon: isMahakoshAudioEnable
                                ? Icon(
                                    Icons.volume_off_sharp,
                                    size: 40,
                                    color: Theme.of(context).dividerColor,
                                  )
                                : Image.asset(AssetsName.ic_audio,
                                    width: 30, height: 30, fit: BoxFit.fill),
                          ),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            text(
                                Strings.mahakosh,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                            text(
                                Strings.audio,
                                true,
                                Theme.of(context).indicatorColor,
                                10.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.normal),
                          ]),
                    ],
                  ),
                ),
              )
            ]));
  }

  /*
   *  Function to manage widget Visibility
   */
  void manageWidget(ManageWidgets settings) {
    setState(() {
      switch (settings.name) {
        case Strings.DISPLAY_SETTINGS:
          {
            isDisplaySettingsVisible = !isDisplaySettingsVisible;
            isAddNotes = false;
            createNote = false;
            isMoreOptions = false;
            isReportText = false;
            isTextOptionsVisible = false;
            isNextButtonVisible = false;
            isFadingBarEnable = false;
          }
          break;
        case Strings.CREATE_NOTE_SETTINGS:
          {
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            createNote = false;
            isMoreOptions = false;
            isReportText = false;
            isNextButtonVisible = false;
            isAddNotes = !isAddNotes;
            isFadingBarEnable = false;
          }
          break;
        case Strings.MORE_OPTIONS_SETTINGS:
          {
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            createNote = false;
            isMoreOptions = false;
            isReportText = false;
            isNextButtonVisible = false;
            isMoreOptions = !isMoreOptions;
            isFadingBarEnable = false;
          }
          break;
        case Strings.REPORT_TEXT:
          {
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            createNote = false;
            isMoreOptions = false;
            isNextButtonVisible = false;
            isAddNotes = false;
            isReportText = !isReportText;
            isFadingBarEnable = false;
          }
          break;
        case Strings.ADD_NOTE_SETTINGS:
          {
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            isAddNotes = false;
            isMoreOptions = false;
            isReportText = false;
            createNote = !createNote;
            isFadingBarEnable = false;
          }
          break;
        default:
          {
            isDisplaySettingsVisible = false;
            isTextOptionsVisible = false;
            createNote = false;
            isAddNotes = false;
            isMoreOptions = false;
            isReportText = false;
            isNextButtonVisible = false;
            isMoreOptions = false;
            isReportTextSelected = false;
          }
      }
    });
  }

  /*
  * popup yo change display settings
   */
  Widget _displaySettingsPopup(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 25, right: 130),
                child: CustomPaint(
                    painter: CustomShape(
                        Theme.of(context).scaffoldBackgroundColor)),
              ),
              Flexible(
                child: Container(
                    margin: const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
                    color: (Theme.of(context).scaffoldBackgroundColor),
                    padding: const EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // theme mode drop down
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      Strings.background,
                                      false,
                                      Theme.of(context).dividerColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      10,
                                      FontWeight.bold),
                                  IconButton(
                                      iconSize: 40,
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: Theme.of(context).dividerColor,
                                        size: 40,
                                      )),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: defaultThemeMode,
                                  iconEnabledColor:
                                      Theme.of(context).indicatorColor,
                                  iconDisabledColor:
                                      Theme.of(context).indicatorColor,
                                  dropdownColor:
                                      Theme.of(context).disabledColor,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items:
                                      backgroundModeList.map((String items) {
                                    return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (String? value1) {
                                    manageWidget(
                                        ManageWidgets.defaultSettings);
                                    changeBackgroundColor(value1);
                                    defaultThemeMode = value1;
                                    isBackgroundModeYellow(defaultThemeMode);
                                  },
                                ),
                              ),
                            ),
                          ),
                          //notifications settings
                          _divider(15),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15),
                            child: text(
                                Strings.gurmukhi,
                                false,
                                Theme.of(context).dividerColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                1,
                                FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                                    builder: (context, state) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.larrivar,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      SizedBox(
                                        height: 35,
                                        //set desired REAL HEIGHT
                                        width: 60,
                                        // set desire Real WIDTH
                                        child: Transform.scale(
                                          transformHitTests: false,
                                          scale: 0.7,
                                          child: CupertinoSwitch(
                                            value: state.larrivarStyle!,
                                            onChanged: (value) {
                                              context
                                                  .read<DisplaySettingsBloc>()
                                                  .add(GurbaniViewStyleChanged(
                                                      larrivarStyle: value));
                                            },
                                            activeColor: Theme.of(context)
                                                .dividerColor,
                                            trackColor:
                                                disableSwitchTheme(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                Padding(padding: const EdgeInsets.only(top: 5),child:Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    text(
                                        Strings.fontSize,
                                        false,
                                        Theme.of(context).indicatorColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        1,
                                        FontWeight.normal),
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  context.read<DisplaySettingsBloc>().add(FontIncrementPressed(gurmukhiFontSize: Preferences.getGurbaniFontSize()));
                                                },
                                                child: Image.asset(
                                                  AssetsName.ic_plus,
                                                  width: 15,
                                                  height: 15,
                                                  fit: BoxFit.scaleDown,
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  alignment:
                                                  Alignment.centerRight,
                                                ),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 20),
                                              child: InkWell(
                                                  onTap: () {
                                                    context.read<DisplaySettingsBloc>().add(FontDecrementPressed(gurmukhiFontSize: Preferences.getGurbaniFontSize()));
                                                  },
                                                  child: Image.asset(
                                                      AssetsName.ic_minus,
                                                      width: 15,
                                                      height: 15,
                                                      fit: BoxFit.scaleDown,
                                                      color: Theme.of(context)
                                                          .indicatorColor,
                                                      alignment: Alignment
                                                          .centerLeft))),
                                        ]),
                                  ],
                                )),
                                BlocBuilder<DisplaySettingsBloc,
                                    DisplaySettingsState>(
                                    builder: (context, state) {
                                      return Padding(padding: EdgeInsets.only(top: 5),child:Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          text(
                                              Strings.larrivarWithBisram,
                                              false,
                                              Theme.of(context).indicatorColor,
                                              18.0,
                                              1.0,
                                              false,
                                              false,
                                              context,
                                              1,
                                              FontWeight.normal),
                                          SizedBox(
                                            height: 35,
                                            //set desired REAL HEIGHT
                                            width: 60,
                                            // set desire Real WIDTH
                                            child: Transform.scale(
                                              transformHitTests: false,
                                              scale: 0.7,
                                              child: CupertinoSwitch(
                                                value: state.larrivarWithBisRamStyle!,
                                                onChanged: (value) {
                                                  context
                                                      .read<DisplaySettingsBloc>()
                                                      .add(LarrivarBisramStyleChanged(
                                                      larriavrBisramStyle: value));
                                                },
                                                activeColor: Theme.of(context)
                                                    .dividerColor,
                                                trackColor:
                                                disableSwitchTheme(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                    }),
                                Padding(padding: EdgeInsets.only(top: 5),child:Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    text(
                                        Strings.fontSize,
                                        false,
                                        Theme.of(context).indicatorColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        1,
                                        FontWeight.normal),
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  context.read<DisplaySettingsBloc>().add(FontIncrementPressed(larrivarFontSize: Preferences.getLarrivarFontSize()));
                                                },
                                                child: Image.asset(
                                                  AssetsName.ic_plus,
                                                  width: 15,
                                                  height: 15,
                                                  fit: BoxFit.scaleDown,
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  alignment:
                                                  Alignment.centerRight,
                                                ),
                                              )),
                                          Padding(padding: const EdgeInsets.only(left: 10, right: 20),
                                              child: InkWell(
                                                  onTap: () {
                                                    context.read<DisplaySettingsBloc>().add(FontDecrementPressed(larrivarFontSize: Preferences.getLarrivarFontSize()));
                                                  },
                                                  child: Image.asset(
                                                      AssetsName.ic_minus,
                                                      width: 15,
                                                      height: 15,
                                                      fit: BoxFit.scaleDown,
                                                      color: Theme.of(context).indicatorColor,
                                                      alignment: Alignment.centerLeft))),
                                        ]),
                                  ],
                                )),
                                BlocBuilder<DisplaySettingsBloc,
                                        DisplaySettingsState>(
                                    builder: (context, state) {
                                  return Padding(padding: EdgeInsets.only(top: 5),child:Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.paragraph,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      SizedBox(
                                        height: 35,
                                        //set desired REAL HEIGHT
                                        width: 60,
                                        // set desire Real WIDTH
                                        child: Transform.scale(
                                          transformHitTests: false,
                                          scale: 0.7,
                                          child: CupertinoSwitch(
                                            value: state.paragraphStyle!,
                                            onChanged: (value) {
                                              context
                                                  .read<DisplaySettingsBloc>()
                                                  .add(ParagraphStyleChanged(paragraphStyle: value));
                                            },
                                            activeColor: Theme.of(context)
                                                .dividerColor,
                                            trackColor:
                                                disableSwitchTheme(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                                }),
                              ],
                            ),
                          ),
                          _divider(15),
                          Padding(padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text(
                                    Strings.bisrams,
                                    false,
                                    Theme.of(context).dividerColor,
                                    18.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    1,
                                    FontWeight.bold),
                                BlocBuilder<DisplaySettingsBloc,
                                    DisplaySettingsState>(
                                    builder: (context, state) {
                                  return SizedBox(
                                    height: 35, //set desired REAL HEIGHT
                                    width: 60, // set desire Real WIDTH
                                    child: Transform.scale(
                                      transformHitTests: false,
                                      scale: 0.7,
                                      child: CupertinoSwitch(
                                        value: state.bisramStyle!,
                                        onChanged: (value) {
                                          context.read<DisplaySettingsBloc>().add(BisramStyleChanged(bisramStyle: value));
                                        },
                                        activeColor: Theme.of(context).dividerColor,
                                        trackColor: disableSwitchTheme(context),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          //learn to navigate
                          _divider(15),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text(
                                    Strings.pronunciationTips,
                                    false,
                                    Theme.of(context).dividerColor,
                                    18.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    15,
                                    FontWeight.bold),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5, top: 10),
                                        child: InkWell(
                                          onTap: () {
                                            context.read<DisplaySettingsBloc>()
                                                .add(FontIncrementPressed(pronunciationTipFontSize: Preferences.getPronunciationTipFontSize()));
                                          },
                                          child: Image.asset(
                                              AssetsName.ic_plus,
                                              width: 15,
                                              height: 15,
                                              fit: BoxFit.scaleDown,
                                              color: Theme.of(context).indicatorColor,
                                              alignment: Alignment.centerRight),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 20, top: 10),
                                        child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<DisplaySettingsBloc>()
                                                  .add(FontDecrementPressed(
                                                      pronunciationTipFontSize: Preferences.getPronunciationTipFontSize()));
                                            },
                                            child: Image.asset(
                                                AssetsName.ic_minus,
                                                width: 15,
                                                height: 15,
                                                fit: BoxFit.scaleDown,
                                                color: Theme.of(context).indicatorColor,
                                                alignment: Alignment.centerLeft)),
                                      )
                                    ]),
                              ],
                            ),
                          ),

                          _divider(15),
                          Padding(padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.transliteration,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.bold),
                                      BlocBuilder<DisplaySettingsBloc,
                                          DisplaySettingsState>(
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 35,
                                            //set desired REAL HEIGHT
                                            width: 60,
                                            // set desire Real WIDTH
                                            child: Transform.scale(
                                              transformHitTests: false,
                                              scale: 0.7,
                                              child: CupertinoSwitch(
                                                value: state.transLiteration!,
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          DisplaySettingsBloc>()
                                                      .add(
                                                          TransLiterationChanged(
                                                              transLiteration:
                                                                  value));
                                                },
                                                activeColor: Theme.of(context)
                                                    .dividerColor,
                                                trackColor:
                                                    disableSwitchTheme(
                                                        context),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.fontSize,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            DisplaySettingsBloc>()
                                                        .add(FontIncrementPressed(
                                                            transliterationFontSize:
                                                                Preferences
                                                                    .getTransliterationFontSize()));
                                                  },
                                                  child: Image.asset(
                                                      AssetsName.ic_plus,
                                                      width: 15,
                                                      height: 15,
                                                      fit: BoxFit.scaleDown,
                                                      color: Theme.of(context)
                                                          .indicatorColor,
                                                      alignment: Alignment
                                                          .centerRight),
                                                )),
                                            Padding(padding: const EdgeInsets.only(
                                                        left: 10, right: 20),
                                                child: InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<DisplaySettingsBloc>()
                                                          .add(FontDecrementPressed(
                                                              transliterationFontSize: Preferences.getTransliterationFontSize()));
                                                    },
                                                    child: Image.asset(
                                                        AssetsName.ic_minus,
                                                        width: 15,
                                                        height: 15,
                                                        fit: BoxFit.scaleDown,
                                                        color: Theme.of(
                                                                context)
                                                            .indicatorColor,
                                                        alignment: Alignment
                                                            .centerLeft))),
                                          ]),
                                    ],
                                  ),
                                ]),
                          ),
                          _divider(15),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.akhriArth,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.bold),
                                      BlocBuilder<DisplaySettingsBloc,
                                          DisplaySettingsState>(
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 35,
                                            //set desired REAL HEIGHT
                                            width: 60,
                                            // set desire Real WIDTH
                                            child: Transform.scale(
                                              transformHitTests: false,
                                              scale: 0.7,
                                              child: CupertinoSwitch(
                                                value: state.akhriAarth!,
                                                onChanged: (value) {
                                                  context.read<DisplaySettingsBloc>().add(AakhriArthChanged(aakhriArth: value));
                                                },
                                                activeColor: Theme.of(context).dividerColor,
                                                trackColor: disableSwitchTheme(context),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.fontSize,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            DisplaySettingsBloc>()
                                                        .add(FontIncrementPressed(
                                                            akhriArthFontSize:
                                                                Preferences
                                                                    .getAkhriArthFontSize()));
                                                  },
                                                  child: Image.asset(
                                                      AssetsName.ic_plus,
                                                      width: 15,
                                                      height: 15,
                                                      fit: BoxFit.scaleDown,
                                                      color: Theme.of(context)
                                                          .indicatorColor,
                                                      alignment: Alignment
                                                          .centerRight),
                                                )),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 10, right: 20),
                                                child: InkWell(
                                                    onTap: () {
                                                      context.read<DisplaySettingsBloc>().add(FontDecrementPressed(
                                                              akhriArthFontSize: Preferences.getAkhriArthFontSize()));
                                                    },
                                                    child: Image.asset(
                                                        AssetsName.ic_minus,
                                                        width: 15,
                                                        height: 15,
                                                        fit: BoxFit.scaleDown,
                                                        color: Theme.of(context).indicatorColor,
                                                        alignment: Alignment.centerLeft))),
                                          ]),
                                    ],
                                  ),
                                ]),
                          ),
                          _divider(15),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.detailedArth,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.bold),
                                      BlocBuilder<DisplaySettingsBloc,
                                          DisplaySettingsState>(
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 35,
                                            //set desired REAL HEIGHT
                                            width: 60,
                                            // set desire Real WIDTH
                                            child: Transform.scale(
                                              transformHitTests: false,
                                              scale: 0.7,
                                              child: CupertinoSwitch(
                                                value: state.detailedAarth!,
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          DisplaySettingsBloc>()
                                                      .add(
                                                          DetailedArthChanged(
                                                              detailediArth:
                                                                  value));
                                                },
                                                activeColor: Theme.of(context).dividerColor,
                                                trackColor: disableSwitchTheme(context),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.fontSize,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    context.read<DisplaySettingsBloc>().add(FontIncrementPressed(
                                                            detailedArthFontSize: Preferences.getDetailedArthFontSize()));
                                                  },
                                                  child: Image.asset(
                                                      AssetsName.ic_plus,
                                                      width: 15,
                                                      height: 15,
                                                      fit: BoxFit.scaleDown,
                                                      color: Theme.of(context)
                                                          .indicatorColor,
                                                      alignment: Alignment
                                                          .centerRight),
                                                )),
                                            Padding(padding: const EdgeInsets.only(left: 10, right: 20),
                                                child: InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              DisplaySettingsBloc>()
                                                          .add(FontDecrementPressed(
                                                              detailedArthFontSize:
                                                                  Preferences
                                                                      .getDetailedArthFontSize()));
                                                    },
                                                    child: Image.asset(
                                                        AssetsName.ic_minus,
                                                        width: 15,
                                                        height: 15,
                                                        fit: BoxFit.scaleDown,
                                                        color: Theme.of(
                                                                context)
                                                            .indicatorColor,
                                                        alignment: Alignment
                                                            .centerLeft))),
                                          ]),
                                    ],
                                  ),
                                ]),
                          ),
                          _divider(15),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.englishTranslation,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.bold),
                                      BlocBuilder<DisplaySettingsBloc,
                                          DisplaySettingsState>(
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 35,
                                            //set desired REAL HEIGHT
                                            width: 60,
                                            // set desire Real WIDTH
                                            child: Transform.scale(
                                              transformHitTests: false,
                                              scale: 0.7,
                                              child: CupertinoSwitch(
                                                value: state.englishTranslation!,
                                                onChanged: (value) {
                                                  context.read<DisplaySettingsBloc>().add(EnglishTranslationChanged(englishTranslation: value));
                                                },
                                                activeColor: Theme.of(context).dividerColor,
                                                trackColor: disableSwitchTheme(context),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(
                                          Strings.fontSize,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          1,
                                          FontWeight.normal),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(padding: const EdgeInsets.only(left: 5, bottom: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  context.read<DisplaySettingsBloc>().add(FontIncrementPressed(englishTranslatiFontSize: Preferences.getEnglishTranslationFontSize()));
                                                },
                                                child: Image.asset(
                                                    AssetsName.ic_plus,
                                                    width: 15,
                                                    height: 15,
                                                    fit: BoxFit.scaleDown,
                                                    color: Theme.of(context).indicatorColor,
                                                    alignment: Alignment.centerRight),
                                              ),
                                            ),
                                            Padding(padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
                                                child: InkWell(
                                                    onTap: () {
                                                      context.read<DisplaySettingsBloc>().add(FontDecrementPressed(englishTranslatiFontSize: Preferences.getEnglishTranslationFontSize()));
                                                    },
                                                    child: Image.asset(
                                                        AssetsName.ic_minus,
                                                        width: 15,
                                                        height: 15,
                                                        fit: BoxFit.scaleDown,
                                                        color: Theme.of(context).indicatorColor,
                                                        alignment: Alignment.centerLeft))),
                                          ]),
                                    ],
                                  ),
                                ]),
                          ),
                          _divider(1),
                          const Padding(padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ));
  }

  /*
   function to show divider
  */
  Widget _divider(double padding) {
    return divider(
        color: AppThemes.greyDivider.withOpacity(0.4),
        thickness: 0.5,
        height: 5,
        indent: 1,
        endIndent: 0.0,
        padding: padding);
  }

  Widget _displaySettingsPopUpTopView(
      BuildContext context, bool _isVisible, double padding, Color color) {
    return Visibility(
      visible: _isVisible,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.only(top: 0, left: 25, right: padding),
              child: CustomPaint(painter: CustomShape(color)),
            ),
          ]),
    );
  }

  /*
   *  Add notes popup view
   */
  Widget _addNotesPopup(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: const EdgeInsets.only(top: 0, left: 25, right: 120),
                child: CustomPaint(painter: CustomShape(Theme.of(context).scaffoldBackgroundColor)),
              ),
              Flexible(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 25, right: 25, top: 0, bottom: 15),
                    color: (Theme.of(context).scaffoldBackgroundColor),
                    padding: const EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding:const EdgeInsets.only(left: 30, right: 30),
                            child: text(
                                Strings.addNotes,
                                false,
                                Theme.of(context).dividerColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                25,
                                FontWeight.bold),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 15, right: 15),
                            child: GestureDetector(
                              onTap: () {
                                manageWidget(ManageWidgets.AddNoteSettings);
                              },
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    text(Strings.newNote,
                                        false,
                                        Theme.of(context).indicatorColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        0,
                                        FontWeight.normal),
                                    Padding(padding: const EdgeInsets.only(left: 5, top: 0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Image.asset(AssetsName.ic_plus,
                                            width: 15,
                                            height: 15,
                                            fit: BoxFit.scaleDown,
                                            color: Theme.of(context).indicatorColor,
                                            alignment: Alignment.centerRight),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 5, left: 30, right: 30),
                            child: InkWell(
                              onTap: () {
                                _createFolder();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(Strings.newFolder,
                                      false,
                                      Theme.of(context).dividerColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      15,
                                      FontWeight.normal),
                                  Padding(padding: const EdgeInsets.only(left: 5, top: 10),
                                    child: Image.asset(AssetsName.ic_plus,
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.scaleDown,
                                        color: Theme.of(context).dividerColor,
                                        alignment: Alignment.centerRight),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 1, left: 30, right: 25),
                          child: BlocBuilder<FolderBloc, FolderState>(
                          builder: (context, state) {
                            if (state is FolderInitial) {
                              context.read<FolderBloc>().add(FolderFetched());
                              return showLoader();
                            } else if (state is FolderLoaded) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<FolderModel>(
                                  value: folderNameList1[i],
                                  iconSize: 32,
                                  iconEnabledColor:
                                  Theme
                                      .of(context)
                                      .indicatorColor,
                                  iconDisabledColor:
                                  Theme
                                      .of(context)
                                      .indicatorColor,
                                  dropdownColor: Theme
                                      .of(context)
                                      .primaryColor,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: folderNameList1.map<
                                      DropdownMenuItem<FolderModel>>((
                                      FolderModel items) {
                                    return DropdownMenuItem<FolderModel>(
                                      value: items,
                                      child: text(
                                          items.name,
                                          false,
                                          Theme.of(context).indicatorColor,
                                          16.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          15,
                                          FontWeight.normal),
                                    );
                                  }
                                  ).toList(),
                                  onChanged: (FolderModel? value2) {
                                    //if(folderNameList1.isNotEmpty) {
                                    setState(() {
                                      i = value2!.id!-1;
                                      folderName = value2;
                                    });
                                    // }
                                  },
                                ),
                              );
                            } else {
                              return DropdownButtonHideUnderline(
                                  child: DropdownButton<FolderModel>(
                                  value: folderNameList1[i],
                                  iconSize: 32,
                                  iconEnabledColor:
                                  Theme.of(context).indicatorColor,
                            iconDisabledColor: Theme.of(context).indicatorColor,
                            dropdownColor: Theme.of(context).primaryColor,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: folderNameList1.map<
                            DropdownMenuItem<FolderModel>>((
                            FolderModel items) {
                            return DropdownMenuItem<FolderModel>(
                            value: items,
                            child: text(
                            items.name,
                            false,
                            Theme
                                .of(context)
                                .indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            15,
                            FontWeight.normal),
                            );
                            }
                            ).toList(),
                            onChanged: (FolderModel? value2) {
                            //if(folderNameList1.isNotEmpty) {
                            setState(() {
                            i = value2!.id!-1;
                            folderName = value2;
                            });
                            // }
                            },
                            ));
                            }
                          }
                          )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 40, right: 35),
                              child: text(
                                  'Gurbani pangti here',
                                  false,
                                  Theme.of(context).indicatorColor,
                                  16.0,
                                  1.0,
                                  false,
                                  false,
                                  context,
                                  1,
                                  FontWeight.normal)),
                          _divider(15),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30, right: 30),
                            child: text(
                                Strings.favorites,
                                false,
                                Theme.of(context).dividerColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                10,
                                FontWeight.bold),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 15, right: 15),
                            child: InkWell(
                              onTap: () {
                                _addToFavorite();
                              },
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    text(
                                        Strings.addFavorite,
                                        false,
                                        Theme.of(context).indicatorColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        1,
                                        FontWeight.normal),
                                    Padding(padding: const EdgeInsets.only(left: 5, top: 1),
                                      child: Image.asset(AssetsName.ic_plus,
                                          width: 15,
                                          height: 15,
                                          fit: BoxFit.scaleDown,
                                          color: Theme.of(context)
                                              .indicatorColor,
                                          alignment: Alignment.centerRight),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 5, left: 30, right: 30),
                            child: InkWell(
                              onTap: () {
                                _createFolder();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      Strings.newFolder,
                                      false,
                                      Theme.of(context).dividerColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      15,
                                      FontWeight.normal),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 15),
                                    child: Image.asset(AssetsName.ic_plus,
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.scaleDown,
                                        color: Theme.of(context).dividerColor,
                                        alignment: Alignment.centerRight),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return _expansionPanel(context);
                            },
                          ),
                          _divider(15),
                          Padding(padding: const EdgeInsets.only(left: 30, right: 30),
                            child: text(
                                Strings.kamaiyi,
                                false,
                                Theme.of(context).dividerColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                10,
                                FontWeight.bold),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text(
                                    Strings.newCounter,
                                    false,
                                    Theme.of(context).dividerColor,
                                    18.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    5,
                                    FontWeight.normal),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 5),
                                  child: InkWell(
                                    onTap: () {
                                    },
                                    child: Image.asset(AssetsName.ic_plus,
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.scaleDown,
                                        color: Theme.of(context).dividerColor,
                                        alignment: Alignment.centerRight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 30, right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text(
                                    'Counter Name',
                                    false,
                                    Theme.of(context).indicatorColor,
                                    18.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    10,
                                    FontWeight.normal),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(left: 5),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              count += 1;
                                            });
                                          },
                                          child: Image.asset(
                                              AssetsName.ic_plus,
                                              width: 15,
                                              height: 15,
                                              fit: BoxFit.scaleDown,
                                              color: Theme.of(context)
                                                  .indicatorColor,
                                              alignment: Alignment.centerRight),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: InkWell(
                                            onTap: () {
                                              if (count > 1) {
                                                setState(() {
                                                  count -= 1;
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                                AssetsName.ic_minus,
                                                width: 15,
                                                height: 15,
                                                fit: BoxFit.scaleDown,
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                alignment:
                                                    Alignment.centerLeft)),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0),
                            child: text(
                                '0$count/00',
                                false,
                                Theme.of(context).indicatorColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                10,
                                FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30, right: 30),
                            child: InkWell(
                              onTap: () {
                                _updateBookMark();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      Strings.newBookmark,
                                      false,
                                      Theme.of(context).dividerColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      5,
                                      FontWeight.normal),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5),
                                    child: Image.asset(AssetsName.ic_plus,
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.scaleDown,
                                        color: Theme.of(context).dividerColor,
                                        alignment: Alignment.centerRight),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30, right: 30),
                            child: text(
                                'Bookmark Name',
                                false,
                                Theme.of(context).indicatorColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                10,
                                FontWeight.normal),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 15),
                            child: text(
                                '[left off here…]',
                                false,
                                Theme.of(context).indicatorColor,
                                18.0,
                                1.0,
                                false,
                                false,
                                context,
                                5,
                                FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _expansionPanel(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 1, right: 15),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconColor: Theme.of(context).indicatorColor,
                    iconSize: 32,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                    padding: const EdgeInsets.only(
                        top: 1, left: 30, right: 30, bottom: 0),
                    child: text(
                        'Folder Name',
                        false,
                        Theme.of(context).indicatorColor,
                        17.0,
                        1.0,
                        false,
                        false,
                        context,
                        1,
                        FontWeight.normal),
                  ),
                  collapsed: const Text(
                    "",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 1),
                  ),
                  expanded: _pangtiView(context),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Pangti View
   */
  Widget _pangtiView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: pangtiList.length,
      padding: const EdgeInsets.only(left: 25, right: 25),
      itemBuilder: (context, index) {
        return text(pangtiList[index], false, Theme.of(context).indicatorColor,
            16.0, 1.0, false, false, context, 10, FontWeight.normal);
      },
    );
  }

  /*
   *  Add specific note with folder name
   */
  Widget _createNotePopup(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: SingleChildScrollView(
          child: SizedBox(
            height: _height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 25, right: 25, top: 0, bottom: 15),
                      color: (Theme.of(context).cursorColor),
                      padding: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 15),
                              child: text(
                                  Strings.newNote,
                                  false,
                                  Theme.of(context).hoverColor,
                                  18.0,
                                  1.0,
                                  false,
                                  false,
                                  context,
                                  10,
                                  FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                              child: Text(
                                'AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: Strings.gurmukhiFont,
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20),
                              child: TextFormField(
                                controller: TextEditingController(),
                                keyboardType: TextInputType.text,
                                cursorColor: Theme.of(context).indicatorColor,
                                maxLines: 13,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor,
                                    fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 15.0,
                                      bottom: 15.0),
                                  hintText: '',
                                  filled: true,
                                  fillColor: isDarkMode(context)
                                      ? Theme.of(context).cursorColor
                                      : Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: isDarkMode(context)
                                            ? Theme.of(context).disabledColor
                                            : Theme.of(context).cursorColor,
                                         width: 0.5),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                        color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).cursorColor, width: 0.5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 0),
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: isDarkMode(context) ? Theme.of(context).disabledColor : Theme.of(context).primaryColorDark.withOpacity(0.21),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: defaultFolderName,
                                    iconSize: 32,
                                    elevation: 0,
                                    iconEnabledColor: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark.withOpacity(0.60),
                                    iconDisabledColor: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark.withOpacity(0.60),
                                    dropdownColor: Theme.of(context).disabledColor,
                                    menuMaxHeight: 0,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: folderNameList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: text(
                                            items,
                                            false,
                                            isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                            18.0,
                                            1.0,
                                            false,
                                            false,
                                            context,
                                            5,
                                            FontWeight.normal),
                                      );
                                    }).toList(),
                                    onTap: () {
                                      setState(() {
                                        isDropDownOpen = !isDropDownOpen;
                                      });
                                    },
                                    onChanged: (String? value1) {},
                                  ),
                                ),
                              ),
                            ),
                            _dropDownView(isDropDownOpen),
                            _saveButton(context)
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  /*
   * save button
   */
  Widget _saveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                elevation: 2,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: isDarkMode(context)
                    ? Theme.of(context).dividerColor
                    : Theme.of(context).primaryColorDark,
                side: BorderSide(width: 2.0,
                    color: isDarkMode(context)
                        ? Theme.of(context).dividerColor
                        : Theme.of(context).primaryColorDark),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: text(
                Strings.save,
                false,
                isDarkMode(context)
                    ? Theme.of(context).primaryColorDark
                    : Theme.of(context).indicatorColor,
                18.0,
                1.0,
                false,
                false,
                context,
                0,
                FontWeight.w500),
            onPressed: () {
              manageWidget(ManageWidgets.AddNoteSettings);
            },
          ),
        ],
      ),
    );
  }

  /*
   *  Next button
   */
  Widget _nextButton(BuildContext context, bool _isVisible) {
    return Visibility(
      visible: _isVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      elevation: 2,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor: isDarkMode(context)
                          ? Theme.of(context).dividerColor
                          : Theme.of(context).primaryColorDark,
                      side: BorderSide(
                          width: 2.0,
                          color: isDarkMode(context)
                              ? Theme.of(context).dividerColor
                              : Theme.of(context).primaryColorDark),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: text(
                      Strings.next,
                      false,
                      isDarkMode(context)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).indicatorColor,
                      18.0,
                      1.0,
                      false,
                      false,
                      context,
                      0,
                      FontWeight.w500),
                     onPressed: () {
                    if (isReportTextSelectedPangti) {
                      _screenshot();
                    } else if (isReportTextSelected) {
                      takeScreenShot();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
   * More Options
   */
  Widget _moreOptionsPopUp(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInSine,
            child: Container(
              width: _width,
              height: 480,
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(left: _width / 6),
              color: (isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).primaryColor),
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: moreOptionsList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(padding: const EdgeInsets.only(
                        top: 25, bottom: 25, left: 30, right: 30),
                    child: InkWell(
                      child: text(
                          moreOptionsList[index],
                          false,
                          Theme.of(context).dividerColor,
                          18.0,
                          1.0,
                          false,
                          false,
                          context,
                          0,
                          FontWeight.bold),
                      onTap: () {
                        if (index == 0) {
                          navigationPage(context, sectionHelp, const SectionHelp());
                        } else if (index == 1) {
                          manageWidget(ManageWidgets.moreOptionsSettings);
                          _showBottomAudiobar(context);
                        } else if (index == 2) {
                          manageWidget(ManageWidgets.defaultSettings);
                          navigationPage(context, mediaListSongs, const MediaListSongs());
                        } else if (index == 3) {
                          manageWidget(ManageWidgets.moreOptionsSettings);
                          Timer(const Duration(seconds: 2), () {
                            takeScreenShot();
                          });
                        } else if (index == 4) {
                          manageWidget(ManageWidgets.defaultSettings);
                        } else if (index == 5) {
                          manageWidget(ManageWidgets.reportText);
                        }
                      },
                    ),
                  );
                },
              ),
            )));
  }

  /*
   * function for screen shot
   */
  _screenshot() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final File imagePath =
            await File('${directory.path}/screenshot.png').create();
        await imagePath.writeAsBytes(image);
        Navigator.pushNamed(
          context,
          reportMistakeForm,
          arguments: "" + imagePath.path,
        );
        manageWidget(ManageWidgets.defaultSettings);
      }
    });
  }

  /*
   * code to take screenshot
   */
  takeScreenShot() async {
    RenderRepaintBoundary? boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile =  File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    print("image>>$imgFile");
    if (directory.isNotEmpty || imgFile.existsSync()) {
      if (isReportTextSelected) {
        Navigator.pushNamed(context, reportMistakeForm,
            arguments: "" + imgFile.path);
        manageWidget(ManageWidgets.defaultSettings);
      } else {
        await Share.shareFiles([imgFile.path]);
      }
    }
  }

  /*
   * Report text view
   */
  Widget _textToReport(BuildContext context, bool _isVisible) {
    return Visibility(
        visible: _isVisible,
        child: Container(
          width: _width,
          color: (isDarkMode(context)
              ? AppThemes.blueEditTextBgColor
              : AppThemes.darkYellowColor),
          padding: const EdgeInsets.all(10),
          child: text(
              Strings.selectedTextToReport,
              true,
              isDarkMode(context)
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).primaryColorDark,
              16.0,
              1.0,
              false,
              false,
              context,
              0,
              FontWeight.normal),
        ));
  }

  /*
   * function to create new folder view
   */
  Future<void> _createFolder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context)
    {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cursorColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 260,
              color: Theme
                  .of(context)
                  .cursorColor,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: text(
                          Strings.newFolder,
                          false,
                          Theme.of(context).hoverColor,
                          18.0,
                          1.0,
                          false,
                          false,
                          context,
                          10,
                          FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                          style: TextStyle(color: Theme.of(context).focusColor,
                              fontSize: 18,
                              fontFamily: Strings.AcuminFont),
                          autocorrect: false,
                          focusNode: folderNameFocusNode,
                          controller: textController,
                          onChanged: (text) {
                            setState(() {
                              name = text;
                            });
                          },

                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 18,
                                fontFamily: Strings.AcuminFont),
                                enabledBorder: UnderlineInputBorder(
                                 borderSide: BorderSide(
                                  color: isDarkMode(context)
                                      ? Theme.of(context).indicatorColor
                                      : Theme
                                      .of(context)
                                      .hoverColor),
                            ),
                            errorText: Validator().validateName(name),
                            errorMaxLines: 2,
                            errorStyle: const TextStyle(
                                color: AppThemes.deepPinkColor,
                                fontSize: 16,
                                fontFamily: Strings.AcuminFont),
                                focusedBorder: UnderlineInputBorder(
                                 borderSide: BorderSide(
                                  color: isDarkMode(context)
                                      ? Theme.of(context).indicatorColor
                                      : Theme.of(context).hoverColor),
                            ),
                          )),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              elevation: 2,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 2),
                              backgroundColor: isDarkMode(context)
                                  ? Theme
                                  .of(context)
                                  .dividerColor
                                  : Theme
                                  .of(context)
                                  .primaryColorDark,
                              side: BorderSide(
                                  width: 2.0,
                                  color: isDarkMode(context)
                                      ? Theme
                                      .of(context)
                                      .dividerColor
                                      : Theme
                                      .of(context)
                                      .primaryColorDark),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: text(
                              Strings.create,
                              false,
                              isDarkMode(context)
                                  ? Theme
                                  .of(context)
                                  .primaryColorDark
                                  : Theme
                                  .of(context)
                                  .indicatorColor,
                              14.0,
                              1.0,
                              false,
                              false,
                              context,
                              0,
                              FontWeight.w500),
                          onPressed: () {
                            if (name.toString() != " " && name.isNotEmpty &&
                                Validator().validateName(name) == null) {
                              _addToDb();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  /*
   * function to add in favourite view
   */

  Future<void> _addToFavorite() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cursorColor,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                  height: 280,
                  width: _width,
                  color: Theme.of(context).cursorColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: text(
                              Strings.addToFavorite,
                              false,
                              Theme.of(context).hoverColor,
                              18.0,
                              1.0,
                              false,
                              false,
                              context,
                              10,
                              FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text('AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: Strings.gurmukhiFont,
                                color: textColorTheme(context),
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            width: _width,
                            height: 40,
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: isDarkMode(context)
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.21),
                              borderRadius: BorderRadius.circular(25),
                            ),

                            child: BlocBuilder<FolderBloc, FolderState>(builder: (context, state) {
                if (state is FolderInitial) {
                  context.read<FolderBloc>().add(FolderFetched());
                  return showLoader();
                } else if (state is FolderLoaded) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<FolderModel?>(
                      value: folderNameList1[i],
                      iconSize: 32,
                      iconEnabledColor: isDarkMode(context)
                          ? Theme
                          .of(context)
                          .indicatorColor
                          : Theme
                          .of(context)
                          .primaryColorDark
                          .withOpacity(0.60),
                      iconDisabledColor: isDarkMode(context)
                          ? Theme
                          .of(context)
                          .indicatorColor
                          : Theme
                          .of(context)
                          .primaryColorDark
                          .withOpacity(0.60),
                      dropdownColor: Theme
                          .of(context)
                          .disabledColor,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: folderNameList1.map<
                          DropdownMenuItem<FolderModel>>((FolderModel items) {
                        return DropdownMenuItem<FolderModel>(
                          value: items,
                          child: text(
                              items.name,
                              false,
                              isDarkMode(context)
                                  ? Theme
                                  .of(context)
                                  .indicatorColor
                                  : Theme
                                  .of(context)
                                  .primaryColorDark,
                              16.0,
                              1.0,
                              false,
                              false,
                              context,
                              5,
                              FontWeight.normal),
                        );
                      }
                      ).toList(),
                      onChanged: (FolderModel? value2) {
                       setState(() {
                          i = value2!.id!-1;
                          folderName = value2;
                       });
                      },
                    ),
                    );
                    } else {
                    return DropdownButtonHideUnderline(
                    child: DropdownButton<FolderModel?>(
                      value: folderNameList1[i],
                      iconSize: 32,
                      iconEnabledColor: isDarkMode(context)
                          ? Theme
                          .of(context)
                          .indicatorColor
                          : Theme
                          .of(context)
                          .primaryColorDark
                          .withOpacity(0.60),
                      iconDisabledColor: isDarkMode(context)
                          ? Theme
                          .of(context)
                          .indicatorColor
                          : Theme
                          .of(context)
                          .primaryColorDark
                          .withOpacity(0.60),
                      dropdownColor: Theme
                          .of(context)
                          .disabledColor,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: folderNameList1.map<
                          DropdownMenuItem<FolderModel>>((FolderModel items) {
                        return DropdownMenuItem<FolderModel>(
                          value: items,
                          child: text(
                              items.name,
                              false,
                              isDarkMode(context)
                                  ? Theme
                                  .of(context)
                                  .indicatorColor
                                  : Theme
                                  .of(context)
                                  .primaryColorDark,
                              16.0,
                              1.0,
                              false,
                              false,
                              context,
                              5,
                              FontWeight.normal),
                        );
                      }
                      ).toList(),
                      onChanged: (FolderModel? value2) {
                        setState(() {
                          i = value2!.id!-1;
                          folderName = value2;
                        });
                      },
                    ),
                  );
                    }
                    })
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, state) {
                          return Center(
                         child: OutlinedButton(
                         style: OutlinedButton.styleFrom(
                            elevation: 2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
                            backgroundColor: isDarkMode(context)
                                ? Theme
                                .of(context)
                                .dividerColor
                                : Theme
                                .of(context)
                                .primaryColorDark,
                            side: BorderSide(
                                width: 2.0,
                                color: isDarkMode(context)
                                    ? Theme
                                    .of(context)
                                    .dividerColor
                                    : Theme
                                    .of(context)
                                    .primaryColorDark),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                         child: text(
                            Strings.add,
                            false,
                            isDarkMode(context)
                                ? Theme
                                .of(context)
                                .primaryColorDark
                                : Theme
                                .of(context)
                                .indicatorColor,
                            14.0,
                            1.0,
                            false,
                            false,
                            context,
                            0,
                            FontWeight.w300),
                        onPressed: () {
                          var model= FavoriteDataItem(folder_id: folderName!.id, gurmukhi: "AwKih mMgih dyih dyih dwiq kry dwqwru ]", gurmukhi_unicode: "text", folder_name: folderName!.name, date:currentDate(), bani_id: 1);
                          Repository().addToFavoriteList(model);
                          Navigator.of(context).pop();
                         }
                         ),
                         );})
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  /*
   *  Function to enable/ disable drop_down view
   */
  Widget _dropDownView(bool _visible) {
    return Visibility(
      visible: _visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 35, right: 35, bottom: 20),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding:
              const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
          decoration: BoxDecoration(
            color: isDarkMode(context) ? Theme.of(context).disabledColor : Theme.of(context).primaryColorDark.withOpacity(0.21),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 9,
                fit: FlexFit.loose,
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            _createFolder();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text(
                                  Strings.newFolder,
                                  false,
                                  isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                  18.0,
                                  1.0,
                                  false,
                                  false,
                                  context,
                                  0,
                                  FontWeight.w500),
                              Image.asset(AssetsName.ic_plus,
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.scaleDown,
                                  color: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                  alignment: Alignment.centerRight),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: folderNameList.length,
                          padding: const EdgeInsets.only(top: 5),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                      folderNameList[index],
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: isDarkMode(context)
                                              ? Theme.of(context).indicatorColor
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          fontFamily: Strings.AcuminFont),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        defaultSelectFolder =
                                            folderNameList[index];
                                        isDropDownOpen = !isDropDownOpen;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ]),
                ), //Container
              ), //Flexible
              const SizedBox(
                width: 20,
              ), //SizedBox
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                  width: 5,
                  height: 100,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: LinearProgressIndicator(
                      value: 0.80,
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).disabledColor),
                      backgroundColor: isDarkMode(context)
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).primaryColorDark,
                    ),
                  ), //BoxDecoration
                ), //Container
              ) //Flexible
            ], //<Widget>[]
            mainAxisAlignment: MainAxisAlignment.center,
          ), //Row
        ),
      ),
    );
  }

  /*
   * return mahaKosh item view data
   */
  MahankoshData getMahanKoshDataItem(List<MahankoshData> mahanKoshList) {
    if (index >= 0 && index < mahanKoshList.length) {
      for (var i = index; i < mahanKoshList.length; i++) {
        return mahanKoshList[i];
      }
    }
    return mahanKoshList[index];
  }

  /*
   * Ui for MahaKoshShabad
   */
  Future<void> _showMahankoshShabadAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cursorColor,
              contentPadding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Container(
                color: Theme.of(context).cursorColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 9,
                            fit: FlexFit.loose,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  text(getMahanKoshDataItem(mahanKoshList).title,
                                      false,
                                      isDarkMode(context) ? Theme.of(context).dividerColor : AppThemes.darkBlueColor,
                                      26.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      0,
                                      FontWeight.w300,
                                      Strings.gurmukhiAkkharThickFont),
                                  text(getMahanKoshDataItem(mahanKoshList).description,
                                      false,
                                      isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).hoverColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      10,
                                      FontWeight.w300,
                                      Strings.gurmukhiAkkharThickFont),
                                ]), //Container
                          ), //Flexible
                          const SizedBox(
                            width: 10,
                          ), //SizedBox
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              width: 5,
                              height: 150,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: LinearProgressIndicator(
                                  value: 0.80,
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).disabledColor),
                                  backgroundColor: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                ),
                              ), //BoxDecoration
                            ), //Container
                          ) //Flexible
                        ], //<Widget>[]
                      ),
                      //Row
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (index > 0) {
                                    index -= 1;
                                  }
                                });
                              },
                              child: Icon(Icons.arrow_back_ios_outlined,
                                color: isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).hoverColor, size: 22,
                              ),
                            ),
                            text(getMahanKoshDataItem(mahanKoshList).koshName,
                                true,
                                isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).hoverColor,
                                14.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.w300),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (index < mahanKoshList.length - 1) {
                                    index += 1;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).hoverColor, size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /*
   *  function to update Bookmark
   */
  Future<void> _updateBookMark() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cursorColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                  height: 280,
                  width: _width,
                  color: Theme.of(context).cursorColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        text(Strings.updateBookmark,
                            false,
                            Theme.of(context).hoverColor,
                            18.0,
                            1.0,
                            false,
                            false,
                            context,
                            10,
                            FontWeight.w600),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text('AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: Strings.gurmukhiFont,
                                color: textColorTheme(context),
                              )),
                        ),
                        text(
                            "AMg 319, pMgqI 12",
                            false,
                            isDarkMode(context) ? AppThemes.lightGreyTextColor.withOpacity(0.7) : AppThemes.darkBlueColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            10,
                            FontWeight.w300,
                            Strings.gurbaniAkharLightFont),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            width: _width,
                            height: 40,
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: isDarkMode(context) ? Theme.of(context).disabledColor : Theme.of(context).primaryColorDark.withOpacity(0.21),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: defaultSelectBookMark,
                                iconSize: 32,
                                iconEnabledColor: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark.withOpacity(0.60),
                                iconDisabledColor: isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark.withOpacity(0.60),
                                dropdownColor: Theme.of(context).disabledColor,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: bookMarkList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: text(
                                        items,
                                        false,
                                        isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).primaryColorDark,
                                        16.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        5,
                                        FontWeight.normal),
                                  );
                                }).toList(),
                                onChanged: (String? value2) {
                                  setState(() {
                                    defaultSelectBookMark = value2;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  elevation: 2,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
                                  backgroundColor: isDarkMode(context) ? Theme.of(context).dividerColor : Theme.of(context).primaryColorDark,
                                  side: BorderSide(width: 2.0, color: isDarkMode(context) ? Theme.of(context).dividerColor : Theme.of(context).primaryColorDark),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              child: text(
                                  Strings.update,
                                  false,
                                  isDarkMode(context) ? Theme.of(context).primaryColorDark : Theme.of(context).indicatorColor,
                                  14.0,
                                  1.0,
                                  false,
                                  false,
                                  context,
                                  0,
                                  FontWeight.w300),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  /*
   *  bottom sheet audio View
   */
  void _showBottomAudiobar(BuildContext ctx) {
    showModalBottomSheet(
      elevation: 0,
      enableDrag: false,
      barrierColor: Colors.transparent,
      backgroundColor: Theme.of(context).primaryColorDark,
      context: ctx,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, setState) =>
            Wrap(direction: Axis.horizontal, children: <Widget>[
          Container(
            color: Theme.of(context).primaryColorDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 30,
                        padding: const EdgeInsets.only(right: 15),
                        onPressed: () {
                          _player.seek(Duration.zero);
                        },
                        icon: Image.asset(AssetsName.ic_repeat,
                            color: Theme.of(context).dividerColor,
                            height: 30,
                            width: 30,
                            fit: BoxFit.scaleDown),
                      ),
                      IconButton(
                        color: Theme.of(context).dividerColor,
                        padding: const EdgeInsets.only(right: 15),
                        onPressed: () {
                          Duration currentPosition = _player.position;
                          Duration targetPosition = currentPosition - const Duration(seconds: 10);
                          _player.seek(targetPosition);
                        },
                        icon: Image.asset(AssetsName.ic_rewind,
                            color: Theme.of(context).dividerColor,
                            height: 25,
                            width: 25,
                            fit: BoxFit.scaleDown),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return Container(
                              child: const CircularProgressIndicator(),
                            );
                          } else if (playing != true) {
                            return IconButton(
                              iconSize: 30,
                              padding: const EdgeInsets.only(right: 5),
                              onPressed: _player.play,
                              icon: Image.asset(AssetsName.ic_play,
                                  color: Theme.of(context).dividerColor,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.scaleDown),
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              padding: const EdgeInsets.only(right: 5),
                              icon: Icon(
                                Icons.pause,
                                color: Theme.of(context).dividerColor,
                                size: 40,
                              ),
                              iconSize: 40.0,
                              onPressed: _player.pause,
                            );
                          } else {
                            return IconButton(
                              padding: const EdgeInsets.only(right: 5),
                              icon: Icon(Icons.replay,
                                  color: Theme.of(context).dividerColor,
                                  size: 40),
                              iconSize: 40.0,
                              onPressed: () => _player.seek(Duration.zero),
                            );
                          }
                        },
                      ),
                      IconButton(
                        iconSize: 25,
                        padding: const EdgeInsets.only(right: 10),
                        onPressed: () {
                          Duration currentPosition = _player.position;
                          Duration targetPosition = currentPosition + const Duration(seconds: 10);
                          _player.seek(targetPosition);
                        },
                        icon: Image.asset(AssetsName.ic_forward,
                            color: Theme.of(context).dividerColor,
                            height: 25,
                            width: 25,
                            fit: BoxFit.scaleDown),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          _showAudioSettings();
                        },
                        icon: SvgPicture.asset(
                          AssetsName.ic_settings,
                          color: Theme.of(context).dividerColor,
                          height: 30,
                          width: 30,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  /*
   *  alert dialog for audio settings
   */
  Future<void> _showAudioSettings() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  alignment: Alignment.bottomRight,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.only(
                      bottom: 50, right: 10, top: 0, left: 0),
                  contentPadding: EdgeInsets.zero,
                  actionsPadding: EdgeInsets.zero,
                  buttonPadding: EdgeInsets.zero,
                  titlePadding: EdgeInsets.zero,
                  content: Wrap(
                    alignment: WrapAlignment.end,
                    direction: Axis.horizontal,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: _width / 1.25,
                              alignment: Alignment.bottomRight,
                              color: (isDarkMode(context)
                                  ? AppThemes.greyLightColor3
                                  : Theme.of(context).primaryColor),
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 15, left: 25, right: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text(
                                      Strings.audioSpeed,
                                      false,
                                      Theme.of(context).dividerColor,
                                      18.0,
                                      1.0,
                                      false,
                                      false,
                                      context,
                                      10,
                                      FontWeight.bold),
                                  showSettings(
                                    context: context,
                                    divisions: 10,
                                    min: 0.5,
                                    max: 5.5,
                                    valueSuffix: 'x',
                                    value: _player.speed,
                                    stream: _player.speedStream,
                                    onChanged: _player.setSpeed,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      text(
                                          Strings.autoScroll,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          20,
                                          FontWeight.bold),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 16),
                                        height: 30,
                                        //set desired REAL HEIGHT
                                        width: 60,
                                        // set desire Real WIDTH
                                        child: Transform.scale(
                                          transformHitTests: false,
                                          scale: 0.6,
                                          child: CupertinoSwitch(
                                            value: autoScrollEnable,
                                            activeColor:
                                                Theme.of(context).dividerColor,
                                            trackColor:
                                                disableSwitchTheme(context),
                                            onChanged: (bool value) {
                                              setState(() {
                                                autoScrollEnable = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  showSettings(
                                    context: context,
                                    divisions: 10,
                                    min: 0,
                                    max: 5,
                                    valueSuffix: '',
                                    value: 2,
                                    stream: _player.volumeStream,
                                    onChanged: _player.setVolume,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      text(
                                          Strings.repeat,
                                          false,
                                          Theme.of(context).dividerColor,
                                          18.0,
                                          1.0,
                                          false,
                                          false,
                                          context,
                                          20,
                                          FontWeight.bold),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 16),
                                        height: 30,
                                        //set desired REAL HEIGHT
                                        width: 60,
                                        // set desire Real WIDTH
                                        child: Transform.scale(
                                          transformHitTests: false,
                                          scale: 0.6,
                                          child: CupertinoSwitch(
                                            value: isParagraphEnable,
                                            onChanged: (value) {
                                              setState(() {
                                                isParagraphEnable = value;
                                                if (value) {
                                                  _player.setLoopMode(
                                                      LoopMode.all);
                                                } else {
                                                  _player.setLoopMode(
                                                      LoopMode.off);
                                                }
                                              });
                                            },
                                            activeColor:
                                                Theme.of(context).dividerColor,
                                            trackColor:
                                                disableSwitchTheme(context),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text('10x',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Strings.AcuminFont,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            audioSettingsPopUpTopView(
                                context,
                                25,
                                isDarkMode(context)
                                    ? AppThemes.greyLightColor3
                                    : Theme.of(context).primaryColor),
                          ]),
                    ],
                  ));
            },
          );
        });
  }

  /*
   * function to change background of view
   */
  changeBackgroundColor(String? selectedBackground) {
    var colorValue = Theme.of(context).canvasColor;
    if (selectedBackground == Strings.yellowBackground) {
      colorValue = isDarkMode(context)
          ? Theme.of(context).canvasColor
          : AppThemes.yellowBgColor;
      isTopViewVisible = true;
    } else if (selectedBackground == Strings.puratanBackground) {
      isTopViewVisible = false;
      colorValue = isDarkMode(context)
          ? Theme.of(context).canvasColor
          : AppThemes.floralBgColor;
    } else {
      isTopViewVisible = true;
      colorValue = Theme.of(context).canvasColor;
    }

    return colorValue;
  }

  /*
   * function to change background color of view
   */
  bool isBackgroundModeYellow(String? selectedBackground) {
    if (!isDarkMode(context)) {
      if (selectedBackground == Strings.yellowBackground) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /*
   * Function to show fading bar options
   */
  _showFadingBarOptions(bool isFadingBarEnable) {
    return Visibility(
        visible: isFadingBarEnable,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
                decoration: BoxDecoration(
                  color: isDarkMode(context)
                      ? AppThemes.blueEditTextBgColor
                      : AppThemes.darkYellowColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                        "01:43",
                        false,
                        isDarkMode(context)
                            ? Theme.of(context).hintColor
                            : AppThemes.blueEditTextBgColor,
                        12.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.w300),
                    text(
                        "AMg 241",
                        false,
                        isDarkMode(context)
                            ? Theme.of(context).hintColor
                            : AppThemes.blueEditTextBgColor,
                        12.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.w300,
                        Strings.gurmukhiAkkharThickFont),
                    text(
                        "50%",
                        false,
                        isDarkMode(context)
                            ? Theme.of(context).hintColor
                            : AppThemes.blueEditTextBgColor,
                        12.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.w300),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Theme.of(context).dividerColor,
                          size: 30,
                        )),
                    BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                        builder: (context, state) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                context.read<DisplaySettingsBloc>().add(ParagraphStyleChanged(paragraphStyle: true));
                              },
                              icon: SvgPicture.asset(AssetsName.ic_paragraph,
                                  color: state.paragraphStyle!
                                      ? Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.7)
                                      : Theme.of(context).dividerColor,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill),
                            ),
                            text(
                                Strings.paraGraphMode,
                                false,
                                state.paragraphStyle!
                                    ? Theme.of(context)
                                        .indicatorColor
                                        .withOpacity(0.7)
                                    : Theme.of(context).indicatorColor,
                                8.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.w300),
                          ]);
                    }),
                    InkWell(
                        overlayColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.transparent),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.read<DisplaySettingsBloc>().add(BisramStyleChanged(bisramStyle: false));
                        },
                        child: BlocBuilder<DisplaySettingsBloc,
                            DisplaySettingsState>(builder: (context, state) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(
                                    'b,',
                                    false,
                                    state.bisramStyle!
                                        ? Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.7)
                                        : Theme.of(context).dividerColor,
                                    32.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    5,
                                    FontWeight.w300,
                                    Strings.gurmukhiFont),
                                text(
                                    Strings.bisramStyle,
                                    false,
                                    state.bisramStyle!
                                        ? Theme.of(context)
                                            .indicatorColor
                                            .withOpacity(0.7)
                                        : Theme.of(context).indicatorColor,
                                    8.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    0,
                                    FontWeight.w300),
                              ]);
                        })),
                    InkWell(
                        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.read<DisplaySettingsBloc>().add(
                              GurbaniViewStyleChanged(
                                  larrivarStyle: true,));
                        },
                        child: BlocBuilder<DisplaySettingsBloc,
                            DisplaySettingsState>(builder: (context, state) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(
                                    'aA',
                                    false,
                                    state.larrivarStyle!
                                        ? Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.7)
                                        : Theme.of(context).dividerColor,
                                    30.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    5,
                                    FontWeight.w300,
                                    Strings.gurmukhiFont),
                                text(Strings.larrivar,
                                    false,
                                    state.larrivarStyle!
                                        ? Theme.of(context)
                                            .indicatorColor
                                            .withOpacity(0.7)
                                        : Theme.of(context).indicatorColor,
                                    8.0,
                                    1.0,
                                    false,
                                    false,
                                    context,
                                    0,
                                    FontWeight.w300),
                              ]);
                        })),
                    IconButton(
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).dividerColor,
                          size: 30,
                        )),
                  ],
                ),
              ),
            ]));
  }

  void _addToDb() async {
      await DatabaseHandler.instance.insertFolder(FolderModel(name: name,date: currentDate()));
      textController.clear();
      getFolderList();
  }
  /*
   Get List of folder
   */
  getFolderList(){
    DatabaseHandler.instance.getAllFolderList().then((value) {
      if(value.isNotEmpty){
        folderNameList1.clear();
        for (var element in value) {
          folderNameList1.add(element);
        }
      }else{
        folderNameList1.clear();
        folderNameList1.add(FolderModel(id: 0, name: Strings.selectFolder,date: currentDate()));
      }
      setState(() {

      });
    }).catchError((error) {
      showSnackbar(context,error.toString(),Strings.AcuminFont);
    });
  }
  /*
   *  initialize audio player
   */
  Future<void> _init() async {
    var sequence = [
      'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"
    ];
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    // Try to load audio from a source and catch any errors.
    try {
      for (var i = 0; i < sequence.length; i++) {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(sequence[i])));
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _connectivitySubscription.cancel();
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}

enum ManageWidgets {
  displaySettings,
  createNoteSettings,
  AddNoteSettings,
  moreOptionsSettings,
  reportText,
  defaultSettings
}


