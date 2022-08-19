// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../strings.dart';

class CheckInternetConnection {
  static bool _isDialogShowing = false;
  static Future<bool> isInternetAvailable() async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    print('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
        'Current status: ${await InternetConnectionChecker().connectionStatus}');
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            print('You are disconnected from the internet.');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 2));
    await listener.cancel();
    return isConnected;
  }
  static void showAlert(BuildContext context, String text) {
    if(!_isDialogShowing) {
      _isDialogShowing = true;
      showGeneralDialog(
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(backgroundColor: Theme.of(context).canvasColor,
                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20.0)),
                  title: Text(Strings.alert, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 20),),
                  content: Text(text, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 18),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _isDialogShowing = false;
                        Navigator.of(context).pop();
                      },
                      child: Text(Strings.okay, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 18),),
                    ),
                  ],
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return const Text(Strings.internetAlertBuilder);
          });
    }
  }
}
