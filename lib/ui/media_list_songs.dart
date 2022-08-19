import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/pothiSahibDataModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/now_playing.dart';
import 'package:learn_shudh_gurbani/ui/video_player.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/seek_bar_widget.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:rxdart/rxdart.dart';

import '../services/preferenecs.dart';

class MediaListSongs extends StatefulWidget {
  const MediaListSongs({Key? key}) : super(key: key);

  @override
  MediaListSongsState createState() => MediaListSongsState();
}

class MediaListSongsState extends State<MediaListSongs>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final TabController _tabController;
  late AudioPlayer _player;
  final tabsCount = 5;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  late List<bool> isDownloaded;
  String title = Strings.songs;
  late AnimationController animationController;
  late Animation<double> animation;
  bool isSearchEnable = true;
  bool _isSearching = false;
  bool addPlayList = false;
  final textController = TextEditingController();
  List<PothiSahibData> searchResult = [];

  List<PothiSahibData> songList = [
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 35),
    PothiSahibData('1', "Track Name", 'Artist name or description', 90),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
  ];
  List<PothiSahibData> albumList = [
    PothiSahibData('1', "Album Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Album Name", 'Number of Tracks', 35),
    PothiSahibData('1', "Album Name", 'Number of Tracks', 90),
    PothiSahibData('1', "Album Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Album Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Album Name", 'Number of Tracks', 60),
  ];
  List<PothiSahibData> myPlayList = [
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 35),
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 90),
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 60),
    PothiSahibData('1', "Playlist Name", 'Number of Tracks', 60),
  ];
  List<PothiSahibData> downloads = [
    PothiSahibData('1', "Track or Folder Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 35),
    PothiSahibData('1', "Track Name", 'Artist name or description', 90),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
    PothiSahibData('1', "Track Name", 'Artist name or description', 60),
  ];

  List<PothiSahibData> videoList = [
    PothiSahibData('00:00:00', "Track Name", 'Description', 60),
    PothiSahibData('00:00:00', "Track Name", 'Description', 35),
    PothiSahibData('00:00:00', "Track Name", 'Description', 90),
    PothiSahibData('00:00:00', "Track Name", 'Description', 60),
    PothiSahibData('00:00:00', "Track Name", 'Description', 60),
    PothiSahibData('00:00:00', "Track Name", 'Description', 60),
  ];
  List<PothiSahibData> mediaList = [];

  @override
  void initState() {
    super.initState();
    isDownloaded = List<bool>.filled(
        _isSearching ? searchResult.length : downloads.length, false);
    _player = AudioPlayer();
    _init();
    mediaList.addAll(songList);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
    _tabController = TabController(
        length: tabsCount,
        vsync: this,
        initialIndex: 0,
        animationDuration: Duration(milliseconds: 50));
    _tabController.addListener(() {
      setState(() {
        textController.clear();
        _isSearching = false;
        isSearchEnable = true;
        animation = CurvedAnimation(
            parent: animationController, curve: Curves.easeInBack);
        animation.removeListener(() => setState(() {}));
        animationController.reverse();
        switch (_tabController.index) {
          case 0:
            title = Strings.songs;
            mediaList.addAll(songList);
            break;
          case 1:
            title = Strings.albums;
            mediaList.addAll(albumList);
            break;
          case 2:
            title = Strings.myPlaylists;
            mediaList.addAll(myPlayList);
            break;
          case 3:
            title = Strings.downloadMedia;
            mediaList.addAll(downloads);
            break;
          case 4:
            title = Strings.videos;
            mediaList.addAll(videoList);
            break;
        }
        _init();
        isDownloaded = List<bool>.filled(downloads.length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return backPressGestureDetection(context,Material(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            title: Text(title),
            titleTextStyle:
                TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
            actions: [
              Visibility(
                  visible: !isSearchEnable,
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 50, top: 10, bottom: 10, right: 10),
                      width:
                          _tabController.index == 0 || _tabController.index == 2
                              ? _width - 120
                              : _width - 60,
                      child: _customSearchView(context, Strings.search))),
              Visibility(
                  visible:
                      _tabController.index == 0 || _tabController.index == 2
                          ? true
                          : false,
                  child: IconButton(
                    alignment: Alignment.center,
                    iconSize: 25,
                    color: Theme.of(context).dividerColor,
                    padding: const EdgeInsets.only(right: 5),
                    onPressed: () {
                      setState(() {
                        addPlayList = !addPlayList;
                      });
                    },
                    icon: Image.asset(
                        _tabController.index == 0
                            ? AssetsName.ic_upload
                            : AssetsName.ic_plus,
                        width: 25,
                        height: 25,
                        fit: BoxFit.scaleDown),
                  )),
              Visibility(
                  visible: isSearchEnable,
                  child: IconButton(
                    iconSize: 25,
                    padding: const EdgeInsets.only(right: 20),
                    icon: SvgPicture.asset(AssetsName.ic_search,
                        color: Theme.of(context).dividerColor,
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill),
                    onPressed: () {
                      textController.clear();
                      isSearchEnable = false;
                      animation = CurvedAnimation(
                          parent: animationController, curve: Curves.elasticIn);
                      animation.addListener(() => setState(() {}));
                      animationController.forward();
                    },
                  )),
            ],
          ),
          body:
          Container(
                padding: EdgeInsets.only(top: 10, bottom: 0),
                color: Theme.of(context).canvasColor,
                child: _tabsView()),
          ),
    ));
  }

  Widget _tabsView() {
    return DefaultTabController(
        length: tabsCount,
        initialIndex: 0,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).canvasColor,
          appBar: TabBar(
            isScrollable: true,
            indicatorWeight: 1.5,
            controller: _tabController,
            indicatorColor: Theme.of(context).hoverColor,
            labelColor: Theme.of(context).hoverColor,
            unselectedLabelColor: Theme.of(context).hoverColor.withOpacity(0.6),
            indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
            tabs: [
              _tab(Strings.songs),
              _tab(Strings.albums),
              _tab(Strings.myPlaylists),
              _tab(Strings.download),
              _tab(Strings.videos),
            ],
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Column(
                children: <Widget>[
                  Flexible(
                    child: listViewContainer(songList),
                  ),
                ],
              ),
              // tab  2
              Column(
                children: <Widget>[
                  Flexible(
                    child: listViewContainer(albumList),
                  ),
                ],
              ),
              //tab 3
              Column(
                children: <Widget>[
                  Flexible(
                    child: addPlayList
                        ? playListView()
                        : listViewContainer(myPlayList),
                    // child: listViewContainer(myPlayList),
                  )
                ],
              ),
              // tab 4
              Column(
                children: <Widget>[
                  Flexible(
                    child: listViewContainer(downloads),
                  )
                ],
              ),
              //tab 5
              Column(
                children: <Widget>[
                  Flexible(
                    child: listViewContainer(videoList),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  /*
   *   child view of list
   */
  Widget _ItemView(BuildContext context, int index, List<PothiSahibData> list,
      bool isPlayListViewer) {
    return Column(
      key: Key('$index'),
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 10, top: 7, bottom: 7),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: InkWell(
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.transparent),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        navigationPage(context, nowPlaying, NowPlaying());
                      },
                      child: textList(
                          _isSearching
                              ? searchResult[index].title
                              : list[index].title,
                          false,
                          Theme.of(context).hoverColor,
                          17.0,
                          1.0,
                          false,
                          1,
                          context,
                          5,
                          FontWeight.bold,
                          Strings.AcuminFont),
                    )),
                    Visibility(
                        visible: _tabController.index == 3 ? true : false,
                        child: Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25,
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      setState(() {
                                        isDownloaded[index] =
                                            !isDownloaded[index];
                                      });
                                    },
                                    icon: !isDownloaded[index]
                                        ? Image.asset(
                                            AssetsName.ic_download,
                                            width: 25,
                                            height: 25,
                                            color: Theme.of(context).hoverColor,
                                          )
                                        : Icon(
                                            Icons.done_outlined,
                                            color: Theme.of(context).hoverColor,
                                          ))))),
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _showPopupMenu(details.globalPosition);
                      },
                      child: Container(
                          width: 40,
                          padding: EdgeInsets.only(top: 13),
                          child: SvgPicture.asset(
                              AssetsName.ic_circle_more_options,
                              alignment: Alignment.center,
                              color: Theme.of(context).hoverColor,
                              fit: BoxFit.scaleDown)),
                    ),
                  ],
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            navigationPage(context, nowPlaying, NowPlaying());
                          },
                          child: textList(
                              _isSearching
                                  ? searchResult[index].description
                                  : list[index].description,
                              false,
                              textColorTheme(context),
                              15.0,
                              1.0,
                              false,
                              1,
                              context,
                              0,
                              FontWeight.normal)),
                      Visibility(
                          visible: isPlayListViewer,
                          child: IconButton(
                              iconSize: 20,
                              constraints: const BoxConstraints(),
                              onPressed: () {},
                              icon: Image.asset(
                                AssetsName.ic_hold_drag,
                                width: 18,
                                height: 20,
                                fit: BoxFit.scaleDown,
                              ))),
                    ]),
              ]),
        ),
        Visibility(
            visible: isPlayListViewer,
            child: const Padding(
              padding: EdgeInsets.only(top: 0),
              child: Divider(height: 2, color: AppThemes.greyColor),
            )),
      ],
    );
  }

  /*
   *  initialize audio player
   */
  Future<void> _init() async {
    var sequence = [
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"
    ];

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // for (var i = 0; i < sequence.length; i++){
      await _player.setAudioSource(AudioSource.uri(Uri.parse(sequence[0])));
      // }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  /*
   *  bottom sheet audio View
   */
  Widget _showBottomAudioBar(BuildContext ctx, List<PothiSahibData> list) {
    return Wrap(direction: Axis.horizontal, children: <Widget>[
      Container(
        alignment: Alignment.bottomCenter,
        color: Theme.of(context).primaryColorDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      height: 55,
                      width: 55,
                      decoration: ShapeDecoration(
                          color: Theme.of(context).indicatorColor,
                          shape: CircleBorder())),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textList(
                              'Track Name',
                              false,
                              Theme.of(context).dividerColor,
                              14.0,
                              1.0,
                              false,
                              1,
                              context,
                              0,
                              FontWeight.bold,
                              Strings.AcuminFont),
                          textList(
                              "Description",
                              false,
                              Theme.of(context).indicatorColor,
                              12.0,
                              1.0,
                              false,
                              1,
                              context,
                              5,
                              FontWeight.normal,
                              Strings.AcuminFont),
                        ]),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(direction: Axis.horizontal, children: <
                              Widget>[
                            IconButton(
                              color: Theme.of(context).dividerColor,
                              padding: const EdgeInsets.only(right: 15),
                              onPressed: () {
                                Duration currentPosition = _player.position;
                                Duration targetPosition = currentPosition -
                                    const Duration(seconds: 10);
                                _player.seek(targetPosition);
                                //_player.seekToPrevious();
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
                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (playing != true) {
                                  return IconButton(
                                    iconSize: 30,
                                    padding: const EdgeInsets.only(right: 5),
                                    onPressed: _player.play,
                                    icon: Image.asset(
                                        AssetsName.ic_play,
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
                                    onPressed: () =>
                                        _player.seek(Duration.zero),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              iconSize: 25,
                              padding: const EdgeInsets.only(right: 10),
                              onPressed: () {
                                Duration currentPosition = _player.position;
                                Duration targetPosition = currentPosition +
                                    const Duration(seconds: 10);
                                _player.seek(targetPosition);
                              },
                              icon: Image.asset(
                                  AssetsName.ic_forward,
                                  color: Theme.of(context).dividerColor,
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.scaleDown),
                            )
                          ]))),
                ],
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 2, left: 70, right: 25, bottom: 20),
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                      isVisible: false,
                    );
                  },
                )),
          ],
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _connectivitySubscription.cancel();
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    _tabController.dispose();
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

  /*
   * function to return list view
   */
  Widget listViewContainer(List<PothiSahibData> list) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 8,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: list.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 2, color: AppThemes.greyColor),
                        itemBuilder: (context, index) {
                          return _tabController.index == 4
                              ? _videoItem(context, index, list)
                              : _ItemView(context, index, list, false);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Divider(height: 2, color: AppThemes.greyColor),
                      )
                    ])
                )),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Visibility(visible:  _tabController.index == 4? false:true,child:Align(
                    alignment: Alignment.bottomCenter,
                    child: _showBottomAudioBar(context, list))),
             )
          ]),
    );
  }

  /*
   *  Function to show menu options
   */
  _showPopupMenu(Offset offset) {
    List options = [Strings.addToPlaylist, Strings.delete];
    if (_tabController.index == 1) {
      options = [Strings.delete, Strings.option];
    } else if (_tabController.index == 2) {
      options = [Strings.renamePlaylist, Strings.delete];
    } else {
      options = [Strings.addToPlaylist, Strings.delete];
    }
    showMenu<String>(
      color: isDarkMode(context)
          ? AppThemes.greyLightColor3
          : Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      position: RelativeRect.fromLTRB(25, offset.dy, 20, 0),
      //l,t,r,b  position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
            padding: EdgeInsets.all(0),
            child: Wrap(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: text(
                            options[0],
                            true,
                            Theme.of(context).hoverColor,
                            15.0,
                            1.0,
                            false,
                            false,
                            context,
                            0,
                            FontWeight.normal))),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Divider(height: 2, color: AppThemes.greyColor),
                ),
              ],
            ),
            value: '1'),
        PopupMenuItem<String>(
            padding: EdgeInsets.all(0),
            onTap: () {},
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: text(
                        options[1],
                        true,
                        Theme.of(context).hoverColor,
                        15.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.normal))),
            value: '2'),
      ],
      elevation: 5.0,
    );
  }

  /*
   * Tab Widget
   */
  Widget _tab(String title) {
    return Tab(
      child: Text(title,
          textWidthBasis: TextWidthBasis.parent,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: Strings.AcuminFont,
              overflow: TextOverflow.fade,
              fontSize: _large ? 18 : (_medium ? 16 : 14),
              fontWeight: FontWeight.bold)),
    );
  }

  /*
   * Function for custom search view
   */
  Widget _customSearchView(BuildContext context, String searchHint) {
    return Visibility(
      visible: animationController.value > 0.0,
      child: Material(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(30),
          elevation: 4,
          child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => onSearchTextChanged(value),
                      controller: textController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Theme.of(context).indicatorColor,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 15.0, right: 2.0, top: 2.0, bottom: 2.0),
                          hintText: searchHint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none)),
                    ),
                    flex: 1,
                  ),
                  IconButton(
                    iconSize: 20,
                    padding: const EdgeInsets.all(5),
                    onPressed: () {
                      setState(() {
                        textController.clear();
                        _isSearching = false;
                        isSearchEnable = true;
                        animation = CurvedAnimation(
                            parent: animationController,
                            curve: Curves.easeInBack);
                        animation.removeListener(() => setState(() {}));
                        animationController.reverse();
                      });
                    },
                    icon: Icon(Icons.close,
                        color: Theme.of(context).indicatorColor, size: 20),
                  )
                ],
              ))),
    );
  }

  /*
   * Method to detect text change listener
   */
  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      _isSearching = false;
      setState(() {});
      return;
    }
    mediaList.forEach((PothiSahibData) {
      _isSearching = true;
      if (PothiSahibData.title.toLowerCase().startsWith(text.toLowerCase()))
        searchResult.add(PothiSahibData);
    });
    setState(() {});
  }

  /*
   * Function to return items for video screen
   */
  Widget _videoItem(
      BuildContext context, int index, List<PothiSahibData> list) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              margin: EdgeInsets.only(right: 10),
              height: 85,
              width: 125,
              decoration: ShapeDecoration(
                  color: isDarkMode(context)
                      ? AppThemes.greyLightColor3
                      : Theme.of(context).indicatorColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )), child: VideoPlayerView()),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      textList(
                          _isSearching
                              ? searchResult[index].title
                              : list[index].title,
                          false,
                          Theme.of(context).hoverColor,
                          17.0,
                          1.0,
                          false,
                          1,
                          context,
                          5,
                          FontWeight.bold,
                          Strings.AcuminFont),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showPopupMenu(details.globalPosition);
                        },
                        child: Container(
                            width: 40,
                            padding: EdgeInsets.only(top: 13),
                            child: SvgPicture.asset(
                                AssetsName.ic_circle_more_options,
                                alignment: Alignment.center,
                                color: Theme.of(context).hoverColor,
                                fit: BoxFit.scaleDown)),
                      ),
                    ],
                  ),
                  textList(
                      _isSearching
                          ? searchResult[index].description
                          : list[index].description,
                      false,
                      textColorTheme(context),
                      15.0,
                      1.0,
                      false,
                      1,
                      context,
                      0,
                      FontWeight.normal),
                  textList(
                      _isSearching ? searchResult[index].id : list[index].id,
                      false,
                      isDarkMode(context)
                          ? AppThemes.blueColor
                          : Theme.of(context).hoverColor,
                      15.0,
                      1.0,
                      false,
                      1,
                      context,
                      20,
                      FontWeight.normal),
                ]),
          )
        ],
      ),
    );
  }

  /*
   *  Method to return the play gurbani View
   */
  playListView() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          Card(
              margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: isDarkMode(context)
                  ? AppThemes.greyLightColor3
                  : Theme.of(context).indicatorColor,
              shadowColor: AppThemes.greyTextColor,
              elevation: 5,
              child: Container(
                  constraints: BoxConstraints(minHeight: 150, maxHeight: 210),
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(
                              "Playlist Name",
                              true,
                              isDarkMode(context)
                                  ? Theme.of(context).dividerColor
                                  : AppThemes.darkBlueColor,
                              26.0,
                              1.0,
                              false,
                              false,
                              context,
                              1.0,
                              FontWeight.normal),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 95,
                              width: 95,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: CircleBorder(),
                                color: Theme.of(context).canvasColor,
                                shadowColor: AppThemes.greyTextColor,
                                elevation: 5,
                              )),
                          text(
                              "Date Created",
                              true,
                              textColorTheme(context),
                              14.0,
                              1.0,
                              false,
                              false,
                              context,
                              10.0,
                              FontWeight.normal),
                          text(
                              "Number of Songs",
                              true,
                              textColorTheme(context),
                              14.0,
                              1.0,
                              false,
                              false,
                              context,
                              10.0,
                              FontWeight.normal),
                        ]),
                  ))),
          Container(
              height: _height -
                  (AppBar().preferredSize.height +
                      (_medium
                          ? 380
                          : _height > 700
                              ? 380
                              : 350)),
              child: ReorderableListView(
                shrinkWrap: true,
                children: <Widget>[
                  for (int index = 0; index < myPlayList.length; index += 1)
                    _ItemView(context, index, myPlayList, true),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final PothiSahibData item = myPlayList.removeAt(oldIndex);
                    myPlayList.insert(newIndex, item);
                  });
                },
              ))
        ]));
  }
}
