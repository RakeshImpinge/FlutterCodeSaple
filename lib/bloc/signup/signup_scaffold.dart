
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_themes.dart';
import '../../services/preferenecs.dart';
import '../../strings.dart';
import '../../ui/signup_form.dart';
import 'sign_up_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode(context)?AppThemes.greyLightColor3:Theme.of(context).primaryColorDark,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: false,
        titleSpacing: 10,
        title: const Text(Strings.signup),
        titleTextStyle: const TextStyle(fontSize: 21),
      ),
      body: Container(color: isDarkMode(context)?AppThemes.darkBlueColor:null,
    child:SafeArea(
        child: BlocProvider(
          create: (_) => SignUpBloc(),
          child: const SignUpForm(),
        )),
      ),
    );
  }
}
