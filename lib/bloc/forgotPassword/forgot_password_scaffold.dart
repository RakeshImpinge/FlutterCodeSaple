
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import '../../services/preferenecs.dart';
import '../../utils/assets_name.dart';
import '../../widgets/textformfield.dart';
import '../../widgets/widget.dart';
import 'forgot_password_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordScaffold extends StatelessWidget {
  const ForgotPasswordScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(backgroundColor: isDarkMode(context)?AppThemes.greyLightColor3:Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.of(context).pop();
            }),
          centerTitle: false,titleSpacing: 10,
          title: Text(Strings.forgot_password.toString().substring(0,Strings.forgot_password.length-1)),titleTextStyle: const TextStyle(fontSize: 21),),
      body: Container(color: isDarkMode(context)?AppThemes.darkBlueColor:null,
      child:SafeArea(
        child: BlocProvider(
          create: (_) => ForgotPasswordBloc(),
          child: const ForgotPasswordForm(),
        ),
      )),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);
  @override
  ForgotPasswordFormState createState() => ForgotPasswordFormState();
}

class ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<ForgotPasswordBloc>().add(EmailUnfocused());
      }
    });

  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return backPressGestureDetection(context,BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
      },
      builder: (context, state) => Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(AssetsName.ic_logo,width: 140,height: 130,fit: BoxFit.scaleDown),
                  Padding(padding: const EdgeInsets.only(bottom: 15, top: 15),
                    child: Text(Strings.resources, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Theme.of(context).dividerColor),),),//<= resource text
                  _EmailInputField(focusNode: _emailFocusNode,),
                  const _SendButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));

  }
}


class _EmailInputField extends StatelessWidget {
   _EmailInputField({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
          hint: Strings.email,
          padding: 10,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          cursorColor: Theme.of(context).indicatorColor,
          fillColor: Theme.of(context).disabledColor,
          textStyle: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 18),
          errorTextStyle: const TextStyle(color: AppThemes.deepPinkColor, fontSize: 16),
          errorColor: AppThemes.deepPinkColor,
          focusNode: focusNode,
          error: state.email.invalid ? Strings.invalidEmail : null,
          onChange: (email)=>{
           // value=email,
            context.read<ForgotPasswordBloc>().add(EmailChanged(email: email.trim())),
          print("test>>Email$email====")
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}



class _SendButton extends StatelessWidget {
  const _SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20 ),
                  backgroundColor: state.status.isValidated?Theme.of(context).dividerColor:Theme.of(context).dividerColor.withOpacity(0.8),
                  side:  const BorderSide(width: 2.0, color: Colors.amberAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Text(Strings.send, style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
              ),
              onPressed: () =>state.status.isValidated ?
              submitForm(state.email.value.trim(),context)

              // navigationPage(context,searchGurbani,const SearchGurbani())
                  :null,
              // onPressed: () =>navigationPage(context,searchGurbani,SearchGurbani())
            )
        );
      },
    );
  }
}
/*
 Reset Password functionality
  */
submitForm(String email,BuildContext context)async{

  print("test>>Email$email");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: "${email.trim()}om")
        .then((value) => showAlert(context, "Sent Reset Password email successfully")
        .catchError((e) => showAlert(context, "${e}")));
}


