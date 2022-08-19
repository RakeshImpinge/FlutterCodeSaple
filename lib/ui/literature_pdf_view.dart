import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/audio_player_view.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

class LiteratureViewPDF extends StatefulWidget {
  const LiteratureViewPDF({Key? key, String }) : super(key: key);

  @override
  LiteratureViewPDFState createState() => LiteratureViewPDFState();
}

class LiteratureViewPDFState extends State<LiteratureViewPDF>
    with SingleTickerProviderStateMixin {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Object? pdfPath = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
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
        title: Text('Pothi Sahib'),
        titleTextStyle:
            const TextStyle(fontSize: 21, fontFamily: Strings.AcuminFont),
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              Flexible(
                flex: 8,
                  child: Stack( fit: StackFit.expand,
                      children: [
                       PDFView(
                          filePath: pdfPath.toString(),
                          enableSwipe: true,
                          swipeHorizontal: true,
                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: true,
                          fitEachPage: true,
                          fitPolicy: FitPolicy.BOTH,
                          defaultPage: currentPage!,
                          preventLinkNavigation:
                          false, // if set to true the link is handled in flutter
                          onRender: (_pages) {
                            setState(() {
                              pages = _pages;
                              isReady = true;
                            });
                          },
                          onError: (error) {
                            setState(() {
                              errorMessage = error.toString();
                              showSnackbar(context,errorMessage,Strings.AcuminFont);

                            });
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            setState(() {
                              errorMessage = '$page: ${error.toString()}';
                              showSnackbar(context,errorMessage,Strings.AcuminFont);
                            });
                            print('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            _controller.complete(pdfViewController);
                          },
                          onLinkHandler: (String? uri) {
                            print('goto uri: $uri');
                          },
                          onPageChanged: (int? page, int? total) {
                            print('page change: $page/$total');
                            setState(() {
                              currentPage = page;
                            });
                          },
                        ),
                        errorMessage.isEmpty
                            ? !isReady
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container()
                            : Center(
                          child: Text(errorMessage),
                       )
                     ]),
                ),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: AudioPlayerView())
            ],
          ),

      ),);
  }
}
