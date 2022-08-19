import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/pothi_sahib/pothi_sahib_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/pothi_sahib/pothi_sahib_event.dart';
import 'package:learn_shudh_gurbani/bloc/pothi_sahib/pothi_sahib_state.dart';
import 'package:learn_shudh_gurbani/services/repository.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../bloc/app_info/app_info_bloc.dart';
import '../bloc/app_info/app_info_event.dart';
import '../bloc/app_info/app_info_state.dart';
import '../bloc/banis/banis_bloc.dart';
import '../bloc/banis/banis_event.dart';
import '../bloc/banis/banis_state.dart';
import '../bloc/tabView/tab_bloc.dart';
import '../bloc/tabView/tab_state.dart';
import '../constants/constants.dart';
import '../widgets/tab_view.dart';
import 'pothi_sahib_viewer.dart';

class SearchGurbani extends StatefulWidget {
  const SearchGurbani({Key? key}) : super(key: key);

  @override
  SearchGurbaniState createState() => SearchGurbaniState();
}

class SearchGurbaniState extends State<SearchGurbani>
    with SingleTickerProviderStateMixin {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _medium;
  late bool large;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;_pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);

     return backPressGestureDetection(context,
        Material(child: BlocBuilder<TabBloc, TabState>(
        builder: (BuildContext context, TabState tabState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor:tabState.index==1 ? AppThemes.darkBlueColor : Theme.of(context).primaryColorDark,
              elevation: 0,
              leading: IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              actions: [
                BlocProvider(
                  create: (_) => AppInfoBloc(Repository(),2,4)..add(AppInfoFetched()),
                  child: BlocBuilder<AppInfoBloc, AppInfoState>(
                    builder: (context1, state) {
                    if (state is AppInfoInitial ||
                        (state is AppInfoFetching && state.isInitial)) {
                        return  Center(child: showLoader());
                        } else if (state is AppInfoFetchSuccess || (state is AppInfoFetching && !state.isInitial)) {
                        return IconButton(iconSize: 25, padding: const EdgeInsets.only(right: 25),
                        onPressed: () {
                        helpAlert(context, 25,state.data[0].text_english,state.data[0].subsection);
                        },
                        icon: Image.asset(AssetsName.ic_help),
                       );
                    } else {
                      return IconButton(iconSize: 25,
                          padding: const EdgeInsets.only(right: 25),
                          onPressed: () {
                            helpAlert(context, 25, state.data[0].text_english, state.data[0].subsection);
                          },
                          icon: Image.asset(AssetsName.ic_help));
                    }})),
              ],
              centerTitle: false,
              titleSpacing: 10,
              title: Text(tabState.index==1?Strings.pothiSahibSearch:Strings.gurbaniSearch),
              titleTextStyle: const TextStyle(fontSize: 21),
            ),
            body: Container(
              color: tabState.index==1?AppThemes.darkBlueColor:Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(child:Container(color: Theme.of(context).canvasColor,
                child: BlocBuilder<TabBloc, TabState>(
                    builder: (BuildContext context, TabState tabState) {
                      return Stack(
                        children: [
                          Positioned.fill(
                              child:tabState.index==1?_pothiSahibListView(): BlocProvider(
                                create: (_) => BanisBloc(Repository())..add(BanisFetched()),
                                child: _gurbaniListView(),
                              ),
                            ),
                          Column(crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[_showModalBottomSheet(context,)]),
                        ],
                      );
                    }),
                ),
              ),
            ));
    })),
    );
  }

  /*
   Pothi Sahib View
   */
  Widget _pothiSahibListView() {
    return Padding(padding: const EdgeInsets.only(top: 10, bottom: 150),child:BlocBuilder<PothiSahibBloc, PothiSahibState>(
      builder: (context, state) {
        if (state is PothiSahibInitial) {
          context.read<PothiSahibBloc>().add(PothiSahibFetched());
          return showLoader();
        } else if (state is PothiSahibLoaded) {
          return ListView.builder(
            shrinkWrap:true,
            itemCount:state.data.length,
            padding: const EdgeInsets.all(1),
            itemBuilder: (context, itemIndex) {
              return Padding(padding: const EdgeInsets.only(top: 1),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            navigationPage(context, pothiSahibViewer, const PothiSahibViewer());
                          },
                          child: listTileSearchItem(
                            context: context,
                            image: '',
                            name: state.data[itemIndex].name,
                            value: Strings.transliteration,
                            value1: state.data[itemIndex].name_english,
                            value2: Strings.baniGuruSahibWriter,
                            line: 3,fontStyle: Strings.gurmukhiAkkharThickFont)),
                        divider(color: AppThemes.darkBrownColor.withOpacity(0.6),
                          thickness: 0.7,
                          height: 5,
                          indent: 1,
                          endIndent: 0.0,
                          padding: 10),
                  ],
                ),
              );
            },
          );
        } else {
          return showLoader();
        }
      },
    ));
  }

  /*
   * load Gurbani list
   */
  Widget _gurbaniListView() {
    return Padding(padding: const EdgeInsets.only(top: 10, bottom: 150),
        child: BlocBuilder<BanisBloc, BanisState>(
        builder: (context, state) {
      if (state is BanisInitial || (state is BanisFetching && state.isInitial)) {
        return Center(child: showLoader());
      } else if (state is BanisFetchSuccess ||
          (state is BanisFetching && !state.isInitial)) {
          return ListView.builder(
            shrinkWrap:true,
            itemCount:state.data.length,
            padding: const EdgeInsets.all(1),
            itemBuilder: (context, itemIndex) {
              return Padding(padding: const EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                           navigationPage(context, pothiSahibViewer, const PothiSahibViewer());
                        },
                        child: listTileSearchItem(
                            context: context,
                            image: '',
                            name: state.data[itemIndex].gurmukhi,
                            value: Strings.transliteration,
                            value1: state.data[itemIndex].english,
                            value2: Strings.baniGuruSahibWriter,
                            line: 3,fontStyle: Strings.gurmukhiAkkharThickFont)),
                        divider(color: AppThemes.darkBrownColor.withOpacity(0.6),
                            thickness: 0.7,
                            height: 5,
                            indent: 1,
                            endIndent: 0.0,
                            padding: 10),
                  ],
                ),
              );
            },
          );
      } else if (state is BanisFetchFailure) {
        return ErrorMessageWidget(exception: state.exception);
      } else {
        return const SizedBox();
      }
      },
    ));
  }

  /*
   * bottom modal sheet
   */
  Widget _showModalBottomSheet(BuildContext context) {
    return SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: CustomTabBarView(isColoChange: true,)
    );
  }

}
