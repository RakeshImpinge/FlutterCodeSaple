import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/raag/raag_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/raag/raag_event.dart';
import 'package:learn_shudh_gurbani/bloc/raag/raag_state.dart';
import 'package:learn_shudh_gurbani/bloc/searchMenu/search_menu_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/sourceList/sources_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/sourceList/sources_event.dart';
import 'package:learn_shudh_gurbani/bloc/sourceList/sources_state.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/expandable.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../bloc/searchMenu/search_menu_event.dart';
import '../bloc/searchMenu/search_menu_state.dart';
import '../bloc/writers/writers_bloc.dart';
import '../bloc/writers/writers_event.dart';
import '../bloc/writers/writers_state.dart';
import '../services/preferenecs.dart';


class SearchMenu extends StatefulWidget {
  const SearchMenu({Key? key}) : super(key: key);

  @override
  SearchMenuState createState() => SearchMenuState();
}

class SearchMenuState extends State<SearchMenu> {
  bool _isChecked = false, isFilterApply = false;
  late List<bool> isSearchTypeSelected,
      isRaagSearchSelected,
      isWriterSearchSelected;
  late List<bool> isGranthSahibSelected;
  String defaultSelectedOption = Strings.larrivar;
  var doubleTapListOptions = [
    Strings.larrivar,
    'Test 1',
    'Test 2',
    'Test 3',
    'Test 4',
    'Test 5'
  ];
  final List<String> searchTypes = [
    Strings.firstLetterStart,
    Strings.firstLetterAnywhere,
    Strings.angVaar,
    Strings.gurmukhi,
    Strings.english,
  ];
  @override
  void initState() {
    super.initState();
    isSearchTypeSelected = List<bool>.filled(searchTypes.length, false);
    isGranthSahibSelected = List<bool>.filled(7, false);
    isRaagSearchSelected = List<bool>.filled(31, false);
    isWriterSearchSelected = List<bool>.filled(42, false);
   }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isFilterApply == true ||
              isSearchTypeSelected.contains(true) ||
              isGranthSahibSelected.contains(true) ||
              isRaagSearchSelected.contains(true) ||
              isWriterSearchSelected.contains(true)) {
            return true;
          } else {
            showAlert(context);
            return false;
          }
        },
        child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.direction <= 0) {
                if (isFilterApply == true ||
                    isSearchTypeSelected.contains(true) ||
                    isGranthSahibSelected.contains(true) ||
                    isRaagSearchSelected.contains(true) ||
                    isWriterSearchSelected.contains(true)) {
                  Navigator.of(context).pop();
                } else {
                  showAlert(context);
                }
              }
            },
            child: Scaffold(
              backgroundColor: isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).primaryColor,
              body: Container(color: isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).primaryColor,
                child: Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 30, bottom: 25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _expansionPanel(context),
                          _divider(10),
                          _expansionPanel3(context),
                          _divider(10),
                          _expansionPanel4(context),
                          _divider(10),
                          _expansionPanel5(context),
                          _divider(10),
                          _expansionPanel6(context),
                        ]),
                  ),
                ),
              ),
            )));
  }

  /*
  Search Type View
   */
  Widget _searchTypeView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: searchTypes.length,
          padding: const EdgeInsets.only(left: 5, right: 5),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    iconSize: 25,
                    padding: const EdgeInsets.all(1.0),
                    onPressed: () {
                      setState(() {
                        isSearchTypeSelected[index] = !isSearchTypeSelected[index];
                      });
                    },
                    icon: isSearchTypeSelected[index] ? Image.asset(AssetsName.ic_checkbox_checked,
                            color: Theme.of(context).indicatorColor, width: 25, height: 25)
                        : Image.asset(AssetsName.ic_checkbox_unchecked,
                            color: Theme.of(context).indicatorColor, width: 20, height: 20,),
                  ),
                  Flexible(child: Text(searchTypes[index],
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Theme.of(context).indicatorColor,
                          fontFamily: Strings.AcuminFont),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(padding: const EdgeInsets.only(top: 15, bottom: 0, left: 20, right: 20),
          child: text(Strings.similarLetters,
              false,
              Theme.of(context).indicatorColor,
              14.0,
              1.0,
              false,
              false,
              context,
              15,
              FontWeight.bold),
        ),
        Padding(padding: const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
          child: text(Strings.similarLettersExampleText,
              false,
              Theme.of(context).indicatorColor,
              14.0,
              1.0,
              false,
              false,
              context,
              10,
              FontWeight.normal),
        ),
        Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        text(Strings.similarOption_1_1,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        text(Strings.reversibleArrow,
                            false,
                            Theme.of(context).dividerColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.bold),
                        text(Strings.similarOption_1_2,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        SizedBox(height: 35, //set desired REAL HEIGHT
                          width: 60, // set desire Real WIDTH
                          child: Transform.scale(
                            transformHitTests: false,
                            scale: 0.8,
                            //set desired REAL WIDTH
                            child: BlocBuilder<SearchMenuBloc, SearchMenuScreenState>(
                              builder: (context, state) {
                                return CupertinoSwitch(
                                  value: state.isOptionOneEnable!,
                                  onChanged: (value) {
                                    context.read<SearchMenuBloc>().add(OptionOneChanged(optionOne: value));
                                  },
                                  activeColor: Theme.of(context).dividerColor,
                                  trackColor: AppThemes.lightBlue,
                                );
                              },)
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        text(Strings.similarOption_2_1,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        text(Strings.reversibleArrow,
                            false,
                            Theme.of(context).dividerColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.bold),
                        text(Strings.similarOption_2_2,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        SizedBox(
                          height: 35, //set desired REAL HEIGHT
                          width: 60, // set desire Real WIDTH
                          child: Transform.scale(
                            transformHitTests: false,
                            scale: 0.8,
                            //set desired REAL WIDTH
                            child:BlocBuilder<SearchMenuBloc, SearchMenuScreenState>(
                            builder: (context, state) {
                            return CupertinoSwitch(
                              value: state.isOptionTwoEnable!,
                              onChanged: (value) {
                                context.read<SearchMenuBloc>().add(OptionTwoChanged(optionTwo: value));
                              },
                              activeColor: Theme.of(context).dividerColor,
                              trackColor: AppThemes.lightBlue,
                            );
                            },
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        text(Strings.similarOption_3_1,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        text(Strings.reversibleArrow,
                            false,
                            Theme.of(context).dividerColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.bold),
                        text(Strings.similarOption_3_2,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        SizedBox(
                          height: 35, //set desired REAL HEIGHT
                          width: 60, // set desire Real WIDTH
                          child: Transform.scale(
                            transformHitTests: false,
                            scale: 0.8,
                            //set desired REAL WIDTH
                            child: BlocBuilder<SearchMenuBloc, SearchMenuScreenState>(
                            builder: (context, state) {
                            return CupertinoSwitch(
                              value: state.isOptionThirdEnable!,
                              onChanged: (value) {
                                context.read<SearchMenuBloc>().add(OptionThreeChanged(optionThree: value));
                              },
                              activeColor: Theme.of(context).dividerColor,
                              trackColor: AppThemes.lightBlue,
                            );
                            })
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        text(
                            Strings.similarOption_4_1,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        text(Strings.reversibleArrow,
                            false,
                            Theme.of(context).dividerColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.bold),
                        text(Strings.similarOption_4_2,
                            false,
                            Theme.of(context).indicatorColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            1,
                            FontWeight.normal,Strings.gurmukhiFont),
                        SizedBox(
                          height: 35, //set desired REAL HEIGHT
                          width: 60, // set desire Real WIDTH
                          child: Transform.scale(
                            transformHitTests: false,
                            scale: 0.8,
                            //set desired REAL WIDTH
                             child: BlocBuilder<SearchMenuBloc, SearchMenuScreenState>(
                             builder: (context, state) {
                             return CupertinoSwitch(
                              value: state.isOptionFourEnable!,
                              onChanged: (value) {
                                context.read<SearchMenuBloc>().add(OptionFourChanged(optionFour: value));
                              },
                              activeColor: Theme.of(context).dividerColor,
                              trackColor: AppThemes.lightBlue,
                            );
                             })
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  /*
  Granth sahib view
   */
  Widget _granthSahibView(BuildContext context) {
    return BlocBuilder<SourcesBloc, SourcesState>(
      builder: (context, state) {
        if (state is SourcesInitial) {
          context.read<SourcesBloc>().add(SourcesFetched());
          return showLoader();
        } else if (state is SourcesLoaded) {
         return ListView.builder(
            shrinkWrap: true,
            itemCount: state.data.length,
            padding: const EdgeInsets.all(1),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(iconSize: 25,
                      padding: const EdgeInsets.all(1.0),
                      onPressed: () {
                        setState(() {
                          isGranthSahibSelected[index] = !isGranthSahibSelected[index];
                        });
                      },
                      icon: isGranthSahibSelected[index]
                          ? Image.asset(AssetsName.ic_checkbox_checked,
                          color: Theme.of(context).indicatorColor,
                          width: 25,
                          height: 25)
                          : Image.asset(
                        AssetsName.ic_checkbox_unchecked,
                        color: Theme.of(context).indicatorColor,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        state.data[index].name,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Theme.of(context).indicatorColor,
                            fontFamily: Strings.AcuminFont),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        else {
          return showLoader();
        }
      },
    );
  }

  /*
   * Raag Search view
   */
  Widget _raagSearchView(BuildContext context) {
   return BlocBuilder<RaagBloc, RaagState>(
      builder: (context, state) {
        if (state is RaagInitial) {
          context.read<RaagBloc>().add(RaagFetched());
          return showLoader();
        } else if (state is RaagLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.data.length,
            padding: const EdgeInsets.all(1),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      iconSize: 25,
                      padding: const EdgeInsets.all(1.0),
                      onPressed: () {
                        setState(() {
                          isRaagSearchSelected[index] = !isRaagSearchSelected[index];
                        });
                      },
                      icon: isRaagSearchSelected[index]
                          ? Image.asset(AssetsName.ic_checkbox_checked,
                          color: Theme.of(context).indicatorColor,
                          width: 25,
                          height: 25)
                          : Image.asset(AssetsName.ic_checkbox_unchecked,
                        color: Theme.of(context).indicatorColor,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Flexible(
                      child: Text(state.data[index].name,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Theme.of(context).indicatorColor,
                            fontFamily: Strings.AcuminFont),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return showLoader();
        }
      },
    );
  }

  /*
   * Writers Search view
   */
  Widget _writersSearchView() {
    return BlocBuilder<WritersBloc, WritersState>(
      builder: (context, state) {
        if (state is WritersInitial) {
          context.read<WritersBloc>().add(WritersFetched());
          return showLoader();
        } else if (state is WritersLoaded) {
          return ListView.builder(
            shrinkWrap:true,
            itemCount:state.data.length,
            padding: const EdgeInsets.all(1),
            itemBuilder: (context, itemIndex) {
              return Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      iconSize: 25,
                      padding: const EdgeInsets.all(1.0),
                      onPressed: () {
                        setState(() {
                          isWriterSearchSelected[itemIndex] = !isWriterSearchSelected[itemIndex];
                        });
                      },
                      icon: isWriterSearchSelected[itemIndex]
                          ? Image.asset(AssetsName.ic_checkbox_checked,
                          color: Theme.of(context).indicatorColor,
                          width: 25,
                          height: 25)
                          : Image.asset(
                        AssetsName.ic_checkbox_unchecked,
                        color: Theme.of(context).indicatorColor,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        state.data[itemIndex].name,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Theme.of(context).indicatorColor,
                            fontFamily: Strings.AcuminFont),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return showLoader();
        }
      },
    );
  }

  /*
  double tap option child View
   */
  Widget _doubleTapView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0, left: 20, right: 20),
          child: text(
              Strings.doubleTapText,
              false,
              Theme.of(context).indicatorColor,
              14.0,
              1.0,
              false,
              false,
              context,
              15,
              FontWeight.w300),
        ),
        Padding(padding: const EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                iconSize: 25,
                padding: const EdgeInsets.all(1.0),
                onPressed: () {
                  setState(() {
                    _isChecked = !_isChecked;
                    if (_isChecked == true) {
                      isFilterApply = true;
                    }
                  });
                },
                icon: _isChecked
                    ? Image.asset(AssetsName.ic_checkbox_checked,
                        color: Theme.of(context).indicatorColor,
                        width: 25,
                        height: 25)
                    : Image.asset(
                        AssetsName.ic_checkbox_unchecked,
                        color: Theme.of(context).indicatorColor,
                        width: 20,
                        height: 20,
                      ),
              ),
              Flexible(
                child: Text(
                  Strings.enableDoubleTap,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Theme.of(context).indicatorColor,
                      fontFamily: Strings.AcuminFont),
                ),
              ),
            ],
          ),
        ),
        _doubleTapDropDownOptions(context),
      ],
    );
  }

  Widget _doubleTapDropDownOptions(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 25, right: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: defaultSelectedOption,
          iconEnabledColor: Theme.of(context).indicatorColor,
          iconDisabledColor: Theme.of(context).indicatorColor,
          dropdownColor: Theme.of(context).disabledColor,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: doubleTapListOptions.map((String itemOption) {
            return DropdownMenuItem(
                value: itemOption,
                child: Text(
                  itemOption,
                  style: const TextStyle(
                    fontFamily: Strings.AcuminFont,
                    fontWeight: FontWeight.normal,
                  ),
                ));
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              defaultSelectedOption = value!;
              if (defaultSelectedOption != Strings.larrivar) {
                isFilterApply = true;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _expansionPanel(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Color(0xFFF5D43B),
                  iconSize: 40,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Text(
                    Strings.searchType,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: Strings.AcuminFont,
                        color: Color(0xFFF5D43B)),
                  ),
                ),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[_searchTypeView(context)],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
    );
  }

  Widget _expansionPanel3(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Color(0xFFF5D43B),
                  iconSize: 40,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Text(Strings.raag,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5D43B)),
                  ),
                ),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[_raagSearchView(context)],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
    );
  }

  Widget _expansionPanel4(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Color(0xFFF5D43B),
                  iconSize: 40,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Text(
                    Strings.writter,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5D43B)),
                  ),
                ),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded:
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _writersSearchView()
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
    );
  }

  Widget _expansionPanel5(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Color(0xFFF5D43B),
                  iconSize: 40,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Text(
                    Strings.granth,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5D43B)),
                  ),
                ),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[_granthSahibView(context)],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
    );
  }

  Widget _expansionPanel6(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Color(0xFFF5D43B),
                  iconSize: 40,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Text(
                    Strings.doubleTap,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5D43B)),
                  ),
                ),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[_doubleTapView(context)],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
    );
  }

  /*
   function to show divider
  */
  Widget _divider(double padding) {
    return divider(
        color: Theme.of(context).dividerColor,
        thickness: 0.5,
        height: 5,
        indent: 1,
        endIndent: 0.0,
        padding: padding);
  }

  /*
   *  alert to get confirmation before exit screen.
   */
  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: text(Strings.alertTile, false, Theme.of(context).dividerColor,
              20.0, 1.0, false, true, context, 10, FontWeight.normal),
          content: text(
              Strings.alertMessageWithoutApplyFilter,
              false,
              Theme.of(context).indicatorColor,
              18.0,
              1.0,
              false,
              true,
              context,
              15,
              FontWeight.normal),
          actions: <Widget>[
            TextButton(
              child: text(Strings.no, false, Theme.of(context).dividerColor,
                  16.0, 1.0, false, true, context, 10, FontWeight.bold),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: text(Strings.yes, false, Theme.of(context).dividerColor,
                  16.0, 1.0, false, true, context, 10, FontWeight.bold),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ],
        );
      },
    );
  }
}
