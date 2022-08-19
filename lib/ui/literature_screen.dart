import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/pothiSahibDataModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/horizontal_progress_bar.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../services/preferenecs.dart';

class LiteratureScreen extends StatefulWidget {
  const LiteratureScreen({Key? key}) : super(key: key);

  @override
  LiteratureScreenState createState() => LiteratureScreenState();
}

class LiteratureScreenState extends State<LiteratureScreen>
    with SingleTickerProviderStateMixin {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late List<bool> _visible;
  late AnimationController animationController;
  late Animation<double> animation;
  final pdf = pw.Document();
  bool isSearchEnable = true;
  bool _isSearching = false;
  List<PothiSahibData> list = [
    PothiSahibData('1', "poQI swihb nym", 'Pothi Sahib Name', 60),
    PothiSahibData('1', "poQI swihb nym", 'Pothi Sahib Name 2', 35),
    PothiSahibData('1', "poQI swihb nym", 'Pothi Sahib Name 3', 90)
  ];
  final textController = TextEditingController();
  List<PothiSahibData> searchResult = [];

  @override
  void initState() {
    super.initState();
    // pdf = pw.Document();
//https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
    _visible = List<bool>.filled(list.length, false);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 50));
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return backPressGestureDetection(
        context,
        Material(
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
              actions: [
                Container(margin: const EdgeInsets.only(left: 50, top: 10, bottom: 10, right: 10),
                    width: isSearchEnable ? _width - 160 : _width - 120,
                    child: _customSearchView(context, Strings.search)),
                Visibility(visible: isSearchEnable,
                    child: IconButton(
                      iconSize: 25,
                      padding: const EdgeInsets.only(right: 1),
                      icon: SvgPicture.asset(AssetsName.ic_search,
                          color: Theme.of(context).dividerColor,
                          width: 25,
                          height: 25,
                          fit: BoxFit.fill),
                      onPressed: () {
                        setState(() {
                          textController.clear();
                          isSearchEnable = false;
                          animation = CurvedAnimation(parent: animationController, curve: Curves.elasticIn);
                          animation.addListener(() => setState(() {}));
                          animationController.forward();
                        });
                      },
                    )),
                IconButton(iconSize: 25,
                  color: Theme.of(context).dividerColor,
                  padding: const EdgeInsets.only(right: 20),
                  onPressed: () {
                    helpAlert(context, 20);
                    // CheckInternetConnection.isInternetAvailable().then((connectionResult) {
                    //   if(connectionResult){
                    //     helpAlert(context,20);
                    //   }else{
                    //     CheckInternetConnection.showAlert(context, "Kindly Check your Internet Connection");
                    //   }
                    // });
                  },
                  icon: Image.asset(AssetsName.ic_help,
                      width: 25, height: 25, fit: BoxFit.fill),
                ),
              ],
              centerTitle: false,
              title: const Text(Strings.pothiSahibs),
              titleTextStyle:
                  const TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
            ),
            body: Container(
              color: isDarkMode(context) ? Theme.of(context).primaryColorDark : Theme.of(context).canvasColor,
              child: SafeArea(
                child: SizedBox(
                  height: _height,
                  width: _width,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.separated(shrinkWrap: true,
                                itemCount: _isSearching ? searchResult.length : list.length,
                                separatorBuilder: (BuildContext context, int index) =>
                                const Divider(height: 2,
                                    color: AppThemes.greyColor),
                                itemBuilder: (context, index) {
                                  return _ItemView(context, index);
                                },
                              ),
                              Padding(padding: const EdgeInsets.only(top: 10),
                                child: Divider(height: 2, color: _isSearching ? searchResult.length > 0 ? AppThemes.greyColor : Colors.transparent : AppThemes.greyColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  /*
   *   child view of list
   */
  Widget _ItemView(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textList(
                        _isSearching ? searchResult[index].title : list[index].title,
                        false,
                        Theme.of(context).hoverColor,
                        24.0,
                        1.0,
                        false,
                        1,
                        context,
                        5,
                        FontWeight.w300,
                        Strings.gurmukhiAkkharThickFont),
                    IconButton(constraints: const BoxConstraints(),
                      onPressed: () {
                        _visible = List<bool>.filled(list.length, false);
                        setState(() {
                          _visible[index] = !_visible[index];
                        });
                      },
                      icon: SvgPicture.asset(AssetsName.ic_circle_more_options,
                          color: Theme.of(context).hoverColor,
                          width: 15,
                          height: 15,
                          fit: BoxFit.fill),
                    ),
                  ],
                ),
                textList(
                    _isSearching ? searchResult[index].description : list[index].description,
                    false,
                    isDarkMode(context) ? Theme.of(context).indicatorColor : Theme.of(context).hoverColor,
                    18.0,
                    1.0,
                    false,
                    2,
                    context,
                    10,
                    FontWeight.w600),
                Padding(padding: EdgeInsets.only(top: 5, right: 50),
                    child: ProgressBar(
                        max: 100,
                        current: list[index].progress,
                        color: Theme.of(context).hoverColor.withOpacity(0.4),
                        filledColor: Theme.of(context).hoverColor)),
              ]),
        ),
        _showMoreOptions(index)
      ],
    );
  }

  Widget _showMoreOptions(int index) {
    return Visibility(
      visible: _visible[index],
      child: Align(alignment: Alignment.centerRight,
        child: Container(
          width: _width / 2,
          margin: const EdgeInsets.all(15),
          color: Colors.transparent,
          constraints: BoxConstraints(
            minHeight: 70, //minimum height
            minWidth: _width / 2,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            shadowColor: AppThemes.darkBrownColor,
            elevation: 10,
            color: isDarkMode(context) ? AppThemes.greyLightColor3 : Theme.of(context).canvasColor,
            semanticContainer: true,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          _visible[index] = false;
                        });
                      },
                      child: text(
                          Strings.addToKamaiyi,
                          true,
                          Theme.of(context).hoverColor,
                          16.0,
                          1.0,
                          false,
                          false,
                          context,
                          10,
                          FontWeight.w600)),
                  const Padding(padding: EdgeInsets.only(top: 10),
                    child: Divider(height: 2, color: AppThemes.greyColor),
                  ),
                  Padding(padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _visible[index] = false;
                          });
                          writeOnPdf();
                          savePdf();

                        },
                        child: text(
                            Strings.viewAsPDF,
                            true,
                            Theme.of(context).hoverColor,
                            16.0,
                            1.0,
                            false,
                            false,
                            context,
                            10,
                            FontWeight.w600),
                      ))
                ]),
          ),
        ),
      ),
    );
  }

  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(30),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('Demo', textScaleFactor: 2),
                  ]
              )), pw.Header(level: 1, text: 'What is Lorem Ipsum?'),

          // Write All the paragraph in one line.
          // For clear understanding
          // here there are line breaks.
          pw.Paragraph(style: pw.TextStyle(fontStyle: pw.FontStyle.normal, fontSize: 18),
              text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                  "\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumWhy do we use itIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, \n "
                  "and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years,"),
          pw.Paragraph(style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 18),
              text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                  "\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumWhy do we use itIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, \n "
                  "and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years,"),
          pw.Paragraph(style: pw.TextStyle(fontStyle: pw.FontStyle.normal, fontSize: 18, lineSpacing: 2,wordSpacing: 2),
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                  "\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumWhy do we use itIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, \n "
                  "and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years,"),
          pw.Paragraph(style: pw.TextStyle(fontStyle: pw.FontStyle.normal, fontSize: 18),
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                  "\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumWhy do we use itIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, \n "
                  "and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years,"),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ];
      },
    ));
  }

  Future<void> savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/test.pdf");
    file.writeAsBytesSync(await pdf.save());
    var filePath= file.path;
    print("path>>===$filePath");

     Navigator.pushNamed(
       context,
       literatureViewPDF,
       arguments: "" + filePath,
     );
  }

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
                      style: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 16),
                          decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15.0, right: 2.0, top: 2.0, bottom: 2.0),
                          hintText: searchHint,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none)),
                    ),
                    flex: 1,
                  ),
                  IconButton(
                    iconSize: 23,
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
                        color: Theme.of(context).indicatorColor, size: 23),
                  )
                ],
              ))),
    );
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      _isSearching = false;
      setState(() {});
      return;
    }
    for (var PothiSahibData in list) {
      _isSearching = true;
      if (PothiSahibData.description
          .toLowerCase()
          .startsWith(text.toLowerCase())) searchResult.add(PothiSahibData);
    }

    setState(() {});
  }
}
