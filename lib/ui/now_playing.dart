import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/seek_bar_widget_now_playing.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:marquee/marquee.dart';
import 'package:rxdart/rxdart.dart';

import '../services/preferenecs.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AudioPlayer _player;
  late double _height;
  late double _width;
  late double _pixelRatio;
  bool isDownloaded = false;
  bool isParagraphEnable = false;
  bool autoScrollEnable = false, displaySettingsEnable = false;
  double gurmukhiFontSize = 26;
  double pronunciationTipFontSize = 20;
  double transliterationFontSize = 14;
  double akhriArthFontSize = 14.0;
  double detailedArthFontSize = 14.0;
  double englishTranslation = 14.0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
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
          title: Text(Strings.nowPlaying),
          titleTextStyle:
              TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
          actions: [
            IconButton(
              iconSize: 25,
              padding: const EdgeInsets.only(right: 20),
              icon: Image.asset(AssetsName.gurbaniViewSettings,
                  width: 25, height: 25, fit: BoxFit.fill),
              onPressed: () {
                setState(() {
                  displaySettingsEnable = !displaySettingsEnable;
                });
              },
            ),
          ],
        ),
        body: SafeArea(
            child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              text(
                                  "Track Name",
                                  true,
                                  isDarkMode(context)
                                      ? Theme.of(context).hoverColor
                                      : AppThemes.darkBlueColor,
                                  26.0,
                                  1.0,
                                  false,
                                  false,
                                  context,
                                  0,
                                  FontWeight.normal),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  height: 50,
                                  constraints: BoxConstraints(
                                      minHeight: 40, minWidth: _width),
                                  child: Marquee(
                                    textDirection: TextDirection.ltr,
                                    text:
                                        "Track Details (can auto horizontal scroll)",
                                    style: TextStyle(
                                        color: textColorTheme(context),
                                        fontSize: 16.0,
                                        fontFamily: Strings.AcuminFont),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  )),
                              Container(
                                  width: double.infinity,
                                  height: _height -
                                      (AppBar().preferredSize.height + 290),
                                  child: Container(
                                      height: _height -
                                          (AppBar().preferredSize.height + 290),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: !displaySettingsEnable,
                                            child: Center(
                                                child: Container(
                                                    height: 250,
                                                    width: 250,
                                                    child: Card(
                                                      semanticContainer: true,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      shape: CircleBorder(),
                                                      color: isDarkMode(context)
                                                          ? AppThemes
                                                              .greyLightColor3
                                                          : Theme.of(context)
                                                              .indicatorColor,
                                                      shadowColor:
                                                          AppThemes.greyTextColor,
                                                      elevation: 5,
                                                    ))),
                                          ),
                                          Visibility(
                                              visible: displaySettingsEnable,
                                              child: Card(
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  color: isDarkMode(context)
                                                      ? AppThemes
                                                          .greyLightColor3
                                                      : Theme.of(context)
                                                          .indicatorColor,
                                                  shadowColor:
                                                      AppThemes.greyTextColor,
                                                  elevation: 5,
                                                  child: Container(
                                                      constraints: BoxConstraints(
                                                          minHeight: 150,
                                                          maxHeight: _height -
                                                              (AppBar()
                                                                      .preferredSize
                                                                      .height +
                                                                  300)),
                                                      child:
                                                          SingleChildScrollView(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    text(
                                                                        'AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                                                                        true,
                                                                        isDarkMode(context)
                                                                            ? Theme.of(context)
                                                                                .indicatorColor
                                                                            : Theme.of(context)
                                                                                .primaryColorDark,
                                                                        gurmukhiFontSize,
                                                                        1.0,
                                                                        false,
                                                                        false,
                                                                        context,
                                                                        1,
                                                                        FontWeight
                                                                            .normal,
                                                                        Strings
                                                                            .gurmukhiAkkharThickFont),
                                                                    text(
                                                                        "AwK-ih | mMg-ih | dyih",
                                                                        true,
                                                                        isDarkMode(context)
                                                                            ? Theme.of(context)
                                                                                .dividerColor
                                                                            : AppThemes
                                                                                .darkBlueColor,
                                                                        pronunciationTipFontSize,
                                                                        1.0,
                                                                        false,
                                                                        false,
                                                                        context,
                                                                        5,
                                                                        FontWeight
                                                                            .normal,
                                                                        Strings
                                                                            .gurmukhiAkkharThickFont),
                                                                    text(
                                                                        'mMgih: K`Kw Aqy g`gw mukqw bolo, ishwrI sMkoc ky bolo, ksky nhI bolxIAW',
                                                                        true,
                                                                        isDarkMode(context)
                                                                            ? Theme.of(context)
                                                                                .dividerColor
                                                                            : Color(
                                                                                0xFF525252),
                                                                        pronunciationTipFontSize -
                                                                            2,
                                                                        1.0,
                                                                        false,
                                                                        false,
                                                                        context,
                                                                        7,
                                                                        FontWeight
                                                                            .normal,
                                                                        Strings
                                                                            .gurmukhiFont),
                                                                    Visibility(
                                                                      visible:
                                                                          true,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top:
                                                                              7,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Aakhehi mangehi dhaehi dhaehi daath karae daathaar',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                transliterationFontSize,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: isDarkMode(context)
                                                                                ? AppThemes.blueColor
                                                                                : Theme.of(context).primaryColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        top: 7,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'People beg and pray, “Give to us, give to us”, and the Great Giver gives His Gifts.',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              englishTranslation,
                                                                          fontFamily:
                                                                              Strings.AcuminFont,
                                                                          color: isDarkMode(context)
                                                                              ? AppThemes.blueColor
                                                                              : Theme.of(context).primaryColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible:
                                                                          true,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              15,
                                                                        ),
                                                                        child: SelectableText
                                                                            .rich(
                                                                          TextSpan(
                                                                            children: <InlineSpan>[
                                                                              const TextSpan(
                                                                                text: '|',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 2,
                                                                                  wordSpacing: 2,
                                                                                  color: AppThemes.deepPinkColor,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                  text: ' pihlw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                  style: TextStyle(
                                                                                    fontSize: akhriArthFontSize,
                                                                                    fontFamily: Strings.gurmukhiFont,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF525252),
                                                                                  )),
                                                                              TextSpan(
                                                                                  text: '  view more…',
                                                                                  style: TextStyle(
                                                                                    fontSize: akhriArthFontSize - 4,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF142849),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible:
                                                                          true,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 15),
                                                                        child: SelectableText
                                                                            .rich(
                                                                          TextSpan(
                                                                            children: <InlineSpan>[
                                                                              const TextSpan(
                                                                                text: '|',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 2,
                                                                                  wordSpacing: 2,
                                                                                  color: Color(0xFF288DD8),
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                  text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                  style: TextStyle(
                                                                                    fontSize: detailedArthFontSize,
                                                                                    fontFamily: Strings.gurmukhiFont,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF525252),
                                                                                  )),
                                                                              TextSpan(
                                                                                  text: '  view more…',
                                                                                  style: TextStyle(
                                                                                    fontSize: detailedArthFontSize - 4,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF142849),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible:
                                                                          true,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 15),
                                                                        child: SelectableText
                                                                            .rich(
                                                                          TextSpan(
                                                                            children: <InlineSpan>[
                                                                              const TextSpan(
                                                                                text: '|',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 2,
                                                                                  wordSpacing: 2,
                                                                                  color: Color(0xFFD86816),
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                  text: ' dUjw ArQ AYQy hovygw jI[ ij Awp jI hor pVxw cwhuMdy hn qW',
                                                                                  style: TextStyle(
                                                                                    fontSize: detailedArthFontSize,
                                                                                    fontFamily: Strings.gurmukhiFont,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF525252),
                                                                                  )),
                                                                              TextSpan(
                                                                                  text: '  view more…',
                                                                                  style: TextStyle(
                                                                                    fontSize: detailedArthFontSize - 4,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: isDarkMode(context) ? Color(0xFFDDDDDD) : Color(0xFF142849),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    text(
                                                                        'AwKih mMgih dyih dyih dwiq kry dwqwru ]',
                                                                        true,
                                                                        isDarkMode(context)
                                                                            ? Theme.of(context)
                                                                                .indicatorColor
                                                                            : Theme.of(context)
                                                                                .primaryColorDark,
                                                                        gurmukhiFontSize,
                                                                        1.0,
                                                                        false,
                                                                        false,
                                                                        context,
                                                                        10,
                                                                        FontWeight
                                                                            .normal,
                                                                        Strings
                                                                            .gurmukhiAkkharThickFont),
                                                                  ],
                                                                ),
                                                              ))))),
                                        ],
                                      )))
                            ])),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _showBottomAudioBar(context)),
                )
              ]),
        )),
      ),
    ));
  }

  /*
   *  initialize audio player
   */
  Future<void> _init() async {
    var sequence = [
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"
    ];

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(sequence[0])));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  /*
   *  bottom sheet audio View
   */
  Widget _showBottomAudioBar(BuildContext ctx) {
    return Wrap(direction: Axis.horizontal, children: <Widget>[
      Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBarNowPlay(
                        trackHeight: 5,
                        activeTrackColor: Theme.of(context).hoverColor,
                        inactiveTrackColor:
                            Theme.of(context).hoverColor.withAlpha(70),
                        topTimerVisible: true,
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 20),
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
                              color: Theme.of(context).hoverColor,
                              height: 30,
                              width: 30,
                              fit: BoxFit.scaleDown),
                        ),
                        IconButton(
                          color: Theme.of(context).hoverColor,
                          padding: const EdgeInsets.only(right: 15),
                          onPressed: () {
                            Duration currentPosition = _player.position;
                            Duration targetPosition =
                                currentPosition - const Duration(seconds: 10);
                            _player.seek(targetPosition);
                            //_player.seekToPrevious();
                          },
                          icon: Image.asset(AssetsName.ic_rewind,
                              color: Theme.of(context).hoverColor,
                              height: 25,
                              width: 25,
                              fit: BoxFit.scaleDown),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: _player.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return Container(
                                child: CircularProgressIndicator(),
                              );
                            } else if (playing != true) {
                              return IconButton(
                                iconSize: 30,
                                padding: const EdgeInsets.only(right: 5),
                                onPressed: _player.play,
                                icon: Image.asset(AssetsName.ic_play,
                                    color: Theme.of(context).hoverColor,
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
                                  color: Theme.of(context).hoverColor,
                                  size: 40,
                                ),
                                iconSize: 40.0,
                                onPressed: _player.pause,
                              );
                            } else {
                              return IconButton(
                                padding: const EdgeInsets.only(right: 5),
                                icon: Icon(Icons.replay,
                                    color: Theme.of(context).hoverColor,
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
                            Duration targetPosition =
                                currentPosition + const Duration(seconds: 10);
                            _player.seek(targetPosition);
                          },
                          icon: Image.asset(AssetsName.ic_forward,
                              color: Theme.of(context).hoverColor,
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
                            color: Theme.of(context).hoverColor,
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
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _connectivitySubscription.cancel();
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
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
                  insetPadding:
                      EdgeInsets.only(bottom: 50, right: 10, top: 0, left: 0),
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
                                        margin: EdgeInsets.only(top: 16),
                                        height: 30,
                                        width: 60,
                                        child: Transform.scale(
                                          transformHitTests: false,
                                          scale: 0.6,
                                          child: CupertinoSwitch(
                                            value: autoScrollEnable,
                                            activeColor:
                                                Theme.of(context).dividerColor,
                                            trackColor: isDarkMode(context)
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : AppThemes.lightBlue,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        margin: EdgeInsets.only(top: 16),
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
                                            trackColor: isDarkMode(context)
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : AppThemes.lightBlue,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20),
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
