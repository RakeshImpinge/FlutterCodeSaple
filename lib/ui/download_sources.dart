import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/responsive_ui.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

class DownloadSources extends StatefulWidget {
  const DownloadSources({Key? key}) : super(key: key);

  @override
  DownloadSourcesState createState() => DownloadSourcesState();
}

class DownloadSourcesState extends State<DownloadSources> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _medium;
  final List<String> downloadSources = [
    Strings.sriGuruGranthSahibJi,
    Strings.sriDasamGuruGranthSahibJi,
    Strings.vaaranBhaiGurdasJi
  ];

  final List<String> availableDownloads = [
    Strings.bhaiGurdasJiKabitSavaeiay,
    Strings.sriSablohGranth,
    Strings.vaaranBhaiNandLaalJi,
    Strings.vaaranBhaiBurdasSinghJi,
  ];
  late List<bool> _isChecked;
  late List<bool> _isAvailableDownloadChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(downloadSources.length, false);
    _isAvailableDownloadChecked =
        List<bool>.filled(availableDownloads.length, false);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
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
          titleSpacing: 10,
          title: const Text(Strings.download_source),
          titleTextStyle: const TextStyle(
            fontSize: 21,
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: _height,
            width: _width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        text(
                            Strings.download_source,
                            false,
                            Theme.of(context).dividerColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            15,
                            FontWeight.bold),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: downloadSources.length,
                          padding: const EdgeInsets.all(1),
                          itemBuilder: (context, index) {
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
                                        _isChecked[index] = !_isChecked[index];
                                      });
                                    },
                                    icon: _isChecked[index]
                                        ? Image.asset(
                                            AssetsName.ic_checkbox_checked,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            width: 25,
                                            height: 25)
                                        : Image.asset(
                                            AssetsName.ic_checkbox_unchecked,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            width: 20,
                                            height: 20,
                                          ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      downloadSources[index],
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color:
                                              Theme.of(context).indicatorColor,
                                          fontFamily: Strings.AcuminFont),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        text(
                            Strings.availableForDownload,
                            false,
                            Theme.of(context).dividerColor,
                            20.0,
                            1.0,
                            false,
                            false,
                            context,
                            15,
                            FontWeight.bold),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableDownloads.length,
                          padding: const EdgeInsets.all(1),
                          itemBuilder: (context, index) {
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
                                        _isAvailableDownloadChecked[index] =
                                            !_isAvailableDownloadChecked[index];
                                      });
                                    },
                                    icon: _isAvailableDownloadChecked[index]
                                        ? Image.asset(AssetsName.ic_checkbox_checked,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            width: 25,
                                            height: 25)
                                        : Image.asset(
                                            AssetsName.ic_checkbox_unchecked,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            width: 20,
                                            height: 20,
                                          ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      availableDownloads[index],
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color:
                                              Theme.of(context).indicatorColor,
                                          fontFamily: Strings.AcuminFont),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        _updateSourceButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  /*
   *  update source button
   */
  Widget _updateSourceButton(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            backgroundColor: Theme.of(context).dividerColor,
            side: BorderSide(width: 2.0, color: Theme.of(context).dividerColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text(
          Strings.updateSources,
          style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ));
  }
}
