import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/seek_bar_widget.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:rxdart/rxdart.dart';

import '../app_themes.dart';
import '../services/preferenecs.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({Key? key}) : super(key: key);

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView>  with WidgetsBindingObserver{
  final _player = AudioPlayer();
 bool repeatMode = false,autoScrollEnable=false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:_showBottomAudiBar(context)
    );
  }
  /*
   *  bottom sheet audio View
   */
  Widget _showBottomAudiBar(BuildContext ctx) {
    return Wrap(direction: Axis.horizontal, children: <Widget>[
      Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(padding:const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).primaryColorDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
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
                    padding: const EdgeInsets.only(
                        top: 0, left: 10, right: 10, bottom: 20),
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
                            Duration targetPosition =
                                currentPosition - const Duration(seconds: 10);
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
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return const CircularProgressIndicator();
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
                            } else if(processingState== ProcessingState.completed){
                              if(!repeatMode){
                                return IconButton(
                                  padding: const EdgeInsets.only(right: 5),
                                  icon: Icon(Icons.replay,
                                      color: Theme.of(context).dividerColor,
                                      size: 40), iconSize: 40.0,
                                  onPressed: () => _player.seek(Duration.zero),
                                );
                              }else
                              {
                                _player.setLoopMode(
                                    LoopMode.all);
                                return IconButton(
                                  iconSize: 30,
                                  padding: const EdgeInsets.only(right: 5),
                                  onPressed:
                                  _player.play,
                                  icon: Image.asset(AssetsName.ic_play,
                                      color: Theme.of(context).dividerColor,
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.scaleDown),

                                );
                              }

                            }
                            else{
                              return IconButton(
                                padding: const EdgeInsets.only(right: 5),
                                icon: Icon(Icons.replay,
                                    color: Theme.of(context).dividerColor,
                                    size: 40), iconSize: 40.0,
                                onPressed: () => _player.seek(Duration.zero));
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
    ]);
  }
  /*
   *  alert dialog for audio settings
   */
  Future<void> _showAudioSettings() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  alignment: Alignment.bottomRight,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.only(bottom: 50, right: 10, top: 0, left: 0),
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
                            Container(width:  MediaQuery.of(context).size.width / 1.25,
                              alignment: Alignment.bottomRight,
                              color: (isDarkMode(context)
                                  ? AppThemes.greyLightColor3
                                  : Theme
                                  .of(context)
                                  .primaryColor),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Theme
                                                .of(context)
                                                .dividerColor,
                                            trackColor: isDarkMode(context)
                                                ? Theme
                                                .of(context)
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
                                  Row(crossAxisAlignment: CrossAxisAlignment.start,
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
                                            value: repeatMode,
                                            onChanged: (value) {
                                              setState(() {
                                                repeatMode = value;
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
                                            trackColor: isDarkMode(context) ? Theme.of(context).disabledColor : AppThemes.lightBlue,
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
                                isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).primaryColor),
                          ]),
                    ],
                  ));
            },
          );
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
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      for (var i = 0; i < sequence.length; i++) {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(sequence[i])));
      }
    } catch (e) {
      print("Error loading audio source: $e");
    }
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
              (position, bufferedPosition, duration) =>
              PositionData(
                  position, bufferedPosition, duration ?? Duration.zero));
}

