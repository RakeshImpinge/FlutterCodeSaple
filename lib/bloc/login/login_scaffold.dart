import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/login_form.dart';
import '../../services/preferenecs.dart';
import 'login_bloc.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(backgroundColor: isDarkMode(context)?AppThemes.greyLightColor3:Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.of(context).pop();
            }),
          centerTitle: false,titleSpacing: 10,
          title: const Text(Strings.login),titleTextStyle: const TextStyle(fontSize: 21),),
      body: Container(color: isDarkMode(context)?AppThemes.darkBlueColor:null,
      child:SafeArea(
        child: BlocProvider(
          create: (_) => LoginBloc(),
          child: const LoginForm(),
        ),
      )),
    );
  }
}
