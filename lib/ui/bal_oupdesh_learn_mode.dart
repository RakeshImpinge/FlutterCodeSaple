import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/bal_oupdesh_learn_mode_bloc.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/audio_player_view.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/custom_radio_button.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../services/preferenecs.dart';

class LearnModeScreen extends StatefulWidget {
  const LearnModeScreen({Key? key}) : super(key: key);

  @override
  LearnModeScreenState createState() => LearnModeScreenState();
}

class LearnModeScreenState extends State<LearnModeScreen>
    with SingleTickerProviderStateMixin {
  static bool toggleModeEnable = false,
      isTestModeEnable = false;
  List list = [
    "a",
    'A',
    "e",
    "s",
    "h",
    "k",
    "K",
    "g",
    "G",
    "|",
    "c",
    "C",
    "j",
    "J",
    "\\",
    "t",
    "T",
    "f",
    "F",
    "x",
    "q",
    "Q",
    "d",
    "D",
    "n",
    "p",
    "P",
    "b",
    "B",
    "m",
    "X",
    "r",
    "l",
    "v",
    "V"
  ];
  List radiobuttonList = [1, 2, 3, 4, 5, 6, 7];
  late final TabController _tabController;
  static int? selectedIndex;
  int id = -1;
  final bloc = LearnModeBloc();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: 0,
        animationDuration: Duration(milliseconds: 50));
    _tabController.addListener(() {
      setState(() {
        toggleModeEnable = false;
        if (_tabController.index == 1) {
          isTestModeEnable = true;
        } else {
          isTestModeEnable = false;
        }
        selectedIndex = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return backPressGestureDetection(context, Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColorDark,
          elevation: 0,
          leading: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: false,
          title: Text(Strings.akhar),
          titleTextStyle:
          const TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
          actions: [
            Visibility(
              visible: _tabController.index == 0 ? true : false,
              child: IconButton(
                iconSize: 30,
                padding: const EdgeInsets.only(right: 5),
                onPressed: () {
                  toggleModeEnable = !toggleModeEnable;
                  bloc.learnModeEnableSink.add(toggleModeEnable);
                },
                icon: Image.asset(
                  AssetsName.ic_toggle_bal_oupdesh,
                  color: Theme
                      .of(context)
                      .dividerColor,
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            color: Theme
                .of(context)
                .canvasColor,
            child: _tabsView()),
      ),
    ));
  }

  Widget _tabsView() {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Theme
              .of(context)
              .canvasColor,
          appBar: TabBar(
            indicatorWeight: 1.5,
            controller: _tabController,
            indicatorColor: Theme
                .of(context)
                .hoverColor,
            labelColor: Theme
                .of(context)
                .hoverColor,
            unselectedLabelColor: Theme
                .of(context)
                .hoverColor
                .withOpacity(0.6),
            indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
            tabs: [
              Tab(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                    Strings.learnMode,
                                    style: TextStyle(
                                        fontFamily: Strings.AcuminFont,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Theme
                                              .of(context)
                                              .hoverColor
                                              .withOpacity(0.4)))))),
                    ]),
              ),
              Tab(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(Strings.testMode,
                                      style: TextStyle(
                                          fontFamily: Strings.AcuminFont,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Theme
                                              .of(context)
                                              .hoverColor
                                              .withOpacity(0.4)))))),
                    ]),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              StreamBuilder<Object>(
                  stream: bloc.learnModeEnableStream,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.only(
                        top: toggleModeEnable ? 10 : 20,
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 130),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Visibility(
                                            visible: toggleModeEnable,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 40,
                                                  right: 20),
                                              height: 40,
                                              child: radioButtonView(5),
                                            )),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Visibility(
                                                  visible: toggleModeEnable,
                                                  child: Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: radioButtonView(1),
                                                  )),
                                              Flexible(
                                                flex: 9,
                                                fit: FlexFit.tight,
                                                child: _gridViewList(),
                                              ),
                                            ]),
                                      ]),
                                ),
                              )),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[AudioPlayerView()]),
                        ],
                      ),
                    );
                  }),
              // tab  2
              Column(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: _gridViewList(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  /**
   * function for gridview
   */

  Widget _gridViewList() {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 5,
        crossAxisCount: 5,
        children: List.generate(list.length, (index) {
          final GlobalKey key = GlobalKey<State<Tooltip>>();
          return Tooltip(
            key: key,
            message: 'ies AKr dw ieh aucwrn hY [ $index',
            waitDuration: Duration(seconds: 1),
            showDuration: Duration(seconds: 5),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            verticalOffset: 15,
            preferBelow: true,
            triggerMode: TooltipTriggerMode.tap,
            textStyle: TextStyle(
                fontSize: 16,
                color: isDarkMode(context)
                    ? Theme
                    .of(context)
                    .indicatorColor
                    : Theme
                    .of(context)
                    .primaryColorDark,
                fontWeight: FontWeight.w300,
                fontFamily: Strings.gurmukhiAkkharThickFont),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 15.0,
                  ), //BoxShadow
                ],
                color: isDarkMode(context)
                    ? AppThemes.greyLightColor3
                    : Theme
                    .of(context)
                    .indicatorColor),
            //BoxDecoration

            child: StreamBuilder<Object>(
                stream: bloc.learnModeItemClickStream,
                initialData: selectedIndex,
                builder: (context, snapshot) {
                  return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!isTestModeEnable) {
                          selectedIndex = index;
                          bloc.learnModeItemClickSink.add(index);
                          final dynamic tooltip = key.currentState;
                          tooltip?.ensureTooltipVisible();
                        }
                      },
                      child: Card(
                          elevation: 0,
                          semanticContainer: false,
                          shape: CircleBorder(),
                          color: selectedIndex == index
                              ? isDarkMode(context)
                              ? Theme
                              .of(context)
                              .disabledColor
                              : Theme
                              .of(context)
                              .primaryColorDark
                              .withOpacity(0.1)
                              : isDarkMode(context)
                              ? Theme
                              .of(context)
                              .primaryColor
                              : Theme
                              .of(context)
                              .canvasColor,
                          child: Center(
                            child: text(
                                list[index],
                                true,
                                textColorTheme(context),
                                34.0,
                                1.0,
                                false,
                                false,
                                context,
                                0,
                                FontWeight.w300,
                                Strings.gurmukhiAkkharThickFont),
                          )));
                }),
          );
        }));
  }

  Widget radioButtonView(int column) {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: column == 1 ? 37 : 20,
        crossAxisSpacing: column == 1 ? 37 : 20,
        crossAxisCount: column,
        children: List<Widget>.generate(
            column == 1 ? radiobuttonList.length : radiobuttonList.length - 2,
                (index) {
              return Container(
                  height: column == 1 ? 62 : 40,
                  width: 40,
                  child: isDarkMode(context)
                      ? MyRadioOption(
                    value: column == 5 ? index : (5 + index),
                    groupValue: id,
                    context: context,
                    onChanged: (val) {
                      setState(() {
                        id = column == 5 ? index : (5 + index);
                        selectedIndex = column == 5 ? index : ((5 * index));
                      });
                    },
                    label: '',
                    text: '',
                  )
                      : Radio(
                    activeColor: isDarkMode(context)
                        ? Theme
                        .of(context)
                        .indicatorColor
                        : Theme
                        .of(context)
                        .primaryColorDark,
                    fillColor: MaterialStateProperty.all(
                      isDarkMode(context)
                          ? AppThemes.lightGreyTextColor
                          : Theme
                          .of(context)
                          .primaryColorDark,
                    ),
                    value: column == 5 ? index : (5 + index),
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        id = column == 5 ? index : (5 + index);
                        selectedIndex = column == 5 ? index : ((5 * index));
                      });
                    },
                  ));
            }));
  }
}
