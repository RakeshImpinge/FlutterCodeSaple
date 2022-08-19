import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_shudh_gurbani/bloc/tabView/tab_bloc.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../app_themes.dart';
import '../bloc/banis/banis_bloc.dart';
import '../bloc/banis/banis_event.dart';
import '../bloc/tabView/tab_events.dart';
import '../constants/constants.dart';
import '../services/repository.dart';
import '../strings.dart';
import '../ui/pothi_sahib_viewer.dart';
import '../ui/search_menu.dart';
import '../ui/sehaj_paath_listing.dart';

class CustomTabBarView extends StatefulWidget {
   bool isColoChange = false;
   CustomTabBarView({Key? key,required this.isColoChange}) : super(key: key);
   static String inputText="";

  @override
  State<CustomTabBarView> createState() => TabBarViewState();
}

class TabBarViewState extends State<CustomTabBarView> with SingleTickerProviderStateMixin {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _medium;
  late bool large;
  static late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2,initialIndex: 0);
    BlocProvider.of<TabBloc>(context).add(TabEvent(index:0));

    controller.addListener(() {
      CustomTabBarView.inputText="";
      BlocProvider.of<TabBloc>(context).add(TabEvent(index:controller.index));
    });
  }

  @override
  void dispose() {
    BlocProvider.of<TabBloc>(context).add(TabEvent(index:0));
    controller.index==0;
    controller.dispose();
    super.dispose();
  }
  getSelectedTab(){
    return controller.index;
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return DefaultTabController(length: 2,
        initialIndex: 0,
        child: Scaffold(backgroundColor: widget.isColoChange==true?controller.index==1?AppThemes.darkBlueColor:null:Colors.transparent,
          appBar:TabBar(
            controller: controller,
            indicatorColor: Theme.of(context).dividerColor,
            labelColor: Theme.of(context).dividerColor,
            unselectedLabelColor: AppThemes.greyColor,
            indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
            tabs: [
              Tab(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Container(
                              child: const Center(child: Text(
                                Strings.gurbaniSearch,
                                style: TextStyle(fontFamily: Strings.AcuminFont, fontSize: 12, fontWeight: FontWeight.bold),
                              )),
                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppThemes.greyColor))))),
                    ]),
              ),
              Tab(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Container(child: const Center(
                          child: Text(Strings.pothiGurbaniSearch, style: TextStyle(fontFamily: Strings.AcuminFont, fontSize: 12, fontWeight: FontWeight.bold))), decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppThemes.greyColor))))),
                    ]),
              ),
            ],
          ),
          body: TabBarView(
            controller: controller,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10, left: 15, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(child: _customSearchView(context, Strings.searchHint)),
                          flex: 2),
                        iconOptions()
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10, left: 15, right: 15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              child: _customSearchView(context, Strings.pura_shabad)),
                          flex: 2,
                        ),
                        iconOptions()
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  /*
   * Custom Search View
   */
  Widget _customSearchView(BuildContext context, String searchHint) {
    return Material(
      color: AppThemes.greyLightColor,
      borderRadius: BorderRadius.circular(30),
      elevation: large ? 6 : (_medium ? 4 : 2),
      child: Padding(padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  // controller: TextEditingController(),
                  keyboardType: TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  maxLines: 1,
                  onChanged: (text) {
                    CustomTabBarView.inputText= text;
                  //  BanisBloc(Repository(),CustomTabBarView.inputText)..add(BanisFetched());
                  },
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                    decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15.0, right: 2.0, top: 2.0, bottom: 2.0),
                    hintText: searchHint,
                    hintStyle: TextStyle( letterSpacing: 2,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontFamily: Strings.gurbaniAkharLightFont),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                  ),
                ),
                flex: 1,
              ),
              IconButton(iconSize: 30,
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (searchHint == Strings.searchHint) {
                    BanisBloc(Repository(),CustomTabBarView.inputText).add(SearchBanisFetched());
                    navigationPage(context, sehajPaathListing, const SehajPaathListingScreen());
                  } else {
                    navigationPage(context, pothiSahibViewer, const PothiSahibViewer());
                  }
                },
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor, size: 30),
              )
            ],
          )),
    );
  }

  /*
   * function to show list of icons
   */
  Widget iconOptions() {
    return Expanded(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(iconSize: 30,
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(),
              onPressed: () {
              },
              icon: SvgPicture.asset(
                AssetsName.ic_history,
                color: Theme.of(context).dividerColor,
                width: 30,
                height: 30,
                fit: BoxFit.fill,
              ),
            ),
            IconButton(iconSize: 30,
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: Image.asset(AssetsName.ic_favourite, width: 30, height: 30, fit: BoxFit.fill),
            ),
            IconButton(iconSize: 30,
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              constraints: const BoxConstraints(),
              onPressed: () {
                navigationPage(context, searchMenu, const SearchMenu());
              },
              icon: SvgPicture.asset(AssetsName.ic_circle_more_options,
                  color: Theme.of(context).dividerColor,
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill),
            ),
          ]),
      flex: 1,
    );
  }

}



